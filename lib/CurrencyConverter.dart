import 'dart:async';
import 'dart:convert';
import 'package:assignment/CharacterDetails.dart';
import 'package:assignment/FriendList.dart';
import 'package:assignment/ProfilePage.dart';
import 'package:assignment/TabPages.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(new MaterialApp(
  title: "Currency Converter",
  home: CurrencyConverter(),
));

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromTextController = TextEditingController();
  List<String>? currencies;
  String fromCurrency = "USD";
  String toCurrency = "GBP";
  String? result;
  int _selectedIndex = 0;

  String amount="";

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<String> _loadCurrencies() async {
    String uri = "https://v6.exchangerate-api.com/v6/268cdee972de1862d528e18e/latest/USD";
    var response = await http
        .get(Uri.parse(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    print(responseBody);
    Map curMap = responseBody['conversion_rates'];
    currencies = curMap.keys.toList() as List<String>;
    setState(() {});
    //print(currencies);
    return "Success";
  }

  Future<String> _doConversion() async {
    double amt=double.parse(amount);
    String uri = "https://v6.exchangerate-api.com/v6/268cdee972de1862d528e18e/pair/$fromCurrency/$toCurrency/$amt";
    var response = await http
        .get(Uri.parse(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    print("responseBody $responseBody");
    var curMap = responseBody['conversion_rate'];
    setState(() {
      result = responseBody['conversion_result'].toString();
    });
    print("result $result");
    return "Success";
  }

  _onFromChanged(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  _onToChanged(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  // title: Text("Currency Converter"),
      // ),
      body: currencies == null
          ? Center(child: CircularProgressIndicator())
          : Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ListTile(
                  title: TextField(
                    controller: fromTextController,
                    style: TextStyle(fontSize: 20.0, color: Colors.black),
                    keyboardType:
                    TextInputType.numberWithOptions(decimal: true),
                    onChanged: (val){
                      amount=val;
                    },
                  ),
                  trailing: _buildDropDownButton(fromCurrency),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: _doConversion,
                ),
                ListTile(
                  title: Chip(
                    label: result != null ?
                    Text(
                      result!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    ) : Text(""),
                  ),
                  trailing: _buildDropDownButton(toCurrency),
                ),
              ],
            ),
          ),
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
           // setState(() {_selectedIndex = value;});
            Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CharacterDetails();
          }));
          if (value == 1)
           // setState(() {_selectedIndex = value;});
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


    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDropDownButton(String currencyCategory) {
    return DropdownButton(
      value: currencyCategory,
      items: currencies!
          .map((String value) => DropdownMenuItem(
        value: value,
        child: Row(
          children: <Widget>[
            Text(value),
          ],
        ),
      ))
          .toList(),
      onChanged: ( value) {
        if(currencyCategory == fromCurrency){
          _onFromChanged(value.toString());
        }else {
          _onToChanged(value.toString());
        }
      },
    );
  }
}