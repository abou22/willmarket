import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:willmarket/splash_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WillMarket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Century Gothic',
      ),
      home: Scaffold(
        body: Container(
          child: SafeArea(
            child: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
