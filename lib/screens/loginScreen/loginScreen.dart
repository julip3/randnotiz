import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/material.dart';
import 'package:randnotiz/screens/notesScreen/notesScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
User user = FirebaseAuth.instance.currentUser;

class LoginScreen extends StatelessWidget {
  Future<String> _createUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: data.name, password: data.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return ('The account already exists for that email.');
      } else {
        print(e.code);
        return (e.code);
      }
    }
    await user.sendEmailVerification();
    firestore
        .collection('users')
        .doc(user.uid)
        .collection("noteCategory")
        .doc("default Category")
        .collection("notes")
        .add({"title": "Le Title", "text": "data"}).catchError((e) {
      print(e);
    });
  }

  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: data.name, password: data.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return ('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return ('Wrong password provided for that user.');
      } else {
        print(e.code);
        return (e.code);
      }
    }
    if (!user.emailVerified) {
      print('Please check ur email to verify ur account');
      return ('Please check ur email to verify ur account');
    }
  }

  Future<String> _recoverPassword(String name) {
    //TODO sent recover password code to email
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Randnotiz',
      //logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSignup: _createUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NotesScreen(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
