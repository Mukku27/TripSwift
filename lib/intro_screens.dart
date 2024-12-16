import 'package:flutter/material.dart';
import 'package:trip_swift/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const IntroScreen(),
    );
  }
}

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _introData = [
    {
      "title": "Discover Amazing Place",
      "image": "assets/images/intro_screen_mountain.png",
      "description":
      "Plan Your Trip, choose your destination. Pick the best local guide for your holiday."
    },
    {
      "title": "Find Best Routes",
      "image": "assets/images/intro_screen_mountain.png",
      "description":
      "Get the best routes and easy navigation wherever you go around the world."
    },
    {
      "title": "Enjoy Your Trip",
      "image": "assets/images/intro_screen_mountain.png",
      "description":
      "Make memories while exploring beautiful places with easy and helpful recommendations."
    },
  ];

  // Function to go to next page with animation
  void _goToNextPage() {
    if (_currentIndex < _introData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to login screen when on last page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _introData.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return Stack(
            children: [
              // Background image covering the entire screen
              Positioned.fill(
                child: Image.asset(
                  _introData[index]['image']!,
                  fit: BoxFit.cover,
                ),
              ),
              // Content on top of the background image
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: const BoxDecoration(
                      color: Color(0x15F1F1F5), // Grey background
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        Text(
                          _introData[index]['title']!,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        // Description box
                        Text(
                          _introData[index]['description']!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        // Dot indicators
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_introData.length, (dotIndex) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              height: 8,
                              width: _currentIndex == dotIndex ? 12 : 8,
                              decoration: BoxDecoration(
                                color: _currentIndex == dotIndex
                                    ? Colors.white
                                    : Colors.white38,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        // Next Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: _goToNextPage,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Next",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                const Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Skip button at the top-right
              Positioned(
                top: 50,
                right: 20,
                child: TextButton(
                  onPressed: () {
                    // Skip button logic to go directly to the Login screen
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
