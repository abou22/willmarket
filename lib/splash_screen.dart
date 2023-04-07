import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() async{

    var duration = const Duration (seconds: 8);
    return Timer(duration, (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_){
          return MyHomePage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.0,
                        child: Image.asset(
                          "assets/icon.png",
                          width: 100.0,
                          height: 100.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 17.0),
                      ),
                      Text(
                        "WillMarket",
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 20.0,
                          fontFamily: 'Century Gothic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Expanded(flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.blue.shade900,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "Patientez un instant...",
                      style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
