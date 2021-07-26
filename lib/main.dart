import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/screens/Screen0.dart';
import 'package:flutter_app_kimber/screens/signup.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/screens/forgetPassword.dart';
import 'package:flutter_app_kimber/screens/chatRoom.dart';
import 'package:flutter_app_kimber/screens/Error404.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth _firebaseAuth =FirebaseAuth.instance;
  final user =FirebaseAuth.instance.currentUser;
  var initScreen;
  String getInitScreen(){
    if (user != null) {
      return ChatRoom.id;
    } else {
      return SignIn.id;
    }
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1F1F1F),
        primaryColor: Colors.blueAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      routes: {

        HomeScreen.id:(context)=>HomeScreen(),
        ChatRoom.id :(context)=>ChatRoom(),
        SignIn.id :(context)=>SignIn(),
        SignUP.id :(context)=>SignUP(),
        Fpass.id:(context)=>Fpass(),
        //Error.id:(context)=>Error(),

      },
      initialRoute:getInitScreen(),
    );
  }
}

