import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import '../my_recipes/MyRecipesCardview.dart';
import 'OtherRecipesCardview.dart';

class OtherRecipeList extends StatefulWidget{

  late String id;

  OtherRecipeList({Key? key, required this.id}) : super(key: key);


  _OtherRecipeListState createState() => _OtherRecipeListState();

}

class _OtherRecipeListState extends State<OtherRecipeList>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid;
  late List myRecipe = [];

  Future<void> getData() async {
    uid = widget.id;
    await db.collection('recipes').get().then((value) => value.docs.forEach((result) {
      dynamic data = result.data();
      if (data['id'] == uid){
        myRecipe.add(data);
      }
      setState(() {
      });
    }));
    print(myRecipe);
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
          "My Recipes",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),
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
}