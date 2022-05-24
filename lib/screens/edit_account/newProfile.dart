import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeats/screens/home_screen/home_screen.dart';
import 'package:recipeats/screens/search_recipes/search_recipe.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/nav_bar.dart';

class newProfile extends StatefulWidget {

  final TextEditingController email;
  final TextEditingController password;
  final String id;

  const newProfile({Key? key, required this.email, required this.password, required this.id}) : super(key: key);


  @override
  _newProfileState createState() => _newProfileState();

}

class _newProfileState extends State<newProfile>{

  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  late User _user;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late String id;
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _birthdayTextController = TextEditingController();
  TextEditingController _biographyTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  String error = '';
  String ImageUrl = 'assets/images/emptyPfp.jpg';
  Image i = Image.asset('assets/images/emptyPfp.jpg');
  late File p;


  _openGallery(BuildContext context) async{
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    i = Image.file(File(picture!.path), width: 200, height: 200);
    p = File(picture.path);
    var snapshot = await _storage.ref().child('pfp/'+_emailTextController.text).putFile(p);
    var link = await (snapshot.ref.getDownloadURL());
    setState((){
    i = Image.file(File(picture.path), width: 200, height: 200);
    p = File(picture.path);
    ImageUrl = link;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async{
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    i = Image.file(File(picture!.path), width: 200, height: 200);
    p = File(picture.path);
    var snapshot = await _storage.ref().child('pfp/'+_emailTextController.text).putFile(p);
    var link = await (snapshot.ref.getDownloadURL());
    setState((){
      i = Image.file(File(picture.path), width: 200, height: 200);
      p = File(picture.path);
      ImageUrl = link;
    });
    Navigator.of(context).pop();
  }

  Future<void> openChoice(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text("Add Profile Picture"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Import from Gallery"),
                onTap: (){
                  _openGallery(context);
                },
              ),
              Padding(padding: EdgeInsets.all(6.0)),
              GestureDetector(
                child: Text("Take a Picture"),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],
          )
        ),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    _emailTextController = widget.email;
    _passwordTextController = widget.password;
    id = widget.id;
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
          child: Padding(
          padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {openChoice(context);},
                    child: CircleAvatar(
                      backgroundImage: i.image,
                      minRadius: 100,
                      backgroundColor: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: Colors.white, // <-- Button color
                      onPrimary: Colors.white, // <-- Splash color
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Enter Username", Icons.person_outline, false,
                        _userTextController, TextInputType.name),
                  const SizedBox(
                    height: 20,
                  ),
                    reusableTextField("MM/DD/YY", Icons.cake, false,
                        _birthdayTextController, TextInputType.datetime),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("(_ _ _) _ _ _ - _ _ _ _", Icons.phone, false,
                        _phoneTextController, TextInputType.number),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      minLines: 1,
                      maxLines: 5,
                      controller: _biographyTextController,
                      enableSuggestions: true,
                      autocorrect: true,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.info,
                          color: Colors.white70,
                        ),
                        labelText: "Enter Biography",
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text(error),
                    submitButton(context, "Submit", () async {
                      CheckInput();
                    })
                ],
            )
          )
        )
      )
    );
  }


  void updateFirebase() async{
    final user = <String, dynamic>{
      "email": _emailTextController.text,
      "password": _passwordTextController.text,
      "user": _userTextController.text,
      "birthday": _birthdayTextController.text,
      "biography": _biographyTextController.text,
      "phone": _phoneTextController.text,
      "posts": 0,
      "rated": [],
      "following": [],
      "followers": [],
      "favorite_post": [],
      "pfp": ImageUrl,
    };
    await db.collection("users").doc(id).set(user);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => navBar()));
  }

  void CheckInput(){
    if (_userTextController.text == ""){
      setState(() {
        error = "Enter your username";
      });
    }
    else if(_birthdayTextController.text.length != 8){
      setState(() {
        error = "Enter your birthday in the proper format";
      });
    }
    else if (_birthdayTextController.text.substring(2, 3) != '/' || _birthdayTextController.text.substring(5, 6) != '/') {
      setState(() {
        error = "Enter your valid birthday in the proper format";
      });
    }
    else if(_phoneTextController.text.length != 13){
      setState(() {
        error = "Enter your phone number in the proper format";
      });
    }
    else if((_phoneTextController.text.substring(0, 1) != '(' || _phoneTextController.text.substring(4, 5) != ')' || _phoneTextController.text.substring(8, 9) != '-')){
      setState(() {
        error = "Enter your phone number in the proper format";
      });
    }
    else if(_biographyTextController.text == ''){
      setState(() {
        error = "Enter a short biography";
      });
    }
    else if(ImageUrl == 'assets/emptyPfp.jpg'){
      setState(() {
        error = "Add a profile picture";
      });
    }
    else{
      updateFirebase();
    }
  }

}

