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
import '../../utils/const/loading.dart';
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
    if (mounted) {
      setState(() {
        i = Image.network(url);
      });
    }

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
    return FutureBuilder(future: getDocSnap(), builder: (context, snapshot){
      if (url == ''){
        return Loading();
      }
      else{
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: hexStringToColor('3c403a'),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                _userTextController.text,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),
              ),
            ),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: i.image,
                                  maxRadius: 40,
                                  backgroundColor: Colors.white,
                                ),
                                Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Row(
                                          children: <Widget>[
                                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowers(uid: uid))),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("Followers", style: TextStyle(fontSize: 17, color: hexStringToColor('3c403a')),),
                                                    Container(height: 5),
                                                    Text(followers.length.toString(), style: TextStyle(fontSize: 14, color: Color(0xffd76b5b)),)
                                                  ],
                                                )),
                                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowings(uid: uid,))),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("Following", style: TextStyle(fontSize: 17, color: Colors.black),),
                                                    Container(height: 5),
                                                    Text(numOfFollowings.length.toString(), style: TextStyle(fontSize: 14, color: Color(0xffd76b5b)),)
                                                  ],
                                                )),
                                            TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeList(id: uid))),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text("Posts", style: TextStyle(fontSize: 17, color: Colors.black),),
                                                    Container(height: 5),
                                                    Text(posts.toString(), style: TextStyle(fontSize: 14, color: Color(0xffd76b5b)),)
                                                  ],
                                                ))
                                          ]
                                      ),
                                      Row(

                                        children: <Widget>[
                                          FollowButton()
                                        ],

                                      )

                                    ]
                                )
                                /*TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowers(uid: uid))), child: Text('Followers:\n' + followers.length.toString(), style: TextStyle(fontSize: 13),),),
                                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => viewOtherFollowings(uid: uid,))), child: Text('Followings:\n' + numOfFollowings.length.toString(), style: TextStyle(fontSize: 13),)),
                                TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeList(id: uid))), child: Text('My Recipes:\n' + posts.toString(), style: TextStyle(fontSize: 13),)),*/
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                              child:  Align(
                                alignment: Alignment.centerLeft,
                                child: Text(_userTextController.text, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child:   Align(
                                alignment: Alignment.centerLeft,
                                child: Text(_biographyTextController.text, style: TextStyle(fontSize: 14)),
                              ),
                            ),
                            /*SizedBox(
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
                            FollowButton(),*/
                          ],
                        )
                    )
                )
            )
        );
      }
    });

  }

  FollowButton(){
    if (following.indexOf(uid) == -1){
      //return TextButton(onPressed: () => updateFirebase(false), child: Text("Follow"));
      return  Container(
        width: 250,
        height: 35,
        //constraints: BoxConstraints.expand(),

        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton(
          onPressed: () => updateFirebase(false),
          child: Text(
            "Follow",
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
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
        ),
      );
    }
    else{
      return  Container(
        width: 250,
        height: 35,
        //constraints: BoxConstraints.expand(),

        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: ElevatedButton(
          onPressed: () => updateFirebase(true),
          child: Text(
            "Unfollow",
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
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
        ),
      );
    }
  }

  updateFirebase(bool isFollowing){
    if (!isFollowing){
      following.add(uid);
      db.collection('users').doc(currId).update({'following': following});
      followers.add(currId);
      db.collection('users').doc(uid).update({'followers': followers});
      addNotif();
    }
    else{
      following.remove(uid);
      db.collection('users').doc(currId).update({'following': following});
      followers.remove(currId);
      db.collection('users').doc(uid).update({'followers': followers});
    }
    setState(() {});
  }

  Future<void> addNotif() async {
    var docRef = await db.collection('users').doc(uid).get();
    var data = docRef.data();
    List userId = data!['notifs']['uid'];
    userId.add(currId);
    var docRef2 = await db.collection('users').doc(currId).get();
    var data2 = docRef2.data();
    var username = data2!['user'];
    List messages = data['notifs']['message'];
    messages.add('$username started following you');
    List recipe = data['notifs']['recipeId'];
    recipe.add("");
    Map<String, dynamic> map = {'uid': userId, 'message': messages, 'recipeId': recipe};
    db.collection('users').doc(uid).update({"notifs": map});
  }

}