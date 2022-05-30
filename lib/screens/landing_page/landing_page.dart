
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/edit_account/newProfile.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';
import 'package:recipeats/screens/sign_up/sign_up.dart';
import 'package:recipeats/utils/const/color_gradient.dart';
import 'package:recipeats/utils/const/nav_bar.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../home_screen/home_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
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
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 30,
        elevation: 0,
        /*title: Text(
          "Sign In",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),*/
        //title: Image.asset('assets/images/logo.png', fit: BoxFit.contain, height: 50,),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, 0, 20, 0),
            child: Column(

              children: <Widget>[
                SizedBox(height: 60),
                Container(
                  width: double.infinity,
                height: 450,
                alignment: Alignment.center,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(8.0),
                    color: Color(0xfff2f3f3),
                  ),
                child:
                Padding(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    child: Image.asset("assets/images/logo.png", width: 300),
                    alignment: Alignment.topCenter,
                  ),
                  Align(
                    child: Image.asset("assets/images/cooking2.png", width: 400,),
                    alignment: Alignment.topCenter,
                  )
              ],
            ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0)
                ),
                ),
                SizedBox(height: 40),
                Container(
                  child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Best way to share and find recipes!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                          SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                    child: ElevatedButton(
                      onPressed: () => {
                      Navigator.push(context,
                       MaterialPageRoute(builder: (context) => SignUpScreen()))
                      },
                      child: Text(
                        "Sign Up",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color(0xffd76b5b);
                            }
                            return Color(0xffd76b5b);
                          }),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                    ),
                  ),
                          //SizedBox(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
                            child: ElevatedButton(
                              onPressed: () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SignInScreen()))
                              },
                              child: Text(
                                "Sign In",
                                style: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              style: ButtonStyle(
                                  //side: BorderSide(width: 5.0, color: Colors.red,),
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.white;
                                    }
                                    return Colors.white;
                                  }),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),       side: BorderSide(color: Color(0xffd76b5b))
                                      ),),),
                            ),
                          ),
                        ],
                      )
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  /*Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?",
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
  }*/
}