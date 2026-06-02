import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream of auth changes
  Stream<User?> get user => _auth.authStateChanges();

  // Login
  Future<User?> login(String email, String password) async {
    try {
      // 1. Restrict to the single specific admin email
      final String adminEmail = 'admin@expensetracker.com';
      final String adminPassword = 'AdminPassword123!';

      if (email.trim().toLowerCase() != adminEmail) {
        throw Exception('Access Denied: Only the specific admin can login.');
      }

      UserCredential result;
      try {
        result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        // 2. If the user doesn't exist yet, and they entered the correct generated credentials, create it in DB
        if (e.code == 'user-not-found' || e.code == 'invalid-credential' || e.code == 'invalid-email') {
          if (password == adminPassword) {
            result = await _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
            // Save admin role in Firestore
            await _db.collection('users').doc(result.user!.uid).set({
              'role': 'admin',
              'email': email,
              'createdAt': FieldValue.serverTimestamp(),
            });
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      User? user = result.user;

      if (user != null) {
        // Check role in Firestore to ensure it's still admin
        DocumentSnapshot doc = await _db.collection('users').doc(user.uid).get();
        if (doc.exists) {
          String role = doc.get('role') ?? 'user';
          if (role != 'admin') {
            await _auth.signOut();
            throw Exception('Access Denied: Admin only.');
          }
        } else {
          // If doc is missing, recreate it
          await _db.collection('users').doc(user.uid).set({
            'role': 'admin',
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
