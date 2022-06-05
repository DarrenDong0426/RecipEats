import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../utils/const/color_gradient.dart';
import '../../utils/const/loading.dart';
import '../edit_account/Profile.dart';
import '../search_recipes/OtherProfile.dart';
import 'my_recipes.dart';

class myRecipeCardDetails extends StatefulWidget{

  Map<String, dynamic> data;

  myRecipeCardDetails({Key? key, required this.data}) : super(key: key);



  _myRecipeCardDetailsState createState() => _myRecipeCardDetailsState();


}

class _myRecipeCardDetailsState extends State<myRecipeCardDetails>{

  FirebaseFirestore db = FirebaseFirestore.instance;
  late Image i = Image.asset('assets/images/emptyPfp.jpg');
  String url = 'https://firebasestorage.googleapis.com/v0/b/recipeats-24cdd.appspot.com/o/pfp%2Fdongd%40bxscience.edu?alt=media&token=f04b6753-9a41-43e9-94d5-dcd3b4f9cae3';
  late List items = [];
  int post = 0;

  Future<void> getData() async {
    final docRef = db.collection('users').doc(widget.data['id']);
    DocumentSnapshot docSnap = await docRef.get();
    dynamic userData = docSnap.data();
    items = widget.data['tags'];
    if (mounted) {
      setState(() {
        i = Image.network(userData['pfp']);
        url = widget.data['food_image'];
        post = userData['posts'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.data;
    return FutureBuilder(future: getData(), builder: (context, snapshot){
      if (url == 'https://firebasestorage.googleapis.com/v0/b/recipeats-24cdd.appspot.com/o/pfp%2Fdongd%40bxscience.edu?alt=media&token=f04b6753-9a41-43e9-94d5-dcd3b4f9cae3'){
        return Loading();
      }
      else{
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              data['Name'],
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
          body:
          Container(
            width: MediaQuery.of(context).size.width,

            child: SingleChildScrollView(

              child:

              Column(
                //crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  Image(image: i.image, height: 300,  width: double.infinity,
                    fit: BoxFit.fitWidth,),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Column(

                        children: <Widget>[
                          SizedBox(height: 10),
                      Container(
                        width: 340,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                        child: ElevatedButton(
                          onPressed: () => delete(),
                          child: Text(
                            "Delete",
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Color(0xff627f68);
                                }
                                return Color(0xff627f68);
                              }),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                        ),
                      ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                            child:
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(data["Name"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                            child:
                            Row(
                                children:
                                <Widget>[

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(data["prepTime"] + " minutes" + " | " + data["tags"].toString().substring(1, (data["tags"].toString().length - 1)), style: TextStyle(fontSize: 17))

                                  ),
                                  SizedBox(width: 70),
                                  Text("Cost: \$" + data["cost"], style: TextStyle(fontSize: 17),),
                                  //Text("Serving Size: " + data['serving'], style: TextStyle(fontSize: 17),),

                                ]
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 5, 25, 0),
                            child:
                            Row(
                                children:
                                <Widget>[

                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(data["calories"] + " calories", style: TextStyle(fontSize: 17))

                                  ),
                                  SizedBox(width: 100),
                                  //Text("Cost: \$" + data["cost"], style: TextStyle(fontSize: 17),),
                                  Text("Serving Size: " + data['serving'], style: TextStyle(fontSize: 17),),
                                ]
                            ),
                          ),
                         /* Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child:
                                Container(
                                  width: 250,
                                  child:RatingBar(
                                    ignoreGestures: rated,
                                    initialRating: score!,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    ratingWidget: RatingWidget(
                                      full: Image.asset('assets/images/1.png'),
                                      half: Image.asset('assets/images/2.png'),
                                      empty: Image.asset('assets/images/3.png'),
                                    ),
                                    //itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                    onRatingUpdate: (rating) {
                                      ratings.add(rating);
                                      updateFirebase(rating);
                                    },
                                  ),
                                )
                            ),
                          ),*/
                          Padding(
                            padding: EdgeInsets.fromLTRB(25, 15, 25, 10),
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data["id"])));

                                  },
                                  child: CircleAvatar(
                                    backgroundImage: Image.network(url).image,
                                    maxRadius: 20,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text("by " + data["Author"]),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                            child: Align(
                                alignment: Alignment.center,
                                child:
                                Text(data["Info"])
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(25, 0, 25, 10),
                            child: Divider(color: Color(0xffd76b5b)),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffd76b5b),

                                  ),
                                  child:
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white, // here for close state
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.white,
                                      ), // here for open state in replacement of deprecated accentColor
                                      dividerColor: Colors.transparent, // if you want to remove the border
                                    ),
                                    child: ExpansionTile(
                                      expandedAlignment: Alignment.center,
                                      expandedCrossAxisAlignment: CrossAxisAlignment.center,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      collapsedTextColor: Colors.white,
                                      leading: Icon(Icons.warning),
                                      title: Text('Allergens', style: TextStyle(color: Colors.white),),
                                      // subtitle: Text('Leading expansion arrow icon'),
                                      controlAffinity: ListTileControlAffinity.trailing,

                                      children: <Widget>[
                                        ListTile(title: Text(data["allergens"], style: TextStyle(color: Colors.white)),),
                                      ],
                                    ),
                                  )
                              )
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffd76b5b),

                                  ),
                                  child:
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white, // here for close state
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.white,
                                      ), // here for open state in replacement of deprecated accentColor
                                      dividerColor: Colors.transparent, // if you want to remove the border
                                    ),
                                    child: ExpansionTile(
                                      expandedAlignment: Alignment.center,
                                      expandedCrossAxisAlignment: CrossAxisAlignment.center,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      collapsedTextColor: Colors.white,
                                      leading: Icon(Icons.format_list_bulleted_rounded),
                                      title: Text('Ingredients', style: TextStyle(color: Colors.white),),
                                      // subtitle: Text('Leading expansion arrow icon'),
                                      controlAffinity: ListTileControlAffinity.trailing,

                                      children: <Widget>[
                                        ListTile(title: Text(data["ingredient"], style: TextStyle(color: Colors.white)),),
                                      ],
                                    ),
                                  )
                              )
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffd76b5b),

                                  ),
                                  child:
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white, // here for close state
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.white,
                                      ), // here for open state in replacement of deprecated accentColor
                                      dividerColor: Colors.transparent, // if you want to remove the border
                                    ),
                                    child: ExpansionTile(
                                      expandedAlignment: Alignment.center,
                                      expandedCrossAxisAlignment: CrossAxisAlignment.center,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                      collapsedTextColor: Colors.white,
                                      leading: Icon(Icons.kitchen),
                                      title: Text('Kitchenware', style: TextStyle(color: Colors.white),),
                                      // subtitle: Text('Leading expansion arrow icon'),
                                      controlAffinity: ListTileControlAffinity.trailing,
                                      /*  key: expansionTileKey,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    _scrollToSelectedContent(expansionTileKey: expansionTileKey);
                                  }
                                },*/
                                      children: <Widget>[
                                        ListTile(title: Text(data["kitchenware"], style: TextStyle(color: Colors.white)),),
                                      ],
                                    ),
                                  )
                              )
                          ),
                          SizedBox(height: 10),
                          Align(
                              alignment: Alignment.center,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xffd76b5b),

                                  ),
                                  child:
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white, // here for close state
                                      colorScheme: ColorScheme.light(
                                        primary: Colors.white,
                                      ), // here for open state in replacement of deprecated accentColor
                                      dividerColor: Colors.transparent, // if you want to remove the border
                                    ),
                                    child: ExpansionTile(
                                        expandedAlignment: Alignment.center,
                                        expandedCrossAxisAlignment: CrossAxisAlignment.center,
                                        iconColor: Colors.white,
                                        collapsedIconColor: Colors.white,
                                        collapsedTextColor: Colors.white,
                                        leading: Icon(Icons.format_list_numbered_sharp),
                                        title: Text('Instructions', style: TextStyle(color: Colors.white),),
                                        // subtitle: Text('Leading expansion arrow icon'),
                                        controlAffinity: ListTileControlAffinity.trailing,
                                        /*  key: expansionTileKey,
                                onExpansionChanged: (value) {
                                  if (value) {
                                    _scrollToSelectedContent(expansionTileKey: expansionTileKey);
                                  }
                                },*/
                                        children:  getSteps()
                                      /*<Widget>[

                          ListTile(title: Text(data["steps"], style: TextStyle(color: Colors.white)),),
                        ],*/
                                    ),
                                  )
                              )
                          ),

                          /*Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => OtherProfile(id: data["id"])));

                          },
                          child: CircleAvatar(
                            backgroundImage: Image.network(url).image,
                            minRadius: 50,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Text(data['Name'] + " by " + data["Author"]),
                      ],
                    ),*/

                          /*Tags(
                      itemCount: items.length,
                      itemBuilder: (int index){
                        String item = items[index];
                        return ItemTags(index: index, title: item);
                      },
                    ),*/
                          //Text("Prep Time: " + data['prepTime'] + ' minutes'),

                          /*Text("Ingredients and Utensils: " + data['ingredient']),
                    Text("Steps: " + data['steps']),*/
                        ],
                      )


                  )
                ],
              ),
            ),


          ),


        );
        /*return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: hexStringToColor('3A3B3C'),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              data['Name'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: hexStringToColor('3A3B3C')),
            ),
          ),
          body: SingleChildScrollView(child: Column(
            children: <Widget>[
              Image.network(url),
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
                    },
                    child: CircleAvatar(
                      backgroundImage: i.image,
                      minRadius: 50,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Text(data['Name'] + " by " + data["Author"]),
                ],
              ),
              Tags(
                itemCount: items.length,
                itemBuilder: (int index){
                  String item = items[index];
                  return ItemTags(index: index, title: item);
                },
              ),
              Text("Prep Time: " + data['prepTime'] + ' minutes'),
              Text("Servings: " + data['serving']),
              Text("Ingredients and Utensils: " + data['ingredient']),
              Text("Steps: " + data['steps']),
              // ElevatedButton(onPressed: ()=> edit_recipe(data: data), child: Text('Edit')),
              ElevatedButton(onPressed: ()=> delete(), child: Text('Delete'))
            ],
          ),),
        );*/
      }
    });
  }

  List<Widget> getSteps(){
    var splitArray = widget.data["steps"].split(',');
    List<Widget> widgets = <Widget>[];
    for (var i = 0; i < splitArray.length; i++){
      var stepNum = i + 1;
      var step = stepNum.toString() + ". " + splitArray[i].trim();
      widgets.add(ListTile(title: Text(step, style: TextStyle(color: Colors.white),)));
    }
    return widgets;

  }



  delete() {
    db.collection('recipes').doc(widget.data['Name'] + widget.data['id']).delete();
    db.collection('users').doc(widget.data['id']).update({'posts': post - 1});
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
  }
}
