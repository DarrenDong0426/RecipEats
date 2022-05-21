
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import 'OtherRecipesCardview.dart';

class Search_Recipes extends StatefulWidget{

  _Search_RecipesState createState() => _Search_RecipesState();

}

class _Search_RecipesState extends State<Search_Recipes> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List myRecipe = [];

  Future<void> getData() async {
    _user = auth.currentUser!;
    uid = _user.uid;
    await db.collection('recipes').get().then((value) =>
        value.docs.forEach((result) {
          dynamic data = result.data();
          if (data['id'] != uid) {
            myRecipe.add(data);
          }
          setState(() {});
        }));
    print(myRecipe);
    // print(myRecipe[0]);
    // print(myRecipe[0]['Name']);
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
          "Add Recipe",
          style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold,
              color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: ListView.builder(
          itemCount: myRecipe.length,
          itemBuilder: (context, index) {
            return OtherRecipesCardView(recipes: myRecipe[index]);
          },
        ),
      ),
    );
  }
}