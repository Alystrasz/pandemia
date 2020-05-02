import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandemia/data/database/database.dart';
import 'package:pandemia/data/database/models/Favorite.dart';
import 'package:pandemia/utils/CustomPalette.dart';
import 'package:pandemia/utils/charts/barChart.dart';
import 'package:pandemia/views/favorites/view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FavoritesState extends State<FavoritesView> {
  AppDatabase db = new AppDatabase();
  final List<Favorite> _data = new List();
  RefreshController _refreshController =
    RefreshController(initialRefresh: false);

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 2000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    if(mounted)
      setState((){});
    _refreshController.loadComplete();
  }

  void _showDialog(Favorite item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Remove place"),
          content: new Text("Do you want to remove ${item.name} from your favorite places?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Remove"),
              onPressed: () {
                Navigator.of(context).pop();
                db.removeFavoritePlace(item.id)
                .then((_) {
                  setState(() {
                    _data.removeWhere((i) => i == item);
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Favorite>>(
        future: db.getFavoritePlaces(),
        builder: (context, AsyncSnapshot<List<Favorite>> snapshot) {
          if (!snapshot.hasData || snapshot.data.length == 0) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center (
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: new Text(
                        "Nothing to see here!",
                        style: TextStyle(
                            color: CustomPalette.text[100],
                            fontSize: 20,
                            fontWeight: FontWeight.w300
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                    ),

                    Container(
                        child: new Text(
                          "Try to add places via the Places view.",
                          style: TextStyle(
                              color: CustomPalette.text[600],
                              fontSize: 18,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 35.0, horizontal: 10.0)
                    )
                  ],
                )
              );
            } else {
              return CircularProgressIndicator();
            }
          }

          if (_data.length == 0) {
            _data.clear();
            _data.addAll(snapshot.data);
            print('building ${snapshot.data.length} items');
          }

          return SafeArea(
              child: Scaffold(
                body: SmartRefresher(
                    enablePullDown: true,
                    header: ClassicHeader(
                      idleText: "Pull to refresh metrics",
                      releaseText: "Release to refresh metrics",
                      refreshingText: "Computing metrics...",
                      completeText: "Results imported."),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          child: _buildPanel(),
                          padding: EdgeInsets.all(20),
                        ),
                      ),
                    )
                ),

                backgroundColor: CustomPalette.background[700]
              )
          );
        }
    );
  }

  Widget _buildPanel() {
    return
      Container(
        margin: EdgeInsets.all(0),
        child: Theme(
          data: Theme.of(context).copyWith(
              cardColor: CustomPalette.background[500],
          ),
          child:ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                for (var i=0, len=_data.length; i<len; i++) {
                  _data[i].isExpanded =
                  i == index ? !isExpanded : false;
                }
              });
            },
            children: _data.map<ExpansionPanel>((Favorite item) {
              return ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return GestureDetector(
                    onLongPress: () => _showDialog(item),
                    child: Container (
                      margin: EdgeInsets.all(0),
                      child: ListTile(
                        title: Text(item.name, style: TextStyle(color: CustomPalette.text[200])),
                        subtitle: Text(item.address,
                          style: TextStyle(color: CustomPalette.text[500]),
                          overflow: TextOverflow.ellipsis,
                          maxLines: isExpanded ? 3 : 1,
                        ),
                      ),
                    )
                  );
                },
                body: Card(
                  margin: EdgeInsets.all(0),
                  shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.zero,
                  ) ,
                  borderOnForeground: true,
                  color: CustomPalette.background[600],
                  child: Container (
                    height: 200,
                    child: SimpleBarChart.withSampleData(),
                  ),
                ),
                isExpanded: item.isExpanded
              );
            }).toList(),
          )
        )
      );
  }
}