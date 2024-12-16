import 'package:flutter/material.dart';
import 'dart:async';

import 'package:trip_swift/components/photo_grid.dart';
import 'package:trip_swift/components/review_input.dart';

class LocationDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String location;
  final String title;
  final double rating;
  final String description;
  final String openingHours;
  final String type;
  final String price;

  const LocationDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.location,
    required this.title,
    required this.rating,
    required this.description,
    required this.openingHours,
    required this.type,
    required this.price,
  }) : super(key: key);

  @override
  _LocationDetailScreenState createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  int _currentIndex = 0;

  final List<String> _tabs = ["Overview", "Photo", "Review", "Community"];

  // Simulated Streams for Dynamic Data
  final Stream<List<String>> _photoStream = _fetchPhotos();
  final Stream<List<Map<String, dynamic>>> _reviewStream = _fetchReviews();

  static Stream<List<String>> _fetchPhotos() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield [
      "https://example.com/photo1.jpg",
      "https://example.com/photo2.jpg",
      "https://example.com/photo3.jpg",
      "https://example.com/photo4.jpg",
    ];
  }

  static Stream<List<Map<String, dynamic>>> _fetchReviews() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield [
      {"name": "John Doe", "rating": 4.5, "comment": "Great place to relax!"},
      {"name": "Jane Smith", "rating": 5.0, "comment": "Amazing view and cozy vibe."},
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildOverviewSection();
      case 1:
        return StreamBuilder<List<String>>(
          stream: _photoStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return PhotoGrid(photoPaths: snapshot.data!);
            }
            return const Center(child: Text("No photos available", style: TextStyle(color: Colors.white)));
          },
        );
      case 2:
        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: _reviewStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return _buildReviewSection(snapshot.data!);
            }
            return const Center(child: Text("No reviews available", style: TextStyle(color: Colors.white)));
          },
        );
      default:
        return const Center(child: Text("Community Section (Coming Soon)", style: TextStyle(color: Colors.white)));
    }
  }

  Widget _buildOverviewSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Opening hours", widget.openingHours, Colors.greenAccent),
          _buildInfoRow("Type", widget.type, Colors.blueAccent),
          _buildInfoRow("Good for", "Coffee, Snack food, Take away", Colors.amber),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(List<Map<String, dynamic>> reviews) {
    return Column(
      children: [
        ReviewInputBox(),
        Expanded(
          child: ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ListTile(
                title: Text(review['name'], style: const TextStyle(color: Colors.white)),
                subtitle: Text(review['comment'], style: TextStyle(color: Colors.grey[400])),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(review['rating'].toString(), style: const TextStyle(color: Colors.white)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section: Image and Details
            Stack(
              children: [
                Image.network(
                  widget.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.location,
                        style: TextStyle(color: Colors.grey[300], fontSize: 14),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.rating.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Tab Bar
            Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabs.length, (index) {
                  return GestureDetector(
                    onTap: () => _changeTab(index),
                    child: Column(
                      children: [
                        Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _currentIndex == index ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_currentIndex == index)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            height: 2,
                            width: 40,
                            color: Colors.amber,
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }
}
