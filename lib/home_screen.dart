import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDashboard extends StatefulWidget {
  const MyDashboard({super.key});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

class _MyDashboardState extends State<MyDashboard> {

  void userLogout()async{
    await FirebaseAuth.instance.signOut();
    SharedPreferences userCred = await SharedPreferences.getInstance();
    userCred.clear();
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
  }

  String userEmail = '';

  Future getUserCred()async{
    SharedPreferences userCred = await SharedPreferences.getInstance();
    return userCred.getString("userCred");
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserCred().then((value) {
      setState(() {
        userEmail = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userEmail),
      ),
      body: Column(
        children: [
          TextButton(onPressed: (){
            userLogout();
          }, child: Text("LogOut"))
        ],
      ),
    );
  }
}
