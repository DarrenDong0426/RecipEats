
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.close_rounded),
        iconTheme: IconThemeData(
          color: hexStringToColor('3c403a'),
        ),
        backgroundColor: Colors.transparent,
        //automaticallyImplyLeading: false,
        //titleSpacing: 30,
        elevation: 0,
        /*title: Text(
          "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),*/
        //title: Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
      ),

     /* body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                Padding(
                    child: Image.asset('assets/images/cooking.png'),
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 30)
                ),
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
      ),*/
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                //padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60),
                    Padding(
                        child: Image.asset('assets/images/signin.png', height: 270,),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0)
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        color: Color(0xfff2f3f3),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 40, 10, 100),
                        child: Column(
                          children: <Widget>[
                            Text("Sign In", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: hexStringToColor('3c403a')),),
                            SizedBox(height: 20),
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
                    /*reusableTextField("Enter Email", Icons.person_outline, false,
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
                    }),*/

                  ],
                ),
              ))),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
            style: TextStyle(color: hexStringToColor('627f68').withOpacity(0.8))),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            " Sign Up",
            style: TextStyle(color: hexStringToColor('3c403a').withOpacity(1.0), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}