import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_project/update_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  File? userProfile;


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


  void userWithImage()async{

    var userID = Uuid().v4();

    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Image").child(userID).putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    userAddWithCustomID(
        userID: userID,
        userImage: imageUrl);
  }


  void userAddWithCustomID({String? userImage, String? userID})async{


    Map<String, dynamic> uAdd = {
      "userId" : userID,
      "userName" : userName.text,
      "userAddress": userAddress.text,
      "userEmail": userEmail.text,
      "userPassword": userPassword.text,
      "userImage" : userImage
    };

    await FirebaseFirestore.instance.collection("userData").doc(userID).set(uAdd);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Added")));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(
              height: 30,
            ),

            GestureDetector(
                onTap: ()async{
                  XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickImage != null) {
                    File convertedFile = File(pickImage.path);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image selected")));
                    setState(() {
                      userProfile = convertedFile;
                    });
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image not selected")));
                  }
                },
                child: Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    backgroundImage: userProfile != null ? FileImage(userProfile!) : null ,
                  ),
                )),

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
                    userWithImage();
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
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {

                      String userName = snapshot.data!.docs[index]["userName"];
                      String userEmail = snapshot.data!.docs[index]["userEmail"];
                      String userAddress = snapshot.data!.docs[index]["userAddress"];
                      String userPassword = snapshot.data!.docs[index]["userPassword"];
                      String userImage = snapshot.data!.docs[index]["userImage"];
                      String userID = snapshot.data!.docs[index]["userId"];
                      return  GestureDetector(
                        onDoubleTap: ()async{
                          try{
                            await FirebaseFirestore.instance.collection("userData").doc(userID).delete();
                            await FirebaseStorage.instance.refFromURL(userImage).delete();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Deleted Successfully")));

                          } on FirebaseException catch(ex){
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
                          }
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(userImage),
                          ),
                          title: Text(userName),
                          subtitle: Text(userEmail),
                          trailing: IconButton(onPressed:(){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateScreen(
                              uName: userName,
                              uEmail: userEmail,
                              uAddress: userAddress,
                              uPassword: userPassword,
                              uID: userID,
                              uImage: userImage,
                            ),));
                          },icon:Icon(Icons.update))
                        ),
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
      ),
    );
  }
}
