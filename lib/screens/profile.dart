

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/screens/profile2_screen.dart';
import 'package:flutter/material.dart';

import '../services/firebase_services.dart';

class ProfileScreen extends StatefulWidget {
   const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String name;
  var dob;
  late final String gender;
  late final bool isMarried;
  bool isLoading = false;

  @override
  void initState() {
    _fetchDataFromFirebase();
    super.initState();
  }

  void _fetchDataFromFirebase() async{
    setState(() {
      isLoading = true;
    });

    final DocumentSnapshot userDoc = await FirebaseServices.getData();

    name = userDoc.get("name");
    gender = userDoc.get("gender");
    isMarried = userDoc.get("isMarried");
    dob = userDoc.get("dob");

    setState(() {
      isLoading = false;
    });

  }

  // screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile screen"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen2(),));

              },
              icon: const Icon(Icons.arrow_forward)),
        ],
      ),
      body:  isLoading? const CircularProgressIndicator():Column(
        children: [
          Text(name),
          Text(gender),
          Text(isMarried? "Married":"Unmarried"),
          Text(dob.toString()),
          TextButton(
              onPressed: () async {
                await FirebaseServices.logOut();
              },
              child: const Text("Log Out"),
          ),

        ],
      ),
    );
  }


}
