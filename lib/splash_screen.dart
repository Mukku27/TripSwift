import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trip_swift/main_screen.dart';
import 'intro_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => IntroScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (BuildContext context) => isLoggedIn ? MainScreen() : LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.blueAccent],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/splash_screen_logo.png',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // App Name
            const Text(
              'VOICE FOR HER',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),

            const SizedBox(height: 10),

            // Tagline
            const Text(
              'Because You Deserve Peace of Mind',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            // Animated Loading Indicator
            // const CircularProgressIndicator(
            //   color: Colors.white,
            //   strokeWidth: 3.0,
            // ),
          ],
        ),
      ),
    );
  }
}
