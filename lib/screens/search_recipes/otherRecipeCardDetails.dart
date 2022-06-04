import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:recipeats/utils/const/loading.dart';

import '../../utils/const/color_gradient.dart';
import '../edit_account/Profile.dart';

class OtherRecipeCardDetails extends StatefulWidget{

  Map<String, dynamic> data;

  OtherRecipeCardDetails({Key? key, required this.data}) : super(key: key);



  _OtherRecipeCardDetailsState createState() => _OtherRecipeCardDetailsState();


}

class _OtherRecipeCardDetailsState extends State<OtherRecipeCardDetails>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  String url = 'https://firebasestorage.googleapis.com/v0/b/recipeats-24cdd.appspot.com/o/pfp%2Fdongd%40bxscience.edu?alt=media&token=f04b6753-9a41-43e9-94d5-dcd3b4f9cae3';
  late List items = [];
  List ratings = [];
  Map<String, dynamic> rateList = new Map();
  String currId = '';
  bool rated = false;
  double? score = 0;

  Future<void> getData() async {
    final docRef = db.collection('users').doc(widget.data['id']);
    var auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    currId = user!.uid;
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    var docRef2 = await db.collection('users').doc(widget.data['id']).get();
    var data2 = docRef2.data();
    url = data2!['pfp'];
    items = widget.data['tags'];
    ratings = widget.data['Rating'];
    var docRef3 = await db.collection('users').doc(currId).get();
    var data3 = docRef3.data();
    rateList = Map<String, dynamic>.from(data3!['rated']);
    if (rateList.containsKey(widget.data['Name'] + widget.data['id'])){
      rated = true;
      score = rateList[widget.data['Name'] + widget.data['id']];
    }
    if (mounted) {
      setState(() {
        i = Image.network(userData['pfp']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.data;
    return FutureBuilder(future: getData(),
        builder: (context, snapshot){
      if (url == 'https://firebasestorage.googleapis.com/v0/b/recipeats-24cdd.appspot.com/o/pfp%2Fdongd%40bxscience.edu?alt=media&token=f04b6753-9a41-43e9-94d5-dcd3b4f9cae3'){
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
              data['Name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),
            ),
          ),
          body: SingleChildScrollView(child: Column(
            children: <Widget>[
              Image(image: i.image),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: CircleAvatar(
                      backgroundImage: Image.network(url).image,
                      minRadius: 50,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Text(data['Name'] + " by " + data["Author"]),
                ],
              ),
              RatingBar(
                ignoreGestures: rated,
                initialRating: score!,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Image.asset('assets/images/1.png'),
                  half: Image.asset('assets/images/2.png'),
                  empty: Image.asset('assets/images/3.png'),
                ),
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  ratings.add(rating);
                  updateFirebase(rating);
                },
              ),
              Tags(
                itemCount: items.length,
                itemBuilder: (int index){
                  String item = items[index];
                  return ItemTags(index: index, title: item);
                },
              ),
              Text("Prep Time: " + data['prepTime'] + ' minutes'),
              Text("Servings: " + data['serving']),
              Text("Ingredients and Utensils: " + data['ingredient']),
              Text("Steps: " + data['steps']),
            ],
          ),),
        );
      }
    });

  }

  void updateFirebase(double rating) {
    rateList[widget.data['Name'] + widget.data['id']] = rating;
    db.collection('recipes').doc(widget.data['Name'] + widget.data['id']).update({'Rating': ratings});
    db.collection('users').doc(currId).update({'rated': rateList});
    rated = true;
    setState(() {
    });
  }
}
