
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import '../notification/notification.dart';
import '../search_recipes/OtherRecipesCardview.dart';

class Home_Screen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List Following = [];
  late List followerPosts = [];


  Future<void> getData() async {
    _user = auth.currentUser!;
    uid = _user.uid;
    var docRef = await db.collection('users').doc(uid).get();
    var data = docRef.data();
    Following = data!['following'];
    await db.collection('recipes').get().then((value) => value.docs.forEach((result) {
      dynamic data = result.data();
      if (Following.indexOf(data['id']) != -1){
        followerPosts.add(data);
      }
  }));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: getChild(),
      ),
    );
  }

  getChild() {
    if (Following.length == 0) {
      return Center(child: Text(
          "You are not following anyone currently. Start following users to see their posts."));
    }
    else{
      return ListView.builder(
        itemCount: Following.length,
        itemBuilder: (context, index){
          return OtherRecipesCardView(recipes: followerPosts[index]);
        },
      );
    }
  }

}