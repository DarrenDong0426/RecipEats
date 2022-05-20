<<<<<<< HEAD
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
       home: FutureBuilder(
        future: _initializeFirebase(),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.done) {
               return SignInScreen();
             }
             else {
               return new CircularProgressIndicator();
             }
           }),
    );
  }
}



=======
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       home: FutureBuilder(
        future: _initializeFirebase(),
           builder: (context, snapshot) {
             if (snapshot.connectionState == ConnectionState.done) {
               return SignInScreen();
             }
             else {
               return new CircularProgressIndicator();
             }
           }),
    );
  }
}



>>>>>>> ebf71b7680f664e1729e0617f4e33201037bdbca
