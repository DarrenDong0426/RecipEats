import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../utils/const/color_gradient.dart';
import '../edit_account/Profile.dart';
import '../search_recipes/OtherProfile.dart';
import 'my_recipes.dart';

class myRecipeCardDetails extends StatefulWidget{

  Map<String, dynamic> data;

  myRecipeCardDetails({Key? key, required this.data}) : super(key: key);



  _myRecipeCardDetailsState createState() => _myRecipeCardDetailsState();


}

class _myRecipeCardDetailsState extends State<myRecipeCardDetails>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  String url = '';
  late List items = [];
  int post = 0;

  void getData() async {
    final docRef = db.collection('users').doc(widget.data['id']);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    items = widget.data['tags'];
    print(widget.data['food_image']);
    setState(() {
      i  = Image.network(userData['pfp']);
      url = widget.data['food_image'];
      post = userData['posts'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.data;
    getData();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          data['Name'],
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Image.network(url),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                },
                child: CircleAvatar(
                  backgroundImage: i.image,
                  minRadius: 50,
                  backgroundColor: Colors.white,
                ),
              ),
              Text(data['Name'] + " by " + data["Author"]),
            ],
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
          ElevatedButton(onPressed: ()=> delete(), child: Text('Delete'))
        ],
      ),),
    );
  }

  delete() {
    db.collection('recipes').doc(widget.data['Name'] + widget.data['id']).delete();
    db.collection('users').doc(widget.data['id']).update({'posts': post - 1});
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  }
}