import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:recipeats/utils/const/loading.dart';

import '../../utils/const/color_gradient.dart';
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
  Image i = Image.asset('assets/images/emptyPfp.jpg');

  Image z = Image.asset('assets/images/emptyPfp.jpg');
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
  }


  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.recipes;
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      if (i.toString() == z.toString()){
        return Loading();
      }
      else{
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
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 25),
                        child:
                        Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(

                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(12, 0, 12, 8),
                                      child: Row(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data['id'])));
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: i.image,
                                              maxRadius: 25,
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                          Container(width: 15),
                                          Text(data['Author'], style: TextStyle( fontSize: 15, fontWeight: FontWeight.bold,color: hexStringToColor('3c403a')),),
                                        ],
                                      )
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(data['food_image'], width: 500, height: 270, fit: BoxFit.fill, alignment: Alignment.center,
                                    ),

                                  ),


                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      LikeButton(likeCount: numsOfLike, isLiked: Liked, onTap: updateFirebase, circleColor:
                                      CircleColor(start: Colors.white, end: Color(0xff0099cc))),
                                      IconButton(onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => myComments(id: data['Name'] + data['id'])))},
                                        icon: Icon(Icons.chat_bubble_outline),),
                                      IconButton(onPressed: () => {},
                                        icon: Icon(Icons.share),),
                                      Text('Rating: ' + getRating() + '/5'),
                                    ],
                                  ),
                                  Column(

                                      children: <Widget>[
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Text(data['Name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: hexStringToColor('3c403a'))),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child:
                                          Text(data['time'], style: TextStyle(fontSize: 13)),
                                        )
                                      ]),
                                  /* Align(
                    alignment: Alignment.centerLeft,
                    child:
                    Column(

                    children: <Widget>[
                      Text(data['Name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(data['time'], style: TextStyle(fontSize: 15)),

                    ])
                  ),*/



                                ]
                            )
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
    }
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


  Future<void> getData() async {
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