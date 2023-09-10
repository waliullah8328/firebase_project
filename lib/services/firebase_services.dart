import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User get user => _auth.currentUser!;

  // firebase Authentication

  static Future<UserCredential> signInWithGoogle() async {
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


  static Future<UserCredential> createUserWithEmailAndPassword(
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

  static Future<UserCredential> signInWithEmailAndPassword(
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

  // firestore
  static setData(Map<String,dynamic> userData) async {
    await _firestore.collection("publics").doc(user.uid).set(userData);
  }
  // for getData
  static Future<DocumentSnapshot<Map<String, dynamic>>> getData() async {
    return await _firestore.collection("publics").doc(user.uid).get();
  }

  static Stream<DocumentSnapshot<Map<String,dynamic>>>
           get profileDataStream =>  _firestore.collection("publics").doc(user.uid).snapshots();

  static logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}