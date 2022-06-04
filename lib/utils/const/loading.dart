import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget{

  @override
  LoadingState createState() => LoadingState();

}

class LoadingState extends State<Loading>{

  String loadState = "assets/images/loading1.png";
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(loadState),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 200), (t) {
      if (loadState == "assets/images/loading1.png"){
        if(mounted) {
          setState(() {
            loadState = "assets/images/loading2.png";
          });
        }
      }
      else if (loadState == "assets/images/loading2.png"){
        if (mounted) {
          setState(() {
            loadState = "assets/images/loading3.png";
          });
        }
      }
      else if (loadState == "assets/images/loading3.png"){
        if (mounted) {
          setState(() {
            loadState = "assets/images/loading4.png";
          });
        }
      }
      else if (loadState == "assets/images/loading4.png"){
        if (mounted) {
          setState(() {
            loadState = "assets/images/loading5.png";
          });
        }
      }else if (loadState == "assets/images/loading5.png"){
        if (mounted) {
          setState(() {
            loadState = "assets/images/loading1.png";
          });
        }
      }
    });
  }

}
