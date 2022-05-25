

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/reusable_textfield.dart';
import 'commentCard.dart';

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
  late String uid;
  late String recipeId = '';
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
          submitButton(context, "Post", updateFirebase()),
          ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index){
              return getComment(comments['users'][index], comments['comment'][index], comments['times'][index]);
            },
          ),
          ],
        ),
      ),
    );
  }

  getComment(String user, String comment, String time) {
    if (user == uid){
      return commentCard(isCurrentUser: true);
    }
    else {
      return commentCard(isCurrentUser: false);
    }
  }

  updateFirebase() async {
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    print(comments['users']);
    List users = comments['users'].add(uid);
    List times = comments['times'].add(getTime());
    List comment = comments['comment'].add(_commentTextController.text);
    comments = {
      'users': users,
      'comment': times,
      'times': comment,
    };
    db.collection('recipes').doc(recipeId).update({'comment': comments});
    Navigator.pop(context);
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