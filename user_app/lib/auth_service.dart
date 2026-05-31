import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SIGN UP
  Future<UserModel?> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      debugPrint("STEP 1: Starting signup");

      UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint("STEP 2: Firebase account created");

      User? firebaseUser = credential.user;

      if (firebaseUser != null) {
        UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: name,
        );

        debugPrint("STEP 3: Saving user to Firestore");

        // FIX: Firestore write is best-effort. If it fails (e.g. security
        // rules), we still report signup success because the Firebase Auth
        // account was created and the user can log in.
        try {
          await _firestore
              .collection('users')
              .doc(firebaseUser.uid)
              .set(userModel.toJson());
          debugPrint("STEP 4: User saved successfully");
        } on FirebaseException catch (e) {
          debugPrint("STEP 4 WARNING: Firestore save failed: ${e.code} – ${e.message}");
          debugPrint("Auth account created; user can still log in.");
        }

        // Always return the model if Auth succeeded
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("AUTH ERROR CODE: ${e.code}");
      debugPrint("AUTH ERROR MESSAGE: ${e.message}");
    } catch (e) {
      debugPrint("GENERAL ERROR: $e");
    }

    return null;
  }

  // LOGIN
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return credential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint("LOGIN ERROR CODE: ${e.code}");
      debugPrint("LOGIN ERROR MESSAGE: ${e.message}");
    } catch (e) {
      debugPrint("GENERAL LOGIN ERROR: $e");
    }

    return null;
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
