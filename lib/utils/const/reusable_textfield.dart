
import 'package:flutter/material.dart';

import 'color_gradient.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

Container reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, TextInputType type) {

  return
    Container(
      width: 350,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8)
      ),
      child:TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Color(0xffd76b5b),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black),
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
        borderSide: BorderSide(color: Color(0xffd76b5b)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffd76b5b)),
      ),
    ),
    keyboardType: type
  )
    );
}

TextFormField reusableTextField2(IconData icon, bool isPasswordType,
    TextEditingController controller, TextInputType type) {
  return TextFormField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
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
      keyboardType: type
  );
}



TextField reusableTextField3(String text, IconData icon, bool isPasswordType,
    TextEditingController controller, TextInputType type) {
  return TextField(
      controller: controller,
      obscureText: isPasswordType,
      enableSuggestions: !isPasswordType,
      autocorrect: !isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        labelText: text,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
       // fillColor: hexStringToColor('454F8C').withOpacity(0.8),
       /* border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),*/
      ),
      keyboardType: type
  );
}

Container submitButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: 350,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () => {
        onTap()
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Color(0xffd76b5b);
            }
            return Color(0xffd76b5b);
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
    ),
  );
}