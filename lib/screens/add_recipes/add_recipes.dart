
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipeats/screens/add_recipes/tagDialog.dart';
import 'package:recipeats/utils/const/text_constants.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/nav_bar.dart';
import '../../utils/const/reusable_textfield.dart';

class addRecipes extends StatefulWidget{
  @override
  _addRecipesState createState() => _addRecipesState();
}

class _addRecipesState extends State<addRecipes>{

  var link = Image.asset('assets/images/emptyFood.jpg');
  String url = 'assets/images/emptyFood.jpg';
  final FirebaseAuth auth = FirebaseAuth.instance;
  late String uid;
  late User _user;
  late String email;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late String username; 
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _infoTextController = TextEditingController();
  TextEditingController _prepTimeTextController = TextEditingController();
  TextEditingController _ingredientsTextController = TextEditingController();
  TextEditingController _stepsTextController = TextEditingController();
  TextEditingController _servingTextController = TextEditingController();
  late Map<String, bool> tags = new Map();
  late List items = [];
  int posts = 0;
  String error = '';

  getData() async {
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    username = data['user'];
    posts = data['posts'];
  }

  @override
  void initState() {
    _user = auth.currentUser!;
    uid = _user.uid;
    email = _user.email!;
    getData();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      reusableTextField("Name", Icons.question_mark, false,
                          _titleTextController, TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _infoTextController,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.warning,
                              color: Colors.white70,
                            ),
                            label: Text("Summary (INCLUDE ALLERGENS!)"),
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
                      reusableTextField("Prep time (in mins): ", Icons.timer, false,
                          _prepTimeTextController, TextInputType.number),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Serving Size", Icons.exposure_rounded, false,
                          _servingTextController, TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _ingredientsTextController,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.format_list_bulleted_rounded,
                              color: Colors.white70,
                            ),
                            label: Text("Ingredients and Kitchenwares"),
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
                      TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _stepsTextController,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.format_list_numbered_sharp,
                              color: Colors.white70,
                            ),
                            label: Text("Numbered Steps"),
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
                      IconButton(icon: link, iconSize: 300, onPressed: () => {AddImages()},),
                      ElevatedButton(onPressed: () => {getTag()}, child: Text("Add Tags", style: TextStyle(color: Colors.white.withOpacity(0.9)),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(hexStringToColor('454F8C').withOpacity(0.8),), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))))),
                      Tags(
                        itemCount: items.length,
                        itemBuilder: (int index){
                          String item = items[index];
                          return ItemTags(index: index, title: item, removeButton: ItemTagsRemoveButton(
                            onRemoved: (){
                              setState(() {
                                items.removeAt(index);
                              });
                              return true;
                            },
                          ));
                        },
                      ),
                      Text(error),
                      submitButton(context, "Submit", () async {
                        CheckInput();
                      }),
                      ],
                  ),
                ),
              )),
    );
  }

  void CheckInput(){
    if (_titleTextController.text == ""){
      setState(() {
        error = "Enter the name of the recipe";
      });
    }
    else if(_infoTextController.text == ""){
      setState(() {
        error = "Enter a summary of your dish or any warnings";
      });
    }
    else if(_prepTimeTextController.text == ""){
      setState(() {
        error = "Enter the time required for the recipe in minutes";
      });
    }
    else if(_servingTextController.text == ""){
      setState(() {
        error = "Enter the serving size of the dish";
      });
    }
    else if(_ingredientsTextController.text == ""){
      setState(() {
        error = "Enter ingredients or tools needed for the dish";
      });
    }
    else if(_stepsTextController.text == ""){
      setState(() {
        error = "Enter the steps to prepare the dish";
      });
    }
    else if(url == 'assets/images/emptyFood.jpg'){
      setState(() {
        error = "Add a profile picture";
      });
    }
    else{
      updateFirebase();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => navBar()));
    }
  }

  getTag() async{
    tags = await showDialog(context: context, builder: (BuildContext context){return tagDialog();});
    for (int i = 0; i < tags.length; i++){
      if (tags[tags.keys.elementAt(i)] == true && items.indexOf(tags.keys.elementAt(i)) == -1){
        items.add(tags.keys.elementAt(i));
      }
    }
    setState(() {});
  }


  Future<void> updateFirebase() async {
    final recipe = <String, dynamic>{
      "id": uid,
      "Author": username,
      "Rating": [],
      "Name": _titleTextController.text,
      "Info": _infoTextController.text,
      "prepTime": _prepTimeTextController.text,
      "serving": _servingTextController.text,
      "ingredient": _ingredientsTextController.text,
      "steps": _stepsTextController.text,
      "food_image": url,
      'comment': [],
      'likes': 0,
      'tags': items,
    };
    await db.collection("recipes").doc(_titleTextController.text + uid).set(recipe);
    await db.collection('users').doc(uid).update({"posts": posts + 1});
  }


  _openCamera(BuildContext context) async{
    var picture = await ImagePicker().pickImage(source: ImageSource.camera);
    // _listImages.add(i);
    var p = File(picture!.path);
    var snapshot = await _storage.ref().child('recipes/'+email+"/" + _titleTextController.text).putFile(p);
    var l = await (snapshot.ref.getDownloadURL());
    setState((){
      link = Image.file(File(picture.path), width: 200, height: 200);
      url = l;
    });
    Navigator.of(context).pop();
  }

  _openGallery(BuildContext context) async{
    var picture = await ImagePicker().pickImage(source: ImageSource.gallery);
    var p = File(picture!.path);
    var snapshot = await _storage.ref().child('recipes/'+email+"/" + _titleTextController.text).putFile(p);
    var l = await (snapshot.ref.getDownloadURL());
    setState((){
      link = Image.file(File(picture.path), width: 200, height: 200);
      url = l;
    });
    Navigator.of(context).pop();
  }


  AddImages(){
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

}
