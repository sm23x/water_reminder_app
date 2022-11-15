import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:water_reminder_app/src/global_blocs/auth/base_auth.dart';

class Auth implements BaseAuth {
  final _firebaseAuth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  Future<String> signInAnonymously() async {
    final user = await _firebaseAuth.signInAnonymously();
    return user.user.uid;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Stream<User> get AuthStateChanged {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<String> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user = await _firebaseAuth.signInWithCredential(credential);
      print("Signed in ${user.user.uid}");
      return user.user.uid;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  @override
  Future<String> syncWithGoogle() async {
    final anonymousUser = await _firebaseAuth.currentUser();
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final user = await anonymousUser.linkWithCredential(credential);
    return user?.uid;
  }

  @override
  Future<User> currentUser() {
    return _firebaseAuth.currentUser();
  }
}
