import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/loading.dart';
import 'notifCard.dart';

class notification extends StatefulWidget{
  @override
  _notificationState createState() => _notificationState();
}

class _notificationState extends State<notification>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  late String uid;
  dynamic data;
  Map<String, dynamic> map = {'uid': [], 'message': [], 'recipeId': []};


  Future<void> getData() async {
    user = auth.currentUser!;
    uid = user.uid;
    var docRef = await db.collection('users').doc(uid).get();
    data = docRef.data();
    map = data!['notifs'];
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      if (data == null){
        return Loading();
      }
      else{
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            // leading: Icon(Icons.close_rounded),
            iconTheme: IconThemeData(
              color: hexStringToColor('3A3B3C'),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text(
              "Notifications",
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
    });
  }

  getChild() {
    if (map['uid'].length == 0) {
      return Padding(
          padding: EdgeInsets.all(35),
          child: Center(child: Text(
            "You have no notifications currently",))
      );
    }
    else {
      return ListView.builder(
        itemCount: map['uid'].length,
        itemBuilder: (context, index) {
          return notificationCard(uid: map['uid'][index],
              message: map['message'][index],
              recipeId: map['recipeId'][index]);
        },
      );
    }
  }



}