import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:firebase_project/home_screen.dart';
import 'package:firebase_project/login_screen.dart';
import 'package:firebase_project/user_fetch.dart';
import 'package:firebase_project/user_register.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future screenRedirector()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();

    return userCred.getString("userEmail");
  }

  @override
  void initState() {
    // TODO: implement initState
    screenRedirector().then((value) {
      if (value != null ) {
        Timer(Duration(milliseconds: 5000), () => Navigator.push(context, MaterialPageRoute(builder:  (context) => MyDashboard(),)));
      }
      else{
        Timer(Duration(milliseconds: 5000), () =>Navigator.push(context, MaterialPageRoute(builder:  (context) => LoginScreen(),)));
      }
    },);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          child: Lottie.asset('images/logo.json', fit: BoxFit.contain),
          color: Colors.blue,
        ),
      ),
    );
  }
}



