import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                "images/splash_pic.jpg",
                 fit: BoxFit.cover,
              width: width * .9,
              height: height * .7,
            ),
            SizedBox(height: height* 0.04),
            Text("Prime News",style: GoogleFonts.anton(
              color: Colors.grey.shade700,
              letterSpacing: 6,
              textStyle: TextStyle(fontSize: 21)
            ),),
            SizedBox(height: height* 0.04),
         SpinKitChasingDots(
           size: 40,
           color: Colors.cyan,
         )
          ],
        ),
      ),
    );
  }
}
