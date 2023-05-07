import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static Future<void> signOut() async {
    // sign out
    await FirebaseAuth.instance.signOut();
  }
}
