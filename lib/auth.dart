import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthMethod{
  final FirebaseAuth _auth =FirebaseAuth.instance;

  Future signInWithEmail(String email,String password)async{
    try{
      UserCredential result =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser =result.user;
    }catch(e){print(e);}

  }

}