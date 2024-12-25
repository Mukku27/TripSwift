import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference complaints =
FirebaseFirestore.instance.collection("users");

// create: add a new complain
Future<void> addProfile(String uid,String fullname, String email) {
  return complaints.doc(uid).set({
    'email': email,
    'fullname': fullname,
    'timestamp': Timestamp.now(),
  });
}