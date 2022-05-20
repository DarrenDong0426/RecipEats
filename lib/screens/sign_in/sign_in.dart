import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/edit_account/newProfile.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/screens/sign_up/sign_up.dart';
import 'package:recipeats/utils/const/color_gradient.dart';
import 'package:recipeats/utils/const/nav_bar.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../home_screen/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String e = '';
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                reusableTextField("Enter Email", Icons.email, false,
                    _emailTextController, TextInputType.emailAddress),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController, TextInputType.visiblePassword),
                const SizedBox(
                  height: 5,
                ),
                Text(e),
                submitButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => navBar()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      e = 'Your email or password is incorrect';
                    });
                  });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have account?",
            style: TextStyle(color: hexStringToColor('454F8C').withOpacity(0.8))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            " Sign Up",
            style: TextStyle(color: hexStringToColor('454F8C').withOpacity(1.0), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

}