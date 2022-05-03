import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cardview extends StatefulWidget{
  late final String recipe;
  late final String author;
  late final String image;

  @override
  State<StatefulWidget> createState() => _CardviewState();

}

class _CardviewState extends State<Cardview> {
  late final String recipe = widget.recipe;
  late final String author = widget.author;
  late final String image = widget.image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          borderRadius:
          const BorderRadius.all(Radius.circular(100.0)),
          border: Border.all(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
      );
  }

}