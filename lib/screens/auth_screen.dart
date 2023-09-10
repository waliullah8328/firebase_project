import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_project/controllers/auth_controller.dart';
import 'package:flutter/material.dart';


class AuthScreen extends StatelessWidget {
   const AuthScreen({super.key});




  @override
  Widget build(BuildContext context) {
    final controller = AuthController(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                  hintText: "Enter name"
              ),
            ),
            TextFormField(
              controller: controller.genderController,
              decoration: const InputDecoration(
                  hintText: "Enter gender"
              ),
            ),

            TextFormField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                  hintText: "Enter Email"
              ),
            ),

            TextFormField(
              controller: controller.passwordController,
              decoration: const InputDecoration(
                  hintText: "Enter Password"
              ),
            ),

            Row(
              children: [
                TextButton(
                    onPressed: controller.loginProcess,
                    child: const Text(
                        "Login"
                    )
                ),

                TextButton(
                    onPressed: controller.registrationProcess,
                    child: const Text(
                        "Registration"
                    )
                )
              ],
            ),

            InkWell(
              onTap: controller.continueWithGoogle,
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(
                    horizontal: 18
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTs4w2x17JFNa6MfO7sFDyqE0th8s3P0N48VrBesNvWIQ&s"),
                    const Center(
                      child: Text(
                        "Continue with Google",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    const SizedBox()
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }


}
