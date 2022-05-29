

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
  late String name = '';
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  Map<String, dynamic> comments = {
    'users': [],
    'comment': [],
    'times': [],
  };
  final ScrollController _scrollController = ScrollController();


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
        backgroundColor: Colors.white,
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
          Padding(
            padding: EdgeInsets.all(10),
          child: TextField(
              minLines: 1,
              maxLines: 5,

              controller: _commentTextController,
              enableSuggestions: true,
              autocorrect: true,
              cursorColor: Colors.black,

              style: TextStyle(color: Colors.black, fontSize: 16),
              decoration: InputDecoration(
                fillColor: Colors.white,
                  contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                isDense: true,
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                //fillColor: hexStringToColor('454F8C').withOpacity(0.8),
                hintText: "Enter a comment",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xffd76b5b), width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color(0xffd76b5b), width: 0.5),
                ),
                border: const OutlineInputBorder(),
                suffixIcon: TextButton(
                   onPressed: () async {
                     updateFirebase(); },
                  child: Text("Post", style: TextStyle(color: Color(0xffd76b5b)),),
                )
                /*border: OutlineInputBorder(

                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(width: 2, style: BorderStyle.solid, color: Color(0xffd76b5b))
                ),*/
              ),
              keyboardType: TextInputType.multiline
          ),
          ),
          /*submitButton(context, "Post", () async {
            updateFirebase();}),*/
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
        controller: _scrollController,
        itemBuilder: (context, index){
          return getComment(comments['users'][index], comments['comment'][index], comments['times'][index]);
        },
      );
    }
  }

  getUser(String user) async{
    final docRef = db.collection('users').doc(user);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    name = data['user'];
    String url = data['pfp'];
    i = Image.network(url);
    setState(() {
    });
  }

  getComment(String user, String comment, String time){
      getUser(user);
      return Center(
        child: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
              children: <Widget> [
                CircleAvatar(
                backgroundImage: i.image,
                minRadius: 25,
                backgroundColor: Colors.white,
              ),
              Container(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(name, style: TextStyle(fontWeight: FontWeight.bold),),
                Text(time, style: TextStyle(fontSize: 11),)
            ]
              )
              ]

              ),
              Padding(
                padding: EdgeInsets.fromLTRB(60, 10, 10, 10),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Flexible(
                    child: Text(comment)
                  )
                ],
              ),
              )
            ],
          ),

        ),
      ));
        /*SizedBox(
        width: 500,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: i.image,
                    minRadius: 25,
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
      );*/
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
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut
      );
      _commentTextController.clear();
      //Navigator.pop(context);
    }
  }

  getTime() {
    DateTime datetime = DateTime.now();
    String formattedDate = DateFormat('MM/dd/yy h:mma').format(datetime);
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