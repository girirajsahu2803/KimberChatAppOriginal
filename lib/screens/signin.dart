import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_kimber/screens/Error404.dart';
import 'package:flutter_app_kimber/utils/utilsf.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
//------------Screens-----------------------------------------------------------
import 'package:flutter_app_kimber/screens/Screen0.dart';
import 'package:flutter_app_kimber/screens/signup.dart';
import 'package:flutter_app_kimber/screens/signin.dart';
import 'package:flutter_app_kimber/screens/forgetPassword.dart';
import 'package:flutter_app_kimber/screens/chatRoom.dart';
import 'package:flutter_app_kimber/screens/Error404.dart';

import '../helperFunction.dart';

//-------------------------------------------------------------------
class SignIn extends StatefulWidget {
  static String id = 'signIn';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final messageTextController = TextEditingController();
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  String email;
  String password;
  bool obscureText = true;
  bool modal = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: modal,
        child: Scaffold(
          appBar: appBarMain(context,height,width),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 100),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Flexible(
                            child: Container(
                                height: height / 7,
                                width: height / 7,
                                child: Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                        'images/Light_Green_Bulb_Children___Kids_Logo-removebg-preview.png'))),
                          ),
                        ),
                        TypewriterAnimatedTextKit(
                          text: ['Kimber'],
                          textStyle: TextStyle(
                            fontSize: height / 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          // ignore: missing_return
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDec,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          validator: (value) {
                            String x = value;
                            return (x.length < 6 || value.isEmpty)
                                ? 'Password should be atleast 6 characters'
                                : null;
                          },
                          controller: messageTextController,
                          obscureText: obscureText,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: InputDec.copyWith(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (obscureText == true) {
                                      obscureText = false;

                                    } else {
                                      obscureText = true;
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Color(0xFF3366FF),
                                ),
                              ),
                              hintText: 'password'),
                        ),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            print(email);
                            print(password);
                            try {
                              setState(() {
                                modal = true;
                              });
                              final newUser = await _firebaseauth
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);
                              HelperFunction.saveuserName(email);
                              if (newUser != null) {
                                Navigator.pushReplacementNamed(
                                    context, ChatRoom.id);
                                messageTextController.clear();
                                setState(() {
                                  modal = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                              setState(() {
                                modal = false;
                              });
                              //    Navigator.pushNamed(context, Error.id);

                            }
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  gradient: LineGrad,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(1000.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                    child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800),
                                )),
                              )),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1000.0))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Center(
                                  child: Text(
                                'Sign In with Google',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800),
                              )),
                            )),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Dont have an account ?',
                                    style: TextStyle(color: Colors.white24,fontSize: 12),
                                  )),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SignUP.id);
                                },
                                child: Text(
                                  'Register Now',
                                  style: TextStyle(color: Colors.white60),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmaPass extends StatefulWidget {
  EmaPass({this.email, this.password});

  final email;
  final password;

  @override
  _EmaPassState createState() => _EmaPassState();
}

class _EmaPassState extends State<EmaPass> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.email);
        print(widget.password);
      },
      child: Container(
          decoration: BoxDecoration(
              gradient: LineGrad,
              // color:Color(0xFF3366FF) ,
              borderRadius: BorderRadius.all(Radius.circular(1000.0))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
                child: Text(
              'Sign In',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            )),
          )),
    );
  }
}
