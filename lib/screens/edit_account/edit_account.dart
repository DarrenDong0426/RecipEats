
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/loading.dart';
import '../../utils/const/nav_bar.dart';

class Edit_Account extends StatefulWidget {


  const Edit_Account({Key? key}) : super(key: key);


  @override
  _editAccountState createState() => _editAccountState();

}

class _editAccountState extends State<Edit_Account> {


  FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  late User _user;
  List data = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _EmailTextController = TextEditingController();
  TextEditingController _PasswordTextController = TextEditingController();
  TextEditingController _userTextController = TextEditingController();
  TextEditingController _birthdayTextController = TextEditingController();
  TextEditingController _biographyTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  Image i = Image.asset('assets/images/emptyPfp.jpg');
  Image z = Image.asset('assets/images/emptyPfp.jpg');
  String url = 'assets/images/emptyPfp.jpg';
  late File p;

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    i = Image.file(File(picture!.path), width: 200, height: 200);
    p = File(picture.path);
    var snapshot = await _storage.ref().child(
        'pfp/' + _EmailTextController.text).putFile(p);
    var link = (await snapshot.ref.getDownloadURL());
    setState(() {
      url = link;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    i = Image.file(File(picture!.path), width: 200, height: 200);
    p = File(picture.path);
    var snapshot = await _storage.ref().child(
        'pfp/' + _EmailTextController.text).putFile(p);
    var link = (await snapshot.ref.getDownloadURL());
    setState(() {
      url = link;
    });
    Navigator.of(context).pop();
  }


  Future<void> openChoice(BuildContext context) {
    return showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add Profile Picture"),
        content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Import from Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(6.0)),
                GestureDetector(
                  child: Text("Take a Picture"),
                  onTap: () {
                    _openCamera(context);
                  },
                )
              ],
            )
        ),
      );
    });
  }

  Future<void> getDocSnap() async {
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    _userTextController.text = data['user'];
    _birthdayTextController.text = data['birthday'];
    _phoneTextController.text = data['phone'];
    _biographyTextController.text = data['biography'];
    _PasswordTextController.text = data['password'];
    url = data['pfp'];
      i = Image.network(url);
  }

  @override
  void initState() {
    _user = auth.currentUser!;
    uid = _user.uid;
    _EmailTextController.text = _user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: getDocSnap(), builder: (context, snapshot){
      if (i.toString() == z.toString()){
        return Loading();
      }
      else{
        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: hexStringToColor('3c403a'),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                "Edit Account",
                style: TextStyle(fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: hexStringToColor('3c403a')),
              ),
            ),
            body: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                        child: Column(
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                openChoice(context);
                              },
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
                            reusableTextField2(Icons.lock, false,
                                _PasswordTextController, TextInputType.name),
                            SizedBox(
                              height: 20,
                            ),
                            reusableTextField2(Icons.person_outline, false,
                                _userTextController, TextInputType.name),
                            const SizedBox(
                              height: 20,
                            ),
                            reusableTextField2(Icons.cake, false,
                                _birthdayTextController, TextInputType.datetime),
                            const SizedBox(
                              height: 20,
                            ),
                            reusableTextField2(Icons.phone, false,
                                _phoneTextController, TextInputType.number),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                                minLines: 1,
                                maxLines: 5,
                                controller: _biographyTextController,
                                enableSuggestions: true,
                                autocorrect: true,
                                cursorColor: Colors.white,
                                style: TextStyle(
                                    color: Colors.white.withOpacity(1.0)),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.info,
                                    color: Colors.white70,
                                  ),
                                  labelStyle: TextStyle(
                                      color: Colors.white.withOpacity(1.0)),
                                  filled: true,
                                  floatingLabelBehavior: FloatingLabelBehavior
                                      .never,
                                  fillColor: hexStringToColor('627f68').withOpacity(
                                      0.8),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                      borderSide: const BorderSide(
                                          width: 0, style: BorderStyle.none)),
                                ),
                                keyboardType: TextInputType.multiline
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            submitButton(context, "Submit", () async {
                              updateFirebase();
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      builder: (context) => navBar()));
                            })
                          ],
                        )
                    )
                )
            )
        );
      }
    });
  }


  Future<void> updateFirebase() async {
    _user.updatePassword(_PasswordTextController.text);

    final user = <String, dynamic>{
      "email": _EmailTextController.text,
      "password": _PasswordTextController.text,
      "user": _userTextController.text,
      "birthday": _birthdayTextController.text,
      "biography": _biographyTextController.text,
      "phone": _phoneTextController.text,
      "pfp": url,
    };
    await db.collection("users").doc(uid).update(user);
  }

}