
import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/FriendList.dart';
import 'package:assignment/LoginPage.dart';
import 'package:assignment/TabPages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() =>ProfilePageState();
  }

class ProfilePageState extends State<ProfilePage>{
  String? userName;
  String? Name;
  int _selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title:Text("Profile"),
            actions: [IconButton(
                onPressed: (){
                  showAlertDialog(context);
                },
                icon: Icon(Icons.logout))],
        ),
        body: Container(
          width: double.infinity,
          height: 200,
          child: Card(
              margin: EdgeInsets.all(15),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Welcome $Name", style: TextStyle(fontSize: 18),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Name     : $Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Email    : $userName"),
                  )
                ],
              )
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Hogwarts character",
              activeIcon: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return TabPages();
                        }));
                  },
                  icon: Icon(Icons.home)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Friends",
              activeIcon: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return FriendList();
                        }));
                  },
                  icon: Icon(Icons.people)),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              activeIcon: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProfilePage();
                        }));
                  },
                  icon: Icon(Icons.person)),
            ),
          ],
          //currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: (value) {
            if (value == 0)
              //setState(() {_selectedIndex = value;});
              Navigator.push(context, MaterialPageRoute(builder: (context) {
              return TabPages();
            }));
            if (value == 1)
              //setState(() {_selectedIndex = value;});
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return FriendList();
                }));
            if (value == 2)
              //setState(() {_selectedIndex = value;});
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfilePage();
                }));
          },
        ),
      ),

    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
   getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("UserName");
      Name = prefs.getString("Name");
    });
  }

}
showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget yesButton = TextButton(
    child: Text("Yes"),
    onPressed:  () async {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('Login'),
      );
    },
  );
  Widget noButton = TextButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    //title: Text("AlertDialog"),
    content: Text("Do you want to Logout?"),
    actions: [
      yesButton,
      noButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
