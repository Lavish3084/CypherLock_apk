import 'package:firebase_auth/firebase_auth.dart';
class FirebaseAuthService {
  final FirebaseAuth _auth;

  // Constructor
  FirebaseAuthService(this._auth);

  // Expose the authStateChanges stream
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
    }
    return null;
  }
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
    }
    return null;
  }
}