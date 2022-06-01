import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/my_recipes/myRecipeCardDetails.dart';
import 'package:recipeats/screens/search_recipes/OtherProfile.dart';
import 'package:recipeats/screens/search_recipes/otherRecipeCardDetails.dart';

class notificationCard extends StatefulWidget{

  String uid;
  String message;
  String recipeId;

  notificationCard({Key? key, required this.uid, required this.message, required this.recipeId}) : super(key: key);

  _notifCardState createState() => _notifCardState();

}

class _notifCardState extends State<notificationCard>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late String userId;
  late String notif;
  late String recipe;
  late Image userPfp = Image.asset('assets/images/emptyPfp.jpg');
  late Image recipeImage = Image.asset('assets/images/emptyFood.jpg');
  late String recipeUserId;
  late dynamic data2;


  @override
  void initState() {
    super.initState();
    userId = widget.uid;
    notif = widget.message;
    recipe = widget.recipeId;
    getData();
  }

  Future<void> getData() async {
    dynamic docRef = await db.collection('users').doc(userId).get();
    dynamic data = docRef.data();
    print(data);
    userPfp = Image.network(data['pfp']);
    dynamic docRef2 = await db.collection('recipes').doc(recipe).get();
    data2 = docRef2.data();
    recipeImage = Image.network(data2['food_image']);
    recipeUserId = data2['id'];
    if (mounted){
    setState(() {
    });}
  }

  @override
  Widget build(BuildContext context) {
    return getWidget();
  }

  Widget getWidget() {
    if (recipe == ""){
      return GestureDetector(
        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: userId)));},
        child: Container(
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: userPfp.image,
                minRadius: 50,
                backgroundColor: Colors.white,
              ),
              Text(notif),
            ],
          ),
        ),
      );
    }
    else{
      return Container(
        child: GestureDetector(
          onTap: (){recipeNav();},
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: userId)));},
                child: CircleAvatar(
                  backgroundImage: userPfp.image,
                  minRadius: 50,
                  backgroundColor: Colors.white,
                ),
              ),
              Text(notif),
              Image(image: recipeImage.image, width: 100, height: 100,),
            ],
          ),
        ),
      );
    }
  }

  recipeNav() {
    if (recipeUserId == userId){
      Navigator.push(context, MaterialPageRoute(builder: (context) => myRecipeCardDetails(data: data2)));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRecipeCardDetails(data: data2)));
    }
  }
}