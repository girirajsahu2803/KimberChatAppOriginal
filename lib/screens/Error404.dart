import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';

class Error extends StatefulWidget {
  static String id = 'signIn';
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please recheck the Email and the Password',
                style: TextStyle(
                    color: Colors.white24,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
              // TextButton(onPressed: (){
              //   Navigator.pop(context);
              // }, child: Text('Recheck', style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 15,
              //     fontWeight: FontWeight.w800),),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
