

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/reusable_textfield.dart';

class myComments extends StatefulWidget{

  String id;
  myComments({Key? key, required this.id}) : super(key: key);

  @override
  _myCommentsState createState() => _myCommentsState();

}

class _myCommentsState extends State<myComments>{


  TextEditingController _commentTextController = TextEditingController(text: "");
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late User _user;
  late String uid = '';
  late String recipeId = '';
  late String name;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  Map<String, dynamic> comments = {
    'users': [],
    'comment': [],
    'times': [],
  };

  @override
  void initState() {
    super.initState();
    recipeId = widget.id;
    print(recipeId);
    _user = auth.currentUser!;
    uid = _user.uid;
    getData();
    setState(() {
    });
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
          "Comments",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: <Widget>[
          Expanded(child:
              getChild()
            ),
          TextField(
              minLines: 1,
              maxLines: 5,
              controller: _commentTextController,
              enableSuggestions: true,
              autocorrect: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.info,
                  color: Colors.white70,
                ),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                fillColor: hexStringToColor('454F8C').withOpacity(0.8),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
              ),
              keyboardType: TextInputType.multiline
          ),
          submitButton(context, "Post", () async {
            updateFirebase();}),
         ],
        ),
      ),
    );
  }

  getChild() {
    if (comments['users'].length == 0) {
      return Padding(
          padding: EdgeInsets.all(35),
          child: Center(child: Text(
            "There are no comments on this posts.",))
      );
    }
    else{
      return ListView.builder(
        shrinkWrap: true,
        itemCount: comments['users'].length,
        itemBuilder: (context, index){
          return getComment(comments['users'][index], comments['comment'][index], comments['times'][index]);
        },
      );
    }
  }

  getUser() async{
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    name = data['user'];
    String url = data['pfp'];
    i = Image.network(url);
  }

  getComment(String user, String comment, String time){
      getUser();
      return Container(
        child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: i.image,
                    minRadius: 50,
                    backgroundColor: Colors.white,
                  ),
                  Text(name + ' ' + time),
                ],
              ),
              Text(comment),
              SizedBox(
                height: 20,
              )
          ]
        ),
      );
  }

  updateFirebase() async {
    if (_commentTextController.text != '') {
      final docRef = db.collection('users').doc(uid);
      DocumentSnapshot docSnap = await docRef.get();
      dynamic data = docSnap.data();
      print(comments);
      print(comments['users']);
      List users = comments['users'];
      users.add(uid);
      List times = comments['times'];
      times.add(getTime());
      List comment = comments['comment'];
      comment.add(_commentTextController.text);
      comments = {
        'users': users,
        'comment': comment,
        'times': times,
      };
      db.collection('recipes').doc(recipeId).update({'comment': comments});
      Navigator.pop(context);
    }
  }

  getTime() {
    DateTime datetime = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yy kk:mm').format(datetime);
    return formattedDate;
  }

  Future<void> getData() async {
    final docRef2 = db.collection('recipes').doc(recipeId);
    DocumentSnapshot docSnap2 = await docRef2.get();
    dynamic recipeData = docSnap2.data();
    comments = recipeData!['comment'];
    if (mounted) {
      setState(() {});
    }
  }
}
