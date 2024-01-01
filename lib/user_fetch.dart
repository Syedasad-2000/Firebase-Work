import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/user_register.dart';
import 'package:flutter/material.dart';

class UserFetch extends StatefulWidget {
  const UserFetch({super.key});

  @override
  State<UserFetch> createState() => _UserFetchState();
}

class _UserFetchState extends State<UserFetch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Fetch"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(
            height: 30,
          ),

         StreamBuilder(
             stream: FirebaseFirestore.instance.collection("userData").snapshots(),
             builder: (context, snapshot) {

               if(snapshot.connectionState == ConnectionState.waiting){
                 return CircularProgressIndicator();
               }

               if(snapshot.hasData){
                 var dataLengtht = snapshot.data!.docs.length;

                 return ListView.builder(
                   itemCount: dataLengtht,
                   shrinkWrap: true,
                   itemBuilder: (context, index) {

                     String userName = snapshot.data!.docs[index]["userName"];
                     String userEmail = snapshot.data!.docs[index]["userEmail"];

                     return  ListTile(
                       leading: Icon(Icons.person),
                       title: Text(userName),
                       subtitle: Text(userEmail),
                     );
                   },);
               }

               if(snapshot.hasError){
                 return Icon(Icons.error,color: Colors.red,);
               }


               return Container();
             },)

        ],
      ),
    );
  }
}
