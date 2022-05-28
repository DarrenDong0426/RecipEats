import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../my_recipes/MyComments.dart';
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
  List favorite = [];
  bool Liked = false;
  List ratings = [];
  int numsOfLike = 0;
  String uid = '';
  dynamic recipeData;
  String userid = '';

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
                /*Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data['id'])));
                        },
                        child: CircleAvatar(
                          backgroundImage: i.image,
                          maxRadius: 30,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(data['Name'] + ' by ' + data['Author']),
                    ]
                ),*/
                Padding(
                  padding: EdgeInsets.all(15),
                child:
                    Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data['id'])));
                        },
                        child: CircleAvatar(
                          backgroundImage: i.image,
                          maxRadius: 30,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Container(width: 15),
                      Text(data['Author'], style: TextStyle( fontSize: 19),),
                    ],
                  )
                  ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(data['food_image'], width: 500, height: 370, fit: BoxFit.fill, alignment: Alignment.center,
                 ),

                ),


                  Row(
                    children: <Widget>[
                      LikeButton(likeCount: numsOfLike, isLiked: Liked, onTap: updateFirebase),
                      IconButton(onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => myComments(id: data['Name'] + data['id'])))},
                        icon: Icon(Icons.chat_bubble_outline),),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child:                   Text(data['Name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.left,),

                  ),



                ]
                )
                )
              ],
            ),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeCardDetails(data: data)));
            },
          ),
          /*Row(
            children: <Widget>[
              LikeButton(likeCount: numsOfLike, isLiked: Liked, onTap: updateFirebase),
              IconButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OtherComments(comments: data['comment']))), icon: Icon(Icons.chat_bubble_outline)),
              Text('Ratings: ' + getRating() + '/5'),
            ],
          ),*/
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
      db.collection('users').doc(userid).update(
          {"favorite_post": favorite});
    }
    else {
      getNotifs();
      var likes = recipeData['likes'] + 1;
      print(recipeData);
      print(isLiked);
      favorite.add(recipeData['Name'] +  recipeData['id']);
      db.collection('recipes').doc(
          recipeData['Name'] + recipeData['id']).update(
          {'likes': likes});
      db.collection('users').doc(userid).update(
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
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    String? id = user?.uid;
    final docRef = db.collection('users').doc(id);
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
    if (mounted) {
      setState(() {
        ratings = recipeData['Rating'];
        userid = id!;
        numsOfLike = recipeData['likes'];
        i = Image.network(userData['pfp']);
        favorite = userData['favorite_post'];
      });
    }
  }

  String getRating() {
    num max = 0;
    for (int i = 0; i < ratings.length; i++){
      max += ratings[i];
    }
    if (max == 0){
      return 0.toString();
    }
    return (max / ratings.length).toString();
  }

  Future<void> getNotifs() async {
    var docRef = await db.collection('users').doc(recipeData['id']).get();
    var data = docRef.data();
    List userId = data!['notifs']['uid'];
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    String? id = user?.uid;
    userId.add(id);
    var docRef2 = await db.collection('users').doc(id).get();
    var data2 = docRef2.data();
    var username = data2!['user'];
    List messages = data['notifs']['message'];
    messages.add('$username liked your post');
    List recipe = data['notifs']['recipeId'];
    recipe.add(recipeData['Name'] + recipeData['id']);
    Map<String, dynamic> map = {'uid': userId, 'message': messages, 'recipeId': recipe};
    db.collection('users').doc(recipeData['id']).update({"notifs": map});
  }

}