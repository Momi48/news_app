import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:google_maps_project/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 5), () {
     //remove the arrow 
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen(

            
          )));
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    //final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: [
            Image.asset(
              'images/splash_pic.jpg',
              fit: BoxFit.cover,
              height: height * 0.8,
            ),
            SizedBox(
              height: height * 0.04,
            ),
           const Text(
              'Top HEADLINES',
              style:  TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
            ),
            SizedBox(
              height: height * 0.01,
            ),
           const SpinKitChasingDots(
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
