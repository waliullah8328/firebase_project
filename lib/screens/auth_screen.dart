import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});


  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              controller: emailController,
              decoration: const InputDecoration(
                  hintText: "Enter Email"
              ),
            ),

            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                  hintText: "Enter Password"
              ),
            ),

            Row(
              children: [
                TextButton(
                    onPressed: loginProcess,
                    child: const Text(
                        "Login"
                    )
                ),

                TextButton(
                    onPressed: registrationProcess,
                    child: const Text(
                        "Registration"
                    )
                )
              ],
            ),

            InkWell(
              onTap: continueWithGoogle,
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

            TextButton(
                onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                },
                child: const Text("Log Out")
            )
          ],
        ),
      ),
    );
  }

  void continueWithGoogle() async{
    final userCredential = await signInWithGoogle();
    debugPrint("-------signInWithGoogle  =>  1  --------");

    final user = userCredential.user!;

    debugPrint(user.email);
    debugPrint(user.displayName ?? "NULL Issue");
    debugPrint(user.photoURL ?? "NULL Issue");
    debugPrint(user.uid);
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  Future<UserCredential> createUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final auth = FirebaseAuth.instance;
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await auth.currentUser!.sendEmailVerification();
      await auth.currentUser!.reload();

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // "The password provided is too weak.".bgRedConsole;
        // ToastMessage.error("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        // 'The account already exists for that email.'.bgRedConsole;
        // ToastMessage.error('The account already exists for that email.');
      }
      throw UnimplementedError();
    } catch (e) {
      // e.toString().redConsole;
      // ToastMessage.error(e.toString());
      throw UnimplementedError();
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // "No user found for that email.".bgRedConsole;
        // ToastMessage.error("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        // 'Wrong password provided for that user.'.bgRedConsole;
        // ToastMessage.error('Wrong password provided for that user.');
      }
      throw UnimplementedError();
    } catch (e) {
      // e.toString().redConsole;
      throw UnimplementedError();
    }
  }

  void loginProcess() async{

    final userCredential = await signInWithEmailAndPassword(
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

  void registrationProcess() async{
    final userCredential = await createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text
    );
    debugPrint("-------signInWithGoogle  =>  1  --------");


    final user = userCredential.user!;

    debugPrint(user.email);
    debugPrint(user.displayName);
    debugPrint(user.photoURL);
    debugPrint(user.uid);
  }
}
