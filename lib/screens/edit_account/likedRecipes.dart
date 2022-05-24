import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/my_recipes/myRecipeCardDetails.dart';

import '../../utils/const/color_gradient.dart';
import '../my_recipes/MyRecipesCardview.dart';
import '../search_recipes/OtherRecipesCardview.dart';

class likedRecipes extends StatefulWidget{

  likedRecipes({Key? key}) : super(key: key);


  _likedRecipesState createState() => _likedRecipesState();

}

class _likedRecipesState extends State<likedRecipes>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List liked = [];

  Future<void> getData() async {
    _user = auth.currentUser!;
    uid = _user.uid;
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    List list = data['favorite_post'];
    for (int i = 0; i < list.length; i++){
      final docRef = db.collection('recipes').doc(list[i]);
      DocumentSnapshot docSnap = await docRef.get();
      dynamic data = docSnap.data();
      liked.add(data);
    }
    print(liked);
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Liked Recipes",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: liked.length,
          itemBuilder: (context, index){
            print(liked[index]['id']);
            print(uid);
            if (liked[index]['id'] == uid){
              return MyRecipeCardView(recipes: liked[index]);
            }
            else{
              return OtherRecipesCardView(recipes: liked[index]);
            }
          },
        ),
      ),
    );
  }

}