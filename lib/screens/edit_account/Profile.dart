import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeats/screens/edit_account/viewFollowers.dart';
import 'package:recipeats/screens/edit_account/viewFollowings.dart';
import 'package:recipeats/screens/home_screen/home_screen.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/nav_bar.dart';
import '../my_recipes/my_recipes.dart';
import 'edit_account.dart';

class Profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile>{

  late Image i = Image.asset('assets/images/emptyPfp.jpg');

  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _EmailTextController = TextEditingController();
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _birthdayTextController = TextEditingController();
  TextEditingController _biographyTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  late String url = '';
  int posts = 0;
  int followers = 0;
  int followings = 0;

  Future<dynamic> getDocSnap() async{
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
      _userTextController.text = data['user'];
      _birthdayTextController.text = data['birthday'];
      _phoneTextController.text = data['phone'];
      _biographyTextController.text = data['biography'];
      url = data['pfp'];
      posts = data['posts'];
      followers = data['followers'].length;
      followings = data['following'].length;
      if (mounted) {
        setState(() {
          i = Image.network(url);
        });
      }

  }

  Future<void> _signOut() async {
    await auth.signOut();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SignInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    /** _prevEmailTextController = widget.email; **/
    User? user = auth.currentUser;
    uid = user!.uid;
    _EmailTextController.text = user.email!;
    getDocSnap();

    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: i.image,
                              minRadius: 50,
                              backgroundColor: Colors.white,
                            ),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewFollowers())), child: Text('Followers:\n' + followers.toString(), style: TextStyle(fontSize: 13),),),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewFollowings())), child: Text('Followings:\n' + followings.toString(), style: TextStyle(fontSize: 13),)),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => myRecipeList())), child: Text('My Recipes:\n' + posts.toString(), style: TextStyle(fontSize: 13),)),

                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Email: " + _EmailTextController.text),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Username: " + _userTextController.text),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Birthday: " + _birthdayTextController.text),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Phone Number: " + _phoneTextController.text),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Biography: " + _biographyTextController.text),
                        const SizedBox(
                          height: 20,
                        ),
                        submitButton(context, "Edit", () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Edit_Account()));
                        }),
                        submitButton(context, "Sign Out", () async {
                          _signOut();
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
                        })
                      ],
                    )
                )
            )
        )
    );
  }
}