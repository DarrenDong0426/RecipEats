import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipeats/utils/const/color_gradient.dart';

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

  final List<Widget> _widgetOption = <Widget>[
    Home_Screen(),
    Search_Recipes(),
    addRecipes(),
    notification(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: _widgetOption[index],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: hexStringToColor('d76b5b'),
        onPressed: () {
          setState(() {
            index = 2;
          });

        },
      ),
      bottomNavigationBar:

       BottomAppBar(

        shape: CircularNotchedRectangle(),

        notchMargin: 10.0,
        child: Row(

          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(

              icon: Icon(Icons.home),

              onPressed: () {
                setState(() {
                  index = 0;
                });

              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  index = 1;
                });

              },
            ),
           /* IconButton(
              icon: Icon(null),
              onPressed: () {},
            ),*/
            Container(height: 65.0,width: 15.0,),

            IconButton(
              icon: Icon(Icons.circle_notifications),
              onPressed: () {
                setState(() {
                  index = 3;
                });

              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                setState(() {
                  index = 4;
                });

              },
            )
          ],
        ),
      ),


        /*bottomNavigationBar: BottomNavigationBar(

        items: [
            BottomNavigationBarItem(icon: Icon(Icons.home, color: Color(0xff51564e)), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.search, color: Color(0xff51564e)), label: ''),
            BottomNavigationBarItem(
              icon: Container(
                decoration: BoxDecoration(
                    color: Color(0xff51564e),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Icon(Icons.add),
                ),
              ),
                label: ''
                //icon: Icon(Icons.add, color: Colors.black), label: ''
            ),
            BottomNavigationBarItem(icon: Icon(Icons.circle_notifications, color: Color(0xff51564e)), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person, color: Color(0xff51564e)), label: ''),
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
        )*/
    );
  }
}