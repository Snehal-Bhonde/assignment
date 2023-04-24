import 'dart:convert';

import 'package:assignment/CurrencyConverter.dart';
import 'package:assignment/FriendList.dart';
import 'package:assignment/ProfilePage.dart';
import 'package:assignment/TabPages.dart';
import 'package:assignment/bloc_resources/app_blocs_Hogwarts.dart';
import 'package:assignment/bloc_resources/app_events_Hogwarts.dart';
import 'package:assignment/bloc_resources/app_states_Hogwarts.dart';
import 'package:assignment/bloc_resources/repoHogwartChar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:assignment/model/HogwartCharacters.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:dio/dio.dart';

class CharacterDetails1 extends StatefulWidget {
  @override
  _CharacterDetailsState createState() => _CharacterDetailsState();
}

class _CharacterDetailsState extends State<CharacterDetails1> {
  List<HogwartChars>? list;
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
              // appBar: AppBar(title: Text("Hogwarts Characters"),
              // ),
              body: ListView.builder(
                  itemCount: list != null ? list!.length : 0,
                  itemBuilder: (BuildContext context, int i) {
                    //if(list![i].alternateNames!.isNotEmpty){list![i].alternateNames?.remove("[]");}
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    Text("Name : ${list![i].name}"),
                                    //Text("Alternate Names : ${list![i].alternateNames?.}",softWrap: true,),
                                    Text("Spacies : ${list![i].species}"),
                                    Text("Gender : ${list![i].gender}"),
                                    Text("House : ${list![i].house}"),
                                    Text("Date of Birth : ${list![i]
                                        .dateOfBirth}"),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.all(5),
                                  height: 100, width: 200,
                                  child: list![i].image != null ||
                                      list![i].image != "" ? Image.network(
                                      list![i].image!) : Icon(
                                      Icons.image_not_supported),
                                ),
                              ],
                            ),
                            list![i].yearOfBirth != null || list![i]
                                .yearOfBirth != ""
                                ? Text("Year of Birth : ${list![i]
                                .yearOfBirth}")
                                : Text("Year of Birth :"),
                            list![i].wizard.toString() != "true" ? Text(
                                "Wizard : Yes") : Text("Wizard : No"),
                            list![i].ancestry.toString() != null ? Text(
                                "Ancestry : ${list![i].ancestry}") : Text(
                                "Ancestry :"),
                            list![i].eyeColour.toString() != null
                                ? Text("Eye Colour : ${list![i].eyeColour}")
                                : Text("Eye Colour :"),
                            list![i].hairColour.toString() != null
                                ? Text("Hair Colour : ${list![i]
                                .hairColour}")
                                : Text("Hair Colour :"),
                            Divider(),
                            Text("Wand", style: TextStyle(fontSize: 15)),
                            list![i].wand!.wood.toString() != null ? Text(
                                "wood : ${list![i].wand!.wood}") : Text(
                                "wood :"),
                            list![i].wand!.core.toString() != null ? Text(
                                "Core : ${list![i].wand!.core}") : Text(
                                "Core :"),
                            list![i].wand!.length.toString() != null ? Text(
                                "Length : ${list![i].wand!.core}") : Text(
                                "Length :"),
                            Divider(),
                            list![i].patronus.toString() != "" ? Text(
                                "Patronus : ${list![i].patronus}") : Text(
                                "Patronus :"),
                            list![i].hogwartsStudent.toString() == "true"
                                ? Text("Hogwarts Student : Yes")
                                : Text("Hogwarts Student : No"),
                            list![i].hogwartsStaff.toString() == "true"
                                ? Text("Hogwarts Staff : Yes")
                                : Text("Hogwarts Staff : No"),
                            list![i].actor.toString() != "" ? Text(
                                "Actor : ${list![i].actor}") : Text(
                                "Actor :"),
                            list![i].alive.toString() == "true" ? Text(
                                "Alive : Yes") : Text("Alive : No"),
                            list![i].alternateNames != []
                                ? Text("Alternate Names : ${list![i]
                                .alternateNames}", softWrap: true,)
                                : Text("Alternate Names :"),
                            list![i].alternateActors!.isNotEmpty
                                ? Text("Alternate Actors : ${list![i]
                                .alternateActors}", softWrap: true,)
                                : Text("Alternate Actors :"),

                          ],
                        ),
                      ),
                    );
                  }),
              // body:  TabBarView(
              //   children: [
              //     tabHogwartChar(),
              //     Icon(Icons.directions_transit),
              //     Icon(Icons.directions_bike),
              //   ],
              // ),


              bottomNavigationBar: BottomNavigationBar(
                elevation: 0.0,
                items: <BottomNavigationBarItem>[
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
                //onTap: _onItemTapped,
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
             // setState(() {_selectedIndex = value;});
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfilePage();
                }));
            },
              ),

            )));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getChar() async {
    var url =
    Uri.parse("https://hp-api.onrender.com/api/characters/students");

    // Await the http get response, then decode the json-formatted response.
    // var response = await http.get(url);
    // print(response);
    // if (response.statusCode == 200) {
    //   var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    //   //var result=HogwartChars.fromJson(json.decode(response.body));
    //   var result=HogwartChars.fromJson(jsonResponse);
    //   print(result);
    // } else {
    //   print('Request failed with status: ${response.statusCode}.');
    // }

    var res;
    final Dio dio = new Dio();
    // res= await dio.get("https://hp-api.onrender.com/api/characters/students");
    // HogwartChars result=HogwartChars.fromJson(res);

    Response response = await dio.get(
        "https://hp-api.onrender.com/api/characters/students");
    // if there is a key before array, use this : return (response.data['data'] as List).map((child)=> Children.fromJson(child)).toList();
    list =
        (response.data as List).map((x) => HogwartChars.fromJson(x)).toList();
    print(list);
    setState(() {
      list;
    });
    return (response.data as List)
        .map((x) => HogwartChars.fromJson(x))
        .toList();
  }

  @override
  void initState() {
    getChar();
  }


  Widget tabHogwartChar() {
    return ListView.builder(
        itemCount: list != null ? list!.length : 0,
        itemBuilder: (BuildContext context, int i) {
          //if(list![i].alternateNames!.isNotEmpty){list![i].alternateNames?.remove("[]");}
          return Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name : ${list![i].name}"),
                          //Text("Alternate Names : ${list![i].alternateNames?.}",softWrap: true,),
                          Text("Spacies : ${list![i].species}"),
                          Text("Gender : ${list![i].gender}"),
                          Text("House : ${list![i].house}"),
                          Text("Date of Birth : ${list![i].dateOfBirth}"),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 100, width: 200,
                        child: list![i].image != null || list![i].image != ""
                            ? Image.network(list![i].image!)
                            : Icon(Icons.image_not_supported),
                      ),
                    ],
                  ),
                  list![i].yearOfBirth != null || list![i].yearOfBirth != ""
                      ? Text("Year of Birth : ${list![i].yearOfBirth}")
                      : Text("Year of Birth :"),
                  list![i].wizard.toString() != "true"
                      ? Text("Wizard : Yes")
                      : Text("Wizard : No"),
                  list![i].ancestry.toString() != null ? Text(
                      "Ancestry : ${list![i].ancestry}") : Text("Ancestry :"),
                  list![i].eyeColour.toString() != null ? Text(
                      "Eye Colour : ${list![i].eyeColour}") : Text(
                      "Eye Colour :"),
                  list![i].hairColour.toString() != null ? Text(
                      "Hair Colour : ${list![i].hairColour}") : Text(
                      "Hair Colour :"),
                  Divider(),
                  Text("Wand", style: TextStyle(fontSize: 15)),
                  list![i].wand!.wood.toString() != null ? Text(
                      "wood : ${list![i].wand!.wood}") : Text("wood :"),
                  list![i].wand!.core.toString() != null ? Text(
                      "Core : ${list![i].wand!.core}") : Text("Core :"),
                  list![i].wand!.length.toString() != null ? Text(
                      "Length : ${list![i].wand!.core}") : Text("Length :"),
                  Divider(),
                  list![i].patronus.toString() != "" ? Text(
                      "Patronus : ${list![i].patronus}") : Text("Patronus :"),
                  list![i].hogwartsStudent.toString() == "true" ? Text(
                      "Hogwarts Student : Yes") : Text("Hogwarts Student : No"),
                  list![i].hogwartsStaff.toString() == "true" ? Text(
                      "Hogwarts Staff : Yes") : Text("Hogwarts Staff : No"),
                  list![i].actor.toString() != "" ? Text(
                      "Actor : ${list![i].actor}") : Text("Actor :"),
                  list![i].alive.toString() == "true"
                      ? Text("Alive : Yes")
                      : Text("Alive : No"),
                  list![i].alternateNames != [] ? Text(
                    "Alternate Names : ${list![i].alternateNames}",
                    softWrap: true,) : Text("Alternate Names :"),
                  list![i].alternateActors!.isNotEmpty ? Text(
                    "Alternate Actors : ${list![i].alternateActors}",
                    softWrap: true,) : Text("Alternate Actors :"),

                ],
              ),
            ),
          );
        });
  }

}

class CharacterDetails extends StatelessWidget {
  const CharacterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HogwartsCharBloc>(
          create: (BuildContext context) => HogwartsCharBloc(HogwartsCharRepository()),
        ),
      ],
      child: Scaffold(
          //appBar: AppBar(title: const Text('The BloC App')),
          body: blocBody(),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
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
        //onTap: _onItemTapped,
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
            // setState(() {_selectedIndex = value;});
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfilePage();
                }));
        },
      ),
      )
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => HogwartsCharBloc(
        HogwartsCharRepository(),
      )..add(LoadHogwartCharEvent()),
      child: BlocBuilder<HogwartsCharBloc, HogwartsCharState>(
        builder: (context, state) {
          if (state is HogwartsCharLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is HogwartCharsErrorState) {
            return const Center(child:  Text("Error"));
          }
          if (state is HogwartCharsLoadedState) {
            List<HogwartChars> list = state.hogwartChars;
            return ListView.builder(
                itemCount: list != null ? list!.length : 0,
                itemBuilder: (BuildContext context, int i) {
                  //if(list![i].alternateNames!.isNotEmpty){list![i].alternateNames?.remove("[]");}
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name : ${list![i].name}"),
                                  //Text("Alternate Names : ${list![i].alternateNames?.}",softWrap: true,),
                                  Text("Spacies : ${list![i].species}"),
                                  Text("Gender : ${list![i].gender}"),
                                  Text("House : ${list![i].house}"),
                                  Text("Date of Birth : ${list![i].dateOfBirth}"),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.all(5),
                                height: 100, width: 100,
                                child: list![i].image != null || list![i].image != ""
                                    ? Image.network(list![i].image!)
                                    : Icon(Icons.image_not_supported),
                              ),
                            ],
                          ),
                          list![i].yearOfBirth != null || list![i].yearOfBirth != ""
                              ? Text("Year of Birth : ${list![i].yearOfBirth}")
                              : Text("Year of Birth :"),
                          list![i].wizard.toString() != "true"
                              ? Text("Wizard : Yes")
                              : Text("Wizard : No"),
                          list![i].ancestry.toString() != null ? Text(
                              "Ancestry : ${list![i].ancestry}") : Text("Ancestry :"),
                          list![i].eyeColour.toString() != null ? Text(
                              "Eye Colour : ${list![i].eyeColour}") : Text(
                              "Eye Colour :"),
                          list![i].hairColour.toString() != null ? Text(
                              "Hair Colour : ${list![i].hairColour}") : Text(
                              "Hair Colour :"),
                          Divider(),
                          Text("Wand", style: TextStyle(fontSize: 15)),
                          list![i].wand!.wood.toString() != null ? Text(
                              "wood : ${list![i].wand!.wood}") : Text("wood :"),
                          list![i].wand!.core.toString() != null ? Text(
                              "Core : ${list![i].wand!.core}") : Text("Core :"),
                          list![i].wand!.length.toString() != null ? Text(
                              "Length : ${list![i].wand!.core}") : Text("Length :"),
                          Divider(),
                          list![i].patronus.toString() != "" ? Text(
                              "Patronus : ${list![i].patronus}") : Text("Patronus :"),
                          list![i].hogwartsStudent.toString() == "true" ? Text(
                              "Hogwarts Student : Yes") : Text("Hogwarts Student : No"),
                          list![i].hogwartsStaff.toString() == "true" ? Text(
                              "Hogwarts Staff : Yes") : Text("Hogwarts Staff : No"),
                          list![i].actor.toString() != "" ? Text(
                              "Actor : ${list![i].actor}") : Text("Actor :"),
                          list![i].alive.toString() == "true"
                              ? Text("Alive : Yes")
                              : Text("Alive : No"),
                          list![i].alternateNames != [] ? Text(
                            "Alternate Names : ${list![i].alternateNames}",
                            softWrap: true,) : Text("Alternate Names :"),
                          list![i].alternateActors!.isNotEmpty ? Text(
                            "Alternate Actors : ${list![i].alternateActors}",
                            softWrap: true,) : Text("Alternate Actors :"),

                        ],
                      ),
                    ),
                  );
                });
          }

          return Container();
        },
      ),
    );
  }
}