
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
    if (mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: Icon(Icons.close_rounded),
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: getChild(),
      ),
    );
  }

  getChild() {
    if (followerPosts.length == 0) {
      return Padding(
          padding: EdgeInsets.all(35),
          child: Center(child: Text(
            "You are not following anyone currently with any posts. Start following users to see their posts.",))
      );
    }
    else{
      return ListView.builder(
        itemCount: followerPosts.length,
        itemBuilder: (context, index){
          return OtherRecipesCardView(recipes: followerPosts[index]);
        },
      );
    }
  }

}