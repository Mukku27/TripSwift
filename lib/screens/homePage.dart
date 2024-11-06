import 'package:flutter/material.dart';
import 'package:travel_planner/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  User? _user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Planner'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              setState(() {
                _user = null;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: _user == null
            ? ElevatedButton(
                onPressed: () async {
                  User? user = await _authService.signInWithGoogle();
                  setState(() {
                    _user = user;
                  });
                },
                child: Text('Sign in with Google'),
              )
            : Text('Welcome, ${_user?.displayName}'),
      ),
    );
  }
}
