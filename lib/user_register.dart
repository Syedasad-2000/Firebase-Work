import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {

  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();


  // void addUser()async{
  //
  //   Map<String, dynamic> uAdd = {
  //     "userName" : userName.text,
  //     "userAddress": userAddress.text,
  //     "userEmail": userEmail.text,
  //     "userPassword": userPassword.text
  //   };
  //
  //   await FirebaseFirestore.instance.collection("userData").add(uAdd);
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Added")));
  // }


  void userAddWithCustomID()async{

    var userID = Uuid().v4();

    Map<String, dynamic> uAdd = {
      "userId" : userID,
      "userName" : userName.text,
      "userAddress": userAddress.text,
      "userEmail": userEmail.text,
      "userPassword": userPassword.text
    };

    await FirebaseFirestore.instance.collection("userData").doc(userID).set(uAdd);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Added")));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: TextFormField(
              controller: userName,
              decoration: InputDecoration(
                  label: Text("Enter Your Name"),
                  hintText: "john doe",
                  prefixIcon: Icon(Icons.person),
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
              controller: userAddress,
              decoration: InputDecoration(
                  label: Text("Enter Your Address"),
                  hintText: "Street 123",
                  prefixIcon: Icon(Icons.location_on),
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
              controller: userEmail,
              decoration: InputDecoration(
                  label: Text("Enter Your Email"),
                  hintText: "johndoe@gmail.com",
                  prefixIcon: Icon(Icons.mail),
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
                  userAddWithCustomID();
                }, child: Text("Add User")),
              ),
            ),
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
