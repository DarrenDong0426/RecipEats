
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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
  TextEditingController _allergensTextController = TextEditingController();
  TextEditingController _prepTimeTextController = TextEditingController();
  TextEditingController _ingredientsTextController = TextEditingController();
  TextEditingController _kitchenwareTextController = TextEditingController();
  TextEditingController _stepsTextController = TextEditingController();
  TextEditingController _servingTextController = TextEditingController();
  TextEditingController _costTextController = TextEditingController();
  TextEditingController _calorieTextController = TextEditingController();
  late Map<String, bool> tags = new Map();
  late List items = [];
  int posts = 0;
  static List<String> stepsList = [];
  List<Widget> stepsFields = [];
  String error = '';
  int stepCount = 1;

  Map<String,TextEditingController> textEditingControllers = {};
  var textFields = <TextField>[];


  getData() async {
    final docRef = db.collection('users').doc(uid);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic data = docSnap.data();
    username = data!['user'];
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: hexStringToColor('3A3B3C'),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Upload Recipe",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3c403a')),
        ),
      ),
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
                      reusableTextField("Recipe Name", Icons.fastfood, false,
                          _titleTextController, TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Summary", Icons.description, false,
                          _infoTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Cooking time (in minutes)", Icons.timer, false,
                          _prepTimeTextController, TextInputType.number),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Serving Size", Icons.restaurant, false,
                          _servingTextController, TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Ingredients",  Icons.format_list_bulleted_rounded, false,
                          _ingredientsTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Kitchenware (separated by comma)",  Icons.kitchen, false,
                          _kitchenwareTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Estimated Calories",  Icons.health_and_safety, false,
                          _calorieTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Allergens (separated by comma)",  Icons.warning_rounded, false,
                          _allergensTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField("Estimated Cost in Dollars",  Icons.attach_money, false,
                          _costTextController, TextInputType.multiline),
                      const SizedBox(
                        height: 20,
                      ),
                      /*reusableTextField("Numbered Steps",  Icons.format_list_numbered_sharp, false,
                          _stepsTextController, TextInputType.multiline),*/
                      Container(
                          width: 350,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)
                          ),
                          child:TextField(
                              controller: _stepsTextController,
                              obscureText: false,
                              enableSuggestions: true,
                              autocorrect: true,
                              cursorColor: Colors.black,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.format_list_numbered_sharp,
                                  color: Color(0xff627f68),
                                ),
                                labelText: "Numbered Steps",
                                labelStyle: TextStyle(color: hexStringToColor('3c403a')),
                                //filled: true,

                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                //fillColor: hexStringToColor('454F8C').withOpacity(0.8),
                                /*border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xffd76b5b))),*/
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff627f68).withOpacity(0.7)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff627f68).withOpacity(0.7)),
                                ),

                              ),
                              keyboardType: TextInputType.multiline
                          )
                      ),

                      Center(
                          child: Container(
                        padding: EdgeInsets.all(60),

                          width: double.infinity,
                          margin: EdgeInsets.all(60),
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xff627f68).withOpacity(0.8)),

                            borderRadius: BorderRadius.circular(8),

                          ),
                        child:
                        Column(

                          children:
                          <Widget>[
                            IconButton(icon: Icon(Icons.cloud_upload_outlined), iconSize: 50, onPressed: () => {AddImages()},),
                            Text("Upload image")
                        ])
                      )),
                      //IconButton(icon: link, iconSize: 300, onPressed: () => {AddImages()},),
                      ElevatedButton(onPressed: () => {getTag()}, child: Text("Add Tags", style: TextStyle(color: Colors.white),), style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xff627f68),), shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
                      Tags(
                        itemCount: items.length,
                        itemBuilder: (int index){
                          String item = items[index];
                          return ItemTags(index: index, title: item, removeButton: ItemTagsRemoveButton(
                            backgroundColor: Color(0xff627f68),
                            color: Color(0xff627f68),

                            onRemoved: (){
                              setState(() {
                                items.removeAt(index);
                              });
                              return true;
                            },
                          ));
                        },
                      ),
                      //..._getSteps(),

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
  /*Widget _getSteps(){
    return new Row(children: stepsFields.map((item) => new Text());
  }*/
 /* List<Widget> _getSteps(){
    List<Widget> stepsFields = [];
    for(int i=0; i<stepsList.length; i++){
      stepsFields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: StepTextFields(i)),
                SizedBox(width: 16,),

                _addRemoveButton(i == stepsList.length-1, i),
              ],
            ),
          )
      );
    }
    return stepsFields;
  }

  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          // add new text-fields at the top of all friends textfields
          stepsList.insert(0, "");
        }
        else stepsList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon((add) ? Icons.add : Icons.remove, color: Colors.white,),
      ),
    );
  }
*/



  void CheckInput(){
    if (_titleTextController.text == ""){
      setState(() {
        error = "Enter the name of the recipe";
      });
    }
    else if(_infoTextController.text == ""){
      setState(() {
        error = "Enter a summary of your recipe";
      });
    }
    else if(_costTextController.text == ""){
      setState(() {
        error = "Enter an estimated price for the recipe";
      });
    }
    else if(_kitchenwareTextController.text == ""){
      setState(() {
        error = "List any needed kitchenware";
      });
    }
    else if(_calorieTextController.text == ""){
      setState(() {
        error = "Enter estimated calories for the dish";
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

  /*updateTextFields(){
    setState(() {
      stepCount = int.parse(_stepsTextController.text);
      createFields();
    });
  }

  createFields(){
    for (int i = 0; i < stepCount; i++){
      var textEditingController = new TextEditingController(text: (i + 1).toString());
      //textEditingControllers.putIfAbsent((i + 1).toString(), ()=>textEditingController);
      textFields.add( TextField(controller: textEditingController));
    }
    setState(() {

    });
  }*/

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
      "kitchenware": _kitchenwareTextController.text,
      "cost": _costTextController.text,
      "allergens": _allergensTextController.text,
      "calories": _calorieTextController.text,
      "food_image": url,
      'likes': 0,
      'tags': items,
      'time': DateFormat.yMMMMd().format(DateTime.now()),
      'comment': {'users': [],
        'comment': [],
        'times': [],}
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

/*class StepTextFields extends StatefulWidget {
  final int index;
  StepTextFields(this.index);
  @override
  _StepTextFieldsState createState() => _StepTextFieldsState();
}

class _StepTextFieldsState extends State<StepTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _addRecipesState.stepsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) => _addRecipesState.stepsList[widget.index] = v,
      decoration: InputDecoration(
          hintText: 'Enter your friend\'s name'
      ),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }*/

