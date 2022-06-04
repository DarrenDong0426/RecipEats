import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/my_recipes/myRecipeCardDetails.dart';
import 'package:recipeats/utils/const/loading.dart';

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
  dynamic data2;

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
      data2 = docSnap.data();
      liked.add(data2);
      print(liked[i]['id']);
    }
    data2 = 'non-null';
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      if (data2 == null){
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
              "Liked Recipes",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),
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

  getChild(){
    if (liked.length == 0){
      return Center(child: Text("You have no liked posts"));
    }
    else{
      return ListView.builder(
        itemCount: liked.length,
        itemBuilder: (context, index){
          if (liked[index]['id'] == uid){
            return MyRecipeCardView(recipes: liked[index]);
          }
          else{
            return OtherRecipesCardView(recipes: liked[index]);
          }
        },
      );
    }
  }

}