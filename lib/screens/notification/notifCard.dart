import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/screens/my_recipes/myRecipeCardDetails.dart';
import 'package:recipeats/screens/search_recipes/OtherProfile.dart';
import 'package:recipeats/screens/search_recipes/otherRecipeCardDetails.dart';

import '../../utils/const/loading.dart';

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
  Image userPfp = Image.asset('assets/images/emptyPfp.jpg');
  Image dummy1 = Image.asset('assets/images/emptyPfp.jpg');
  Image recipeImage = Image.asset('assets/images/emptyFood.jpg');
  Image dummy2 = Image.asset('assets/images/emptyFood.jpg');
  late String recipeUserId;
  late dynamic data2;


  @override
  void initState() {
    super.initState();
    userId = widget.uid;
    notif = widget.message;
    recipe = widget.recipeId;
  }

  Future<void> getData() async {
    dynamic docRef = await db.collection('users').doc(userId).get();
    dynamic data = docRef.data();
    userPfp = Image.network(data['pfp']);
    dynamic docRef2 = await db.collection('recipes').doc(recipe).get();
    data2 = docRef2.data();
    recipeImage = Image.network(data2['food_image']);
    recipeUserId = data2['id'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      print(recipeImage);
      print(userPfp);
      if (userPfp.toString() == dummy1.toString()){
        return Loading();
      }
      else{
        return getWidget();
      }
    });

  }

  Widget getWidget() {
    if (recipe == ""){
      return GestureDetector(
        onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: userId)));},
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(5),
          //color: Colors.red,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xffd76b5b),
              style: BorderStyle.solid,
              width: 1.0,
            ),
            color: Color(0xffd76b5b),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: userPfp.image,
                maxRadius: 35,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 10),
              Text(notif, style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      );
    }
    else{
      return Container(
        //alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(5),
        //color: Colors.red,
        decoration: BoxDecoration(
          border: Border.all(
            color: Color(0xffd76b5b),
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Color(0xffd76b5b),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: GestureDetector(
          onTap: (){recipeNav();},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: userId)));},
                child: CircleAvatar(
                  backgroundImage: userPfp.image,
                  maxRadius: 35,
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(width: 10),
              Text(notif, style: TextStyle(color: Colors.white),),
              Image(image: recipeImage.image, width: 100, height: 70,),
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