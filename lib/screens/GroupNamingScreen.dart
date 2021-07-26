import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/auth.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/utils/Navbar.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../helperFunction.dart';
import 'actualChattingScreen.dart';
import 'searchScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GroupNaming extends StatefulWidget {
  @override
  _GroupNamingState createState() => _GroupNamingState();
}

class _GroupNamingState extends State<GroupNaming> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    TextEditingController nameTextEditing = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBarMain(context, height, width),
      body: Hero(
       // tag:'popInfoBar',
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  decoration: BoxDecoration(
                 borderRadius: BorderRadius.all(Radius.circular((50))),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    color: Colors.black,
                  ),
                  height: height / 1.5,
                  width: width / 1.3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Name'),
                        TextField(
                          controller: nameTextEditing,
                          // ignore: missing_return
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDec.copyWith(hintText: 'GroupName'),
                        ),
                        Text('Description'),
                        TextField(
                          maxLines: 8,
                          controller: nameTextEditing,
                          // ignore: missing_return
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: InputDec.copyWith(
                            hintText: 'Description',
                            //suffixIcon: FaIcon(FontAwesomeIcons.pen),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
