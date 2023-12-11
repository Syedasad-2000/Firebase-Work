import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_project/firebase_options.dart';
import 'package:flutter/material.dart';

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
      home: MyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  void userRegister()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail.text, password: userPassword.text);
      userEmail.clear();
      userPassword.clear();
    } on FirebaseAuthException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${ex.code.toString()}")));
      userEmail.clear();
      userPassword.clear();
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userEmail.dispose();
    userPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Container(
           margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
           child: TextFormField(
             controller: userEmail,
             decoration: InputDecoration(
               label: Text("Enter Your Email"),
               hintText: "johndoe@gmail.com",
               prefixIcon: Icon(Icons.email),
               border: OutlineInputBorder(
                 borderSide: BorderSide(color: Colors.black),
                 borderRadius: BorderRadius.circular(14)
               )
             ),
           ),
         ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: TextFormField(
              controller: userPassword,
              decoration: InputDecoration(
                  label: Text("Enter Your Password"),
                  hintText: "12**BA@",
                  prefixIcon: Icon(Icons.key),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(14)
                  )
              ),
            ),
          ),
          
          Center(
            child: Container(
              width: 120,
              height: 40,
              child: Center(
                child: ElevatedButton(onPressed: (){
                  print(userEmail.text);
                  print(userPassword.text);
                  userRegister();
                }, child: Text("Register")),
              ),
            ),
          )
       ], 
      ),
    );
  }
}


