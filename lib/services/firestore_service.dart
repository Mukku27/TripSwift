import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTripData(String userId, Map<String, dynamic> tripData) async {
    await _db.collection('trips').doc(userId).set(tripData);
  }

  Future<Map<String, dynamic>?> getTripData(String userId) async {
    DocumentSnapshot doc = await _db.collection('trips').doc(userId).get();
    return doc.data() as Map<String, dynamic>?;
  }
} 