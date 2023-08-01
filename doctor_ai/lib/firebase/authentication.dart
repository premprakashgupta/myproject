import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Login Successfull';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return 'Something went wrong.';
    } catch (e) {
      return 'Something went wrong.';
    }
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required String username,
      required String role}) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the user's unique ID (UID)
      String uid = userCredential.user!.uid;

      // Add user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'username': username,
        'role': role,
        'id': uid,
        'timeStamp': DateTime.now(),
      });

      return 'Sign up successful';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      }
      return 'Something went wrong.';
    } catch (e) {
      return 'Something went wrong.';
    }
  }
}
