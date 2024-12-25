import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setBool('isLoggedIn', true); // Save user ID to SharedPreferences
}

Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId'); // Retrieve user ID from SharedPreferences
}