import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_kimber/helperFunction.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/screens/ProfilePage.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';

class NavBarWid extends StatelessWidget {
  NavBarWid({this.name, this.emailAddress,this.width});

  final Widget name;
  final String emailAddress;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Drawer(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
                        gradient: LineGrad,

                      ),
                      accountName: name,
                      accountEmail: Text(emailAddress),
                    ),
                  ),
                  Divider(),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Profile'),
                          leading: Icon(Icons.lightbulb_outline,color: Colors.yellowAccent,),
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context){
                                  return ProfilePage(name: name,);
                                }));
                          },
                        ),
                        ListTile(
                          title: Text('ToDO'),
                          leading: Icon(Icons.list,color: Colors.yellowAccent,),
                          onTap: (){},
                        ),
                        ListTile(
                          title: Text('Settings'),
                          leading: Icon(Icons.settings,color: Colors.yellowAccent,),
                          onTap: (){},
                        ),
                        ListTile(
                          title: Text('Friends'),
                          leading: Icon(Icons.people_alt,color: Colors.yellowAccent,),
                          onTap: (){},
                        ),
                      ],

                    ),
                  ),

                  Divider(),



                    ],

              ),
              Column(
                children: [
                  Divider(),
                  ListTile(
                    onTap: (){
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignIn();
                          },
                        ),
                      );
                    },
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: IconButton(
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.yellowAccent,
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                    ),
                    title: Text('Log Out',style:TextStyle(color: Colors.yellowAccent),),),
                ],
              ),
            ],
          ),
        ),

    );
  }
}
