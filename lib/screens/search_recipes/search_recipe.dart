<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import 'OtherRecipesCardview.dart';

class Search_Recipes extends StatefulWidget{

  _Search_RecipesState createState() => _Search_RecipesState();

}

class _Search_RecipesState extends State<Search_Recipes>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List myRecipe = [];

  Future<void> getData() async {
    _user = auth.currentUser!;
    uid = _user.uid;
    await db.collection('recipes').get().then((value) => value.docs.forEach((result) {
      dynamic data = result.data();
      if (data['id'] != uid){
        myRecipe.add(data);
      }
      setState(() {
      });
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
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: myRecipe.length,
          itemBuilder: (context, index){
            return OtherRecipesCardView(recipes: myRecipe[index]);
          },
        ),
      ),
    );
  }
=======
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipeats/data/recipes.dart';
import 'package:recipeats/screens/home_screen/home_screen.dart';

class Search_Recipes extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      //appBar: AppBar(title: Text("Recordings"),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: recipes.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 100,
                    child: Row(
                      children: <Widget>[
                        Text("data"),
                      ],
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }



>>>>>>> ebf71b7680f664e1729e0617f4e33201037bdbca
}