import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Stream<User> get onAuthStateChanged;
  Future<String> signInAnonymously();
  Future<String> signInWithGoogle();
  Future<String> syncWithGoogle();
  Future<void> signOut();
  Future<User> currentUser();
}
