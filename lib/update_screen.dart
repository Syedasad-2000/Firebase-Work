import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key, required this.uName, required this.uEmail, required this.uPassword, required this.uAddress, required this.uID, required this.uImage});

  final String uName;
  final String uEmail;
  final String uPassword;
  final String uAddress;
  final String uID;
  final String uImage;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();

  @override
  void initState() {
    userName.text = widget.uName;
    userAddress.text = widget.uAddress;
    userEmail.text = widget.uEmail;
    userPassword.text = widget.uPassword;
    // TODO: implement initState
    super.initState();
  }

  void userWithImage()async{
    
    await FirebaseStorage.instance.refFromURL(widget.uImage).delete();
    UploadTask uploadTask = FirebaseStorage.instance.ref().child("Image").child(widget.uID).putFile(userProfile!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    userUpdate(
      userImage: imageUrl);
  }
  
  void userUpdate({String? userImage})async{
    try{
      await FirebaseFirestore.instance.collection("userData").doc(widget.uID).update(
          {
            "userName" : userName.text,
            "userAddress": userAddress.text,
            "userEmail": userEmail.text,
            "userPassword": userPassword.text,
            "userImage" : userImage
          });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User Updated")));
      Navigator.pop(context);
    } on FirebaseException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
  }

  File? userProfile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(
            height: 10,
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
              child: userProfile == null ?
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(widget.uImage) ,
                ),
              ):
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  backgroundImage: userProfile != null ? FileImage(userProfile!) : null ,
                ),
              )
          ),

          const SizedBox(
            height: 10,
          ),
          
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
                }, child: Text("Update User")),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
