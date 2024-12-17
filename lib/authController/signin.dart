import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signIn(
    String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
}
