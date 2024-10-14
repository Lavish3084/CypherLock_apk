import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Timer to navigate to another screen after 3 seconds
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/login'); // Change '/home' to your next screen route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can change background color
      body: Center(
        child: Image.asset(
          'lib/assets/logo.png', // The path to your logo
          width: 200, // Adjust logo size
          height: 200, // Adjust logo size
        ),
      ),
    );
  }
}
