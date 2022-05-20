import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import 'FollowersCard.dart';

class viewFollowings extends StatefulWidget {

  viewFollowingState createState() => viewFollowingState();

}

class viewFollowingState extends State<viewFollowings>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List Following = [];

  Future<void> getData() async {
    _user = auth.currentUser!;
    uid = _user.uid;
    var docRef = await db.collection('users').doc(uid).get();
    var data = docRef.data();
    Following = data!['following'];
    print(Following);
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Followers",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: Following.length,
          itemBuilder: (context, index){
            return FollowersCard(id: Following[index]);
          },
        ),
      ),
    );
  }
}

