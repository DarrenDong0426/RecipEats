import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:recipeats/screens/edit_account/Profile.dart';
import 'package:recipeats/screens/home_screen/home_screen.dart';
import 'package:recipeats/screens/my_recipes/myRecipeCardDetails.dart';

import 'MyComments.dart';

class MyRecipeCardView extends StatefulWidget{

  Map<String, dynamic> recipes = new Map<String, dynamic>();

  MyRecipeCardView({Key? key, required this.recipes}) : super(key: key);

  _myRecipeCardViewState createState() => _myRecipeCardViewState();

}

class _myRecipeCardViewState extends State<MyRecipeCardView>{

  FirebaseFirestore db = FirebaseFirestore.instance;

  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  List favorite = [];
  bool Liked = false;
  int numsOfLike = 0;
  String uid = '';
  dynamic recipeData;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => myRecipeCardDetails(data: data)));
            },
          ),
          Row(
            children: <Widget>[
              LikeButton(likeCount: numsOfLike, isLiked: Liked, onTap: updateFirebase),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => myComments(comments: data['comment']))), icon: Icon(Icons.chat_bubble_outline)),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> updateFirebase(bool isLiked) async{
    if (isLiked){
      var likes = recipeData['likes'] - 1;
      print(recipeData);
      print(isLiked);
      favorite.remove(recipeData['Name'] +  recipeData['id']);
      db.collection('recipes').doc(
          recipeData['Name'] + recipeData['id']).update(
          {'likes': likes});
      db.collection('users').doc(recipeData['id']).update(
          {"favorite_post": favorite});
    }
    else {
      print(recipeData);
      var likes = recipeData['likes'] + 1;
      print(isLiked);
      favorite.add(recipeData['Name'] +  recipeData['id']);
      db.collection('recipes').doc(
          recipeData['Name'] + recipeData['id']).update(
          {'likes': likes});
      db.collection('users').doc(recipeData['id']).update(
          {"favorite_post": favorite});
    }
    final docRef2 = db.collection('recipes').doc(uid);
    DocumentSnapshot docSnap2 = await docRef2.get();
    recipeData = docSnap2.data();
    setState(() {
      Liked = !Liked;
      numsOfLike = recipeData['likes'];
    });
    return Liked;
  }

  void getData() async {
    final docRef = db.collection('users').doc(widget.recipes['id']);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    if (userData['favorite_post'].indexOf(widget.recipes['Name'] +  widget.recipes['id']) == -1){
      Liked = false;
    }
    else{
      Liked = true;
    }
    uid = widget.recipes['Name'] + widget.recipes['id'];
    final docRef2 = db.collection('recipes').doc(uid);
    DocumentSnapshot docSnap2 = await docRef2.get();
    recipeData = docSnap2.data();
    print(recipeData);
    if (mounted) {
      setState(() {
        numsOfLike = recipeData['likes'];
        i = Image.network(userData['pfp']);
        favorite = userData['favorite_post'];
      });
    }
  }
}