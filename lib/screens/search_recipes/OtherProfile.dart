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
import 'package:recipeats/screens/search_recipes/viewOtherFollowers.dart';
import 'package:recipeats/screens/search_recipes/viewOtherFollowings.dart';
import 'package:recipeats/screens/sign_in/sign_in.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/nav_bar.dart';
import '../my_recipes/my_recipes.dart';
import 'OtherRecipeList.dart';

class OtherProfile extends StatefulWidget {

  late String id;

  OtherProfile({Key? key, required this.id}) : super(key: key);

  @override
  _OtherProfileState createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile>{

  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  late List following = [];
  late List followers = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _EmailTextController = TextEditingController();
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _birthdayTextController = TextEditingController();
  TextEditingController _biographyTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  late String url = '';
  late String currId = '';
  int posts = 0;
  List numOfFollowings = [];


  Future<dynamic> getDocSnap() async{
    final docRefOther = db.collection('users').doc(uid);
    DocumentSnapshot docSnapOther = await docRefOther.get();
    dynamic dataOther = docSnapOther.data();
    _userTextController.text = dataOther['user'];
    _birthdayTextController.text = dataOther['birthday'];
    _phoneTextController.text = dataOther['phone'];
    _biographyTextController.text = dataOther['biography'];
    url = dataOther['pfp'];
    posts = dataOther['posts'];
    followers = dataOther['followers'];
    numOfFollowings = dataOther['following'];

    setState(() {
      i = Image.network(url);
    });

    currId = auth.currentUser!.uid;
    final docRefCurr = db.collection('users').doc(currId);
    DocumentSnapshot docSnapCurr = await docRefCurr.get();
    dynamic dataCurr = docSnapCurr.data();
    following = dataCurr['following'];
  }

  @override
  Widget build(BuildContext context) {
    uid = widget.id;
    getDocSnap();

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: hexStringToColor('3A3B3C'),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
          ),
        ),
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
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowers(uid: uid))), child: Text('Followers:\n' + followers.length.toString(), style: TextStyle(fontSize: 13),),),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowings(uid: uid,))), child: Text('Followings:\n' + numOfFollowings.length.toString(), style: TextStyle(fontSize: 13),)),
                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeList(id: uid))), child: Text('My Recipes:\n' + posts.toString(), style: TextStyle(fontSize: 13),)),
                          ],
                        ),
                        SizedBox(
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
                        FollowButton(),
                      ],
                    )
                )
            )
        )
    );
  }

  FollowButton(){
    if (following.indexOf(uid) == -1){
      return TextButton(onPressed: () => updateFirebase(false), child: Text("Follow"));
    }
    else{
      return TextButton(onPressed: () => updateFirebase(true), child: Text("Unfollow"));
    }
  }

  updateFirebase(bool isFollowing){
    if (!isFollowing){
      following.add(uid);
      db.collection('users').doc(currId).update({'following': following});
      followers.add(currId);
      db.collection('users').doc(uid).update({'followers': followers});
    }
    else{
      following.remove(uid);
      db.collection('users').doc(currId).update({'following': following});
      followers.remove(currId);
      db.collection('users').doc(uid).update({'followers': followers});
    }
    setState(() {});
  }

}