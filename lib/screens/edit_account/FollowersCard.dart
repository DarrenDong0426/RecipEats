
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/loading.dart';
import '../search_recipes/OtherProfile.dart';

class FollowersCard extends StatefulWidget{
  late String id;

  FollowersCard({Key? key, required this.id}) : super(key: key);


  FollowersCardState createState() => FollowersCardState();

}

class FollowersCardState extends State<FollowersCard>{

  Image i = Image.asset('assets/images/emptyPfp.jpg');
  Image z = Image.asset('assets/images/emptyPfp.jpg');
  FirebaseFirestore db = FirebaseFirestore.instance;
  String uid = '';
  String url = '';
  String username = '';

  FollowersCard(String id){
    uid = id;
  }

  Future<void> getData() async {
    var docRef = await db.collection('users').doc(uid).get();
    var data = docRef.data();
    url = data!['pfp'];
    username = data['user'];
        i = Image.network(url);
  }

  @override
  Widget build(BuildContext context) {
    uid = widget.id;
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      if (i.toString() == z.toString()){
        return Loading();
      }
      else{
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
              Text(username, style: TextStyle(color: hexStringToColor('3c403a')),),
            ],
          ),
        );
      }
    });
  }
}