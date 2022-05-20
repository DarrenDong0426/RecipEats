import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../screens/add_recipes/add_recipes.dart';
import '../../screens/edit_account/Profile.dart';
import '../../screens/edit_account/edit_account.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../screens/notification/notification.dart';
import '../../screens/search_recipes/search_recipe.dart';


class navBar extends StatefulWidget {
  const navBar({Key? key}) : super(key: key);

  @override
  _navBarState createState() => _navBarState();
}

class _navBarState extends State<navBar> {

  int index = 0;

  List<Widget> _widgetOption = <Widget>[
    Home_Screen(),
    Search_Recipes(),
    addRecipes(),
    notification(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _widgetOption[index],
        bottomNavigationBar: BottomNavigationBar(
        items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.circle_notifications, color: Colors.black), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: Colors.black), label: ''),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          onTap: (i){
            setState(() {
              index = i;
            });
          },
        )
    );
  }
}