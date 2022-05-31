
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/utils/const/color_gradient.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';

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
            color: hexStringToColor('3c403a'),
        ),
        backgroundColor: Colors.white,
        //automaticallyImplyLeading: false,

        elevation: 0,
        /*title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),*/
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                //padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60),
                    Padding(
                      child: Image.asset('assets/images/welcome.png', height: 270,),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0)
                    ),
                    Container(
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(8.0),
                        //color: Color(0xfff2f3f3),
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
                        child: Column(
                          children: <Widget>[
                            Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),),
                            SizedBox(height: 20),
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
                        Text(error),
                        submitButton(context, "Sign Up", () async {
                          SignUp();
                        }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already have an account?",
                                    style: TextStyle(color: hexStringToColor('627f68').withOpacity(0.8))),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => SignInScreen()));
                                  },
                                  child: Text(
                                    " Sign In",
                                    style: TextStyle(color: hexStringToColor('3c403a').withOpacity(1.0), fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                newProfile(email: _emailTextController,
                    password: _passwordTextController,
                    id: uid)));
      }
    } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email') {
          setState(() {
            error = "Invalid email!";
          });
        }
        if (e.code == 'email-already-exists') {
          setState(() {
            error = "Email already in use!";
          });
        }
        if (kDebugMode) {
          print(e.code);
        }
      }
  }
}