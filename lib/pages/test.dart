import "package:flutter/material.dart" ; 
import 'dart:async';
import 'package:mobtech/pages/home.dart';
 class Splash extends StatefulWidget {
   Splash({Key key}) : super(key: key);
 
   @override
   _SplashState createState() => _SplashState();
 }
  
 
 class _SplashState extends State<Splash> {

   @override
   void initState() { 
     super.initState();
       Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => Home())));
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: Column( mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Center(child: Text("Loading... " , style: TextStyle(fontSize: 40),))
       ],)
     );
   }
 }