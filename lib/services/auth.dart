import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_app/helper/helperfunctions.dart';
import 'package:flutter_chat_app/model/chatuser.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatUser _userFromFirebaseUser(User user) {
    if (user != null) {
      return ChatUser(uid: user.uid);
    } else {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future changePassword(String email, String password) async {
    try {
      // TODO: create changepassword method
      return await null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> signInWithGoogle(BuildContext context) async {
    //TODO: implement method
    return null;
  }

  Future signOut() async {
    try {
      await HelperFunctions.resetUerSharedPreferences();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
