import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'hs';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width= MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: appBarMain(context,height,width),
        ),
      );
  }
}
