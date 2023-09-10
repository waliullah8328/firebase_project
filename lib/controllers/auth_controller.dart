// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/screens/profile.dart';
import 'package:firebase_project/services/firebase_services.dart';
import 'package:flutter/material.dart';

class AuthController{
  final BuildContext context;

  AuthController(this.context);



  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final genderController = TextEditingController();



  // For google signIn method
  void continueWithGoogle() async{
    final UserCredential userCredential = await FirebaseServices.signInWithGoogle();
    debugPrint("-------signInWithGoogle  =>  1  --------");

    final user = userCredential.user!;

    debugPrint(user.email);
    debugPrint(user.displayName ?? "NULL Issue");
    debugPrint(user.photoURL ?? "NULL Issue");
    debugPrint(user.uid);
     _createUserDatabase(userCredential);
  }


// For google Password SignIn method
  void loginProcess() async{

    final UserCredential userCredential = await FirebaseServices.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    );
    debugPrint("-------signInWithGoogle  =>  1  --------");

    if(userCredential.user!.emailVerified){
      final user = userCredential.user!;

      debugPrint(user.email);
      debugPrint(user.displayName);
      debugPrint(user.photoURL);
      debugPrint(user.uid);
      debugPrint("Valid User");

    }else{
      debugPrint("Invalid User");
    }

  }

  // For google Registration  method
  void registrationProcess() async{
    final UserCredential userCredential = await FirebaseServices.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text

    );
    debugPrint("-------signInWithGoogle  =>  1  --------");


    final user = userCredential.user!;

    debugPrint(user.email);
    debugPrint(user.displayName);
    debugPrint(user.photoURL);
    debugPrint(user.uid);
    _createUserDatabase(userCredential);
  }

  _createUserDatabase(UserCredential userData)async{

    if(userData.additionalUserInfo!.isNewUser){
      await FirebaseServices.setData({
        "id":userData.user!.uid.toString(),
        "name":nameController.text,
        "isMarried":false,
        "gender":genderController.text,
        "dob":DateTime.now(),

      });
      debugPrint("Data Stored");

      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(),));

    }
    else{
      debugPrint("Already Exits");
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProfileScreen(),));

    }



  }

  // For google logOut method

}