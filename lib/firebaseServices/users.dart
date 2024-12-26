import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference complaints =
    FirebaseFirestore.instance.collection("users");

// create: add a new user
Future<void> addProfile(String uid, String fullname, String email) {
  return complaints.doc(uid).set({
    'email': email,
    'name': fullname,
    'timestamp': Timestamp.now(),
  });
}

// read: update  a user
Future<void> updateProfile(String uid, String name, String email, int age,
    String phone, String gender) {
  return complaints.doc(uid).update({
    'email': email,
    'fullname': name,
    'age': age,
    'phone': phone,
    'gender': gender,
    'timestamp': Timestamp.now(),
  });
}

// read: get a user
Future<DocumentSnapshot> getProfile(String uid) {
  return complaints.doc(uid).get();
}
