import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update last login time in Firestore
    if (result.user != null) {
      await _firestore.collection('users').doc(result.user!.uid).update({
        'last_login': DateTime.now().toIso8601String(),
      });
    }

    return result;
  }

  // Register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Save user data to Firestore
  Future<void> saveUserData(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData, SetOptions(merge: true));
  }

  // Update user profile in Firebase Auth and Firestore
  Future<void> updateUserProfile({
    required String userId,
    String? displayName,
    String? photoURL,
    Map<String, dynamic>? additionalData,
  }) async {
    // Update Auth display name if provided
    if (displayName != null && displayName.isNotEmpty) {
      await _auth.currentUser?.updateDisplayName(displayName);
    }

    // Update Firestore data
    Map<String, dynamic> updateData = {
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (displayName != null && displayName.isNotEmpty) {
      updateData['name'] = displayName;
    }

    if (additionalData != null) {
      updateData.addAll(additionalData);
    }

    await _firestore.collection('users').doc(userId).update(updateData);
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      print('Error retrieving user profile: $e');
      return null;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Update user email
  Future<void> updateEmail(String newEmail) async {
    await _auth.currentUser?.updateEmail(newEmail);

    // Update email in Firestore
    if (_auth.currentUser != null) {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'email': newEmail,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
  }

  // Update user password
  Future<void> updatePassword(String newPassword) async {
    await _auth.currentUser?.updatePassword(newPassword);
  }

  // Delete user account
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Delete Firebase Auth account
      await user.delete();
    }
  }
}