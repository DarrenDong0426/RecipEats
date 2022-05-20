import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/utils/const/reusable_textfield.dart';

import '../../utils/const/text_constants.dart';

class tagDialog extends StatefulWidget{

  @override
  _tagDialogState createState() => _tagDialogState();

}

class _tagDialogState extends State<tagDialog>{
  Map<String, bool> tags = getTags();

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: Text("Add Tags"),
        content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[CheckboxTag(), ElevatedButton(onPressed: () => {Navigator.pop(context, tags)}, child: Text("Done", style: TextStyle(color: Colors.black),),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white))),
        ]
      ),);
  }


  CheckboxTag(){
    return Container(
      height: 300.0,
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tags.length,
        itemBuilder: (BuildContext context, int index){
          return CheckboxListTile(title: Text(tags.keys.elementAt(index)) ,value: tags[tags.keys.elementAt(index)], onChanged: (bool? value) {
            setState((){
              tags[tags.keys.elementAt(index)] = value!;
            });
          });
        },
      ),
    );
  }
}