import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../utils/const/color_gradient.dart';
import '../edit_account/Profile.dart';
import '../search_recipes/OtherProfile.dart';

class OtherRecipeCardDetails extends StatefulWidget{

  Map<String, dynamic> data;

  OtherRecipeCardDetails({Key? key, required this.data}) : super(key: key);



  _OtherRecipeCardDetailsState createState() => _OtherRecipeCardDetailsState();


}

class _OtherRecipeCardDetailsState extends State<OtherRecipeCardDetails>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  String url = '';
  late List items = [];

  void getData() async {
    final docRef = db.collection('users').doc(widget.data['id']);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    var docRef2 = await db.collection('users').doc(widget.data['id']).get();
    var data2 = docRef2.data();
    url = data2!['pfp'];
    items = widget.data['tags'];
    setState(() {
      i  = Image.network(userData['pfp']);
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
}