import 'dart:async';
import 'package:flutter/material.dart';

class HighlightsScreen extends StatefulWidget {
  final String locationName;
  final List<String> imageUrls;
  final DateTime visitDate;

  const HighlightsScreen({
    Key? key,
    required this.locationName,
    required this.imageUrls,
    required this.visitDate,
  }) : super(key: key);

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel(); // Reset the timer if already active
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_currentIndex < widget.imageUrls.length - 1) {
        _moveToNextPage();
      } else {
        // On last image, return to HomeScreen
        _timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  void _moveToNextPage() {
    if (_currentIndex < widget.imageUrls.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    }
  }

  void _moveToPreviousPage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PageView for Stories
          PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(), // Disable swiping
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          // Progress Indicator at the top
          SafeArea(
            child: Column(
              children: [
                // Linear Progress Indicators
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: List.generate(widget.imageUrls.length, (index) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: LinearProgressIndicator(
                            value: _currentIndex > index
                                ? 1 // Fully filled for completed pages
                                : (_currentIndex == index
                                ? (_timer?.tick ?? 0) / 7
                                : 0), // Progress for current page
                            backgroundColor: Colors.grey[700],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 8.0), // Small spacing

                // Location Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location Name and Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.locationName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "${widget.visitDate.toLocal()}".split(' ')[0], // Format Date
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Close Button (Top-Right)
          Positioned(
            top: 12,
            right: 12,
            child: SafeArea(
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
          ),

          // Tap Zones to Move Forward/Backward
          Stack(
            children: [
              // Close Button at the Top-Right
              Positioned(
                top: 12,
                right: 12,
                child: SafeArea(
                  child: IgnorePointer(
                    // Ignore GestureDetector taps here
                    ignoring: false,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),

              // GestureDetector for Navigation (Excluding Close Button)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60.0), // Exclude top area with close button
                  child: GestureDetector(
                    onTapUp: (details) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      if (details.localPosition.dx < screenWidth / 3) {
                        // Move to Previous
                        _moveToPreviousPage();
                      } else {
                        // Move to Next
                        _moveToNextPage();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
