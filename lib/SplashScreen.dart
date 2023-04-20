

import 'package:assignment/CharacterDetails.dart';
import 'package:flutter/material.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  State<SplashScreenPage> createState() => SplashScreen();
}

class SplashScreen extends State<SplashScreenPage> {

  @override
  void initState() {
    //futures.add(firebaseMsgListener());
    // firebaseMsgListener();
    // callFunction();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CharacterDetails()),ModalRoute.withName('Home'),
        ));


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var devicesize=MediaQuery.of(context).size;
    var heightdev=devicesize.height;
    print("heightdev  $heightdev");

    double elementWidth = (heightdev/100) * 2.0;
    double heigt=heightdev-elementWidth;
    return Scaffold(
      body: SafeArea(
        child: new Stack(
          children: <Widget>[
            Container(height: double.infinity,width: double.infinity,transform: Matrix4.translationValues(0, 0, 0),
                child:  Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        stops: [
                          0.1,
                          0.4,
                          0.6,
                          0.9,
                        ],
                        colors: [
                          Colors.lightBlue,
                          Colors.lightGreenAccent,
                          Colors.orangeAccent,
                          Colors.pinkAccent.shade200,
                        ],
                      )
                  ),),),
            Positioned(child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(padding: EdgeInsets.only(left: 8.0,right: 8.0,bottom: 8.0),child: LinearProgressIndicator(backgroundColor: Colors.red))
            ),
            )
          ],
        ),
      ),
    );
  }

}









