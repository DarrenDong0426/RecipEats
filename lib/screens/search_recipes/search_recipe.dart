
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
      appBar: AppBar(
        title: const Text('Search'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {showSearch(context: context, delegate: MySearchDelegate(myRecipe));}, icon: const Icon(Icons.search), color: hexStringToColor('3c403a'),),
        ],
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


class MySearchDelegate extends SearchDelegate{


  FirebaseFirestore db = FirebaseFirestore.instance;
  late List<dynamic> recipes;
  Map <String, dynamic> name = {};
  List<dynamic> suggestions = [];
  List<dynamic> results = [];

  MySearchDelegate(List recipes){
    this.recipes = recipes;
    for (int i = 0; i < recipes.length; i++){
      name[recipes[i]['Name'] + recipes[i]['id']] = recipes[i]['Name'];
    }
    print(name);
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(onPressed: () {if (query.isEmpty){
      close(context, null);
    }else{
      query = '';
    }
    }, icon: const Icon(Icons.clear),),
  ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back),);


  @override
  Widget buildResults(BuildContext context) => Center(
    child: ListView.builder(
    itemCount: suggestions.length,
    itemBuilder: (context, index) {
      return OtherRecipesCardView(recipes: suggestions[index]);
    }
    )
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    suggestions = recipes.where((element) {
      final result = element['Name'].toString().toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    print(suggestions);


      return ListView.builder(itemCount: suggestions.length, itemBuilder: (context, index){
        final suggestion = suggestions[index]['Name'];
        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;

            showResults(context);
          },
        );
      },);
    }
}