

import 'package:assignment/AddFriend.dart';
import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/CurrencyConverter.dart';
import 'package:assignment/ProfilePage.dart';
import 'package:assignment/TabPages.dart';
import 'package:assignment/database/DatabaseHelper.dart';
import 'package:flutter/material.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  List<FriendForm> myfriendsList = [];

  int _selectedIndex=0;


  @override
  void initState() {

    initDb();
    getRecords();
    super.initState();
  }
  void initDb() async {
    await DatabaseRepository.instance.database;
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('My Friends')),
      // body: _buildListEmpList(),
      body: myfriendsList.isEmpty
          ? const Center(child: const Text('You don\'t have any friend yet'))
          :

      ListView.builder(
        itemCount: myfriendsList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Name: ${myfriendsList[index].Name}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Mobile: ${myfriendsList[index].mobNo}",textAlign: TextAlign.start,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Email: ${myfriendsList[index].email}",textAlign: TextAlign.start,),
                    ),

                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return FriendDetails(friendForm: myfriendsList[index],
                              );
                            }));
                          },
                          child: Text("Edit")),
                    ),

                  ],

                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AddFriend(//registerForm: myRegForms[index],
          );
        },
        ),
        );
      },
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(child: Text("Add Friend",style: TextStyle(fontSize: 11),)),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
       // onTap:_onItemTapped,
        onTap: (value) {
          if (value == 0)
            setState(() {_selectedIndex = value;});
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TabPages();
          }));
          if (value == 1)
            setState(() {_selectedIndex = value;});
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return FriendList();
              }));
          if (value == 2)
            setState(() {_selectedIndex = value;});
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ProfilePage();
              }));
        },
      ),
    );
  }
  void _onItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
    if (value == 0) Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CharacterDetails();
    }));
    if (value == 1) Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return FriendList();
        }));
    if (value == 2) Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return ProfilePage();
        }));
  }




  // showAlertDialog(BuildContext context, FriendForm myRegForm) {
  //   // set up the buttons
  //   Widget yesButton = TextButton(
  //     child: Text("Yes"),
  //     onPressed:  () {
  //       delete(registerForm: myRegForm, context: context);
  //     },
  //   );
  //   Widget noButton = TextButton(
  //     child: Text("No"),
  //     onPressed:  () {
  //       Navigator.pop(context);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     //title: Text("AlertDialog"),
  //     content: Text("Do you want to delete this record?"),
  //     actions: [
  //       yesButton,
  //       noButton,
  //     ],
  //   );
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

  void getRecords() async {
    await DatabaseRepository.instance.getAllFriends().then((value) {
      setState(() {
        myfriendsList = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  // void delete({required FriendForm registerForm, required BuildContext context}) async {
  //   DatabaseRepository.instance.delete(registerForm.userId!).then((value) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Deleted')));
  //     Navigator.pop(context);
  //     setState(() {
  //       getRecords();
  //     });
  //   }).catchError((e) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(e.toString())));
  //   });
  // }
}

class FriendDetails extends StatefulWidget{
  FriendForm? friendForm;
  FriendDetails({Key? key, this.friendForm}) : super(key: key);
  @override
  State<FriendDetails> createState()=>FriendDetailsPage();
}

class FriendDetailsPage extends State<FriendDetails>{
  FriendForm? friendDetails;
  @override
  void initState() {
    getData();
    super.initState();
  }
  void getData() {
    if (widget.friendForm != null) {
      if (mounted) {
        setState(() {
          friendDetails=widget.friendForm;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title:Text("Friend Details")),
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
                  child: Text("Name     : ${friendDetails?.Name}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Mob. No. : ${friendDetails?.mobNo}"),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Email    : ${friendDetails?.email}"),
                )
              ],
            )
          ),
        ),
      ),

    );
  }
  
}