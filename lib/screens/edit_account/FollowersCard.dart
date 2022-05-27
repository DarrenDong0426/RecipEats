
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../search_recipes/OtherProfile.dart';

class FollowersCard extends StatefulWidget{
  late String id;

  FollowersCard({Key? key, required this.id}) : super(key: key);


  FollowersCardState createState() => FollowersCardState();

}

class FollowersCardState extends State<FollowersCard>{

  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = '';
  String url = '';
  String username = '';

  FollowersCard(String id){
    uid = id;
  }

  getData() async {
    var docRef = await db.collection('users').doc(uid).get();
    var data = docRef.data();
    url = data!['pfp'];
    username = data['user'];
    if (mounted){
      setState(() {
        i = Image.network(url);
      });
  }
  }

  @override
  Widget build(BuildContext context) {
    uid = widget.id;
    getData();
    return Container(
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: uid)));
            },
            child: CircleAvatar(
              backgroundImage: i.image,
              minRadius: 50,
              backgroundColor: Colors.white,
            ),
          ),
          Text(username, style: TextStyle(color: Colors.black),),
        ],
      ),
    );
  }
}