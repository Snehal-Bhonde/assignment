

import 'package:assignment/AddFriend.dart';
import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/CurrencyConverter.dart';
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
      appBar: AppBar(title: Text('Records')),
      // body: _buildListEmpList(),
      body: myfriendsList.isEmpty
          ? const Center(child: const Text('You don\'t have any records yet'))
          :

      ListView.builder(
        itemCount: myfriendsList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("ID: ${myfriendsList[index].userId}"),
                    Text(
                        " Name: ${myfriendsList[index].Name}"),
                    //Text("Last Name: ${myRegForms[index].lastName}",textAlign: TextAlign.start,),
                    Text("Mobile: ${myfriendsList[index].mobNo}",textAlign: TextAlign.start,),
                    Text("Email: ${myfriendsList[index].email}",textAlign: TextAlign.start,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) {
                              //   return RegisterForms(registerForm: myRegForms[index],
                              //   );
                              // }));
                            },
                            child: Text("Edit")),
                        SizedBox(width: 20,),
                        ElevatedButton(
                            onPressed: () {
                              print("delete clicked");
                              showAlertDialog(context,myfriendsList[index]);
                              print("end");
                            },
                            child: Text("Delete")),

                      ],
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
        child:Text("Add"),
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
                        return CharacterDetails();
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
                icon: Icon(Icons.home)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: "Currency",
            activeIcon: IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return CurrencyConverter();
                      }));
                },
                icon: Icon(Icons.home)),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  Widget _buildCard(BuildContext context) {
    return Wrap(
        children: [
          ListView.builder(
            itemCount: myfriendsList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("ID: ${myfriendsList[index].userId}"),
                        Text(
                            "First Name: ${myfriendsList[index].Name}"),
                        Text("Mobile: ${myfriendsList[index].mobNo}",textAlign: TextAlign.start,),
                        Text("Email: ${myfriendsList[index].email}",textAlign: TextAlign.start,),
                        // Text("Total Recovered: ${model.data![index].profileImage}"),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {

                                },
                                child: Text("Edit")),
                            SizedBox(width: 20,),
                            ElevatedButton(
                                onPressed: () {
                                  print("delete clicked");
                                  showAlertDialog(context,myfriendsList[index]);
                                  print("end");
                                },
                                child: Text("Delete")),

                          ],
                        ),

                      ],

                    ),
                  ),
                ),
              );
            },
          ),
        ]);
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());


  showAlertDialog(BuildContext context, FriendForm myRegForm) {
    // set up the buttons
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        delete(registerForm: myRegForm, context: context);
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
      content: Text("Do you want to delete this record?"),
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

  void getRecords() async {
    await DatabaseRepository.instance.getAllFriends().then((value) {
      setState(() {
        myfriendsList = value;
      });
    }).catchError((e) => debugPrint(e.toString()));
  }

  void delete({required FriendForm registerForm, required BuildContext context}) async {
    DatabaseRepository.instance.delete(registerForm.userId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
      Navigator.pop(context);
      setState(() {
        getRecords();
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }
}