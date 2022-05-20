import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import 'OtherComments.dart';
import 'OtherProfile.dart';
import 'otherRecipeCardDetails.dart';

class OtherRecipesCardView extends StatefulWidget{

  Map<String, dynamic> recipes = new Map<String, dynamic>();

  OtherRecipesCardView({Key? key, required this.recipes}) : super(key: key);

  _OtherRecipeCardViewState createState() => _OtherRecipeCardViewState();

}

class _OtherRecipeCardViewState extends State<OtherRecipesCardView>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');

  @override
  Widget build(BuildContext context) {
    getImage();
    Map<String, dynamic> data = widget.recipes;
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Column(
              children: <Widget>[
                Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data['id'])));
                        },
                        child: CircleAvatar(
                          backgroundImage: i.image,
                          minRadius: 50,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(data['Name'] + ' by ' + data['Author']),
                    ]
                ),
                Image.network(data['food_image']),
              ],
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeCardDetails(data: data)));
            },
          ),
          Row(
            children: <Widget>[
              LikeButton(likeCount: data['likes'],),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherComments(comments: data['comment']))), icon: Icon(Icons.chat_bubble_outline)),
            ],
          ),
        ],
      ),
    );
  }

  updateFirebase(){
    var likes = widget.recipes['likes'] + 1;
    db.collection('recipes').doc(widget.recipes['Name'] +  widget.recipes['id']).update({'likes': likes});
  }


  void getImage() async {
    final docRef = db.collection('users').doc(widget.recipes['id']);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    setState(() {
      i  = Image.network(userData['pfp']);
    });
  }

}