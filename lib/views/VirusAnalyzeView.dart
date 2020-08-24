import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VirusAnalyzeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VirusAnalyzeViewState();
}

class _VirusAnalyzeViewState extends State<VirusAnalyzeView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Virus exposition analyze"),
      ),
      body: Text ('Hello there'),
    );
  }
}