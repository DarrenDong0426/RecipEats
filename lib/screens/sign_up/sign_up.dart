<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/data/firebase/info.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/utils/const/color_gradient.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../edit_account/newProfile.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  String error = '';
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _repasswordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.close_rounded),
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Add Recipe",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/logo.png'),
                    reusableTextField("Enter Email", Icons.person_outline, false,
                        _emailTextController, TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController, TextInputType.visiblePassword),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Re-Enter Password", Icons.lock_outlined, true,
                        _repasswordTextController, TextInputType.visiblePassword),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(error),
                    submitButton(context, "Sign Up", () async {
                      SignUp();
                    })
                  ],
                ),
              ))),
    );
  }

  SignUp() async {
    try {
      if (_passwordTextController.text != _repasswordTextController.text){
        setState(() {
          error = "Password does not match!";
        });
      }
      else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text
        );
        User? user = auth.currentUser;
        uid = user!.uid;
        setEmail(_emailTextController.text);
        setPassword(_passwordTextController.text);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                newProfile(email: _emailTextController,
                    password: _passwordTextController,
                    id: uid)));
      }
    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        if (kDebugMode) {
          print(e.code);
        }
      }
  }
=======
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/data/firebase/info.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/utils/const/color_gradient.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _repasswordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                hexStringToColor("CB2B93"),
                hexStringToColor("9546C4"),
                hexStringToColor("5E61F4")
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Re-Enter Password", Icons.lock_outlined, true,
                        _repasswordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(context, "Sign Up", () async {
                      SignUp();
                    })
                  ],
                ),
              ))),
    );
  }

  SignUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text
      );
      setEmail(_emailTextController.text);
      setPassword(_passwordTextController.text);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Search_Recipes()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      print(e.code);
    }
  }
>>>>>>> ebf71b7680f664e1729e0617f4e33201037bdbca
}