import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_model.dart';


class AuthService {
 final FirebaseAuth _auth = FirebaseAuth.instance;
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<UserModel?> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential credential = 
        await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
        );
      User? firebaseUser = credential.user;
      if (firebaseUser != null) {
       
        UserModel userModel = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email!,
          name: name,
        );
        await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(userModel.toJson());
        return userModel;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
}

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
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  // CURRENT USER
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
