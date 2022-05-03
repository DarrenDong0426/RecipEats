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



}