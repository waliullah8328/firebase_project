import 'package:firebase_project/services/firebase_services.dart';
import 'package:flutter/material.dart';

class ProfileScreen2 extends StatelessWidget {
  const ProfileScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Screen 2"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirebaseServices.profileDataStream,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasError){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("An error occurred ${snapshot.error}"),
                ),
              );
            }
            else if (!snapshot.hasData){
              return const Center(child: Text("No data available"));

            }
            Map<String, dynamic>data = snapshot.data!.data() as Map<String,dynamic>;
            return Column(
              children: [
                Text(data["name"]),
                Text(data["gender"]),
                Text(data["isMarried"]? "Married":"Unmarried"),
                Text(data["dob"].toString()),
              ],
            );
          },
      ),
    );
  }
}
