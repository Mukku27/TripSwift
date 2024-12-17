import 'package:firebase_auth/firebase_auth.dart';

Future<UserCredential> signUP(
    String email, String password) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
}
