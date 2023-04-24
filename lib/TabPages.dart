
import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/CurrencyConverter.dart';
import 'package:flutter/material.dart';

class TabPages extends StatefulWidget {
  @override
  TabPagesState createState() => TabPagesState();
}

class TabPagesState extends State<TabPages> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
            child: Scaffold(
                appBar:  TabBar(
                  dividerColor: Colors.indigoAccent,

                    tabs: [
                      Tab(child: Text("Hogwarts Characters",style: TextStyle(color: Colors.black),)),
                      Tab(child:Text("Currency Converter",style: TextStyle(color: Colors.black),))
                    ],
                  ),
                //),
              body:  TabBarView(
                children: [
                  CharacterDetails(),
                  CurrencyConverter(),
                ],
              ),

            )));
  }
}