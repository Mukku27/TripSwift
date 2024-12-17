import 'package:flutter/material.dart';
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
  final List<String>? _photos = [];
  final List<Map<String, dynamic>>? _reviews = [];

  bool _isLoadingPhotos = true;
  bool _isLoadingReviews = true;

  // Like functionality variables
  bool _isLiked = false;
  static final List<Map<String, dynamic>> _likedLocations = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _fetchPhotos().then((data) {
        setState(() {
          _photos!.addAll(data);
          _isLoadingPhotos = false;
        });
      }),
      _fetchReviews().then((data) {
        setState(() {
          _reviews!.addAll(data);
          _isLoadingReviews = false;
        });
      }),
    ]);
  }

  Future<List<String>> _fetchPhotos() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      "assets/images/intro_screen_mountain.png",
      "assets/images/intro_screen_mountain.png",
      "assets/images/intro_screen_mountain.png",
    ];
  }

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      {"name": "John Doe", "rating": 4.5, "comment": "Great place to relax!"},
      {"name": "Jane Smith", "rating": 5.0, "comment": "Amazing view and cozy vibe."},
    ];
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        // Add location details to the liked array
        _likedLocations.add({
          "imageUrl": widget.imageUrl,
          "location": widget.location,
          "title": widget.title,
          "rating": widget.rating,
          "description": widget.description,
          "openingHours": widget.openingHours,
          "type": widget.type,
          "price": widget.price,
        });
      } else {
        // Remove location details from the liked array
        _likedLocations.removeWhere((element) => element['title'] == widget.title);
      }

      print("Liked Locations: $_likedLocations"); // Debug log
    });
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildOverviewSection();
      case 1:
        return _isLoadingPhotos
            ? const Center(child: CircularProgressIndicator())
            : PhotoGrid(photoPaths: _photos!);
      case 2:
        return _isLoadingReviews
            ? const Center(child: CircularProgressIndicator())
            : _buildReviewSection(_reviews!);
      default:
        return const Center(
          child: Text(
            "Community Section (Coming Soon)",
            style: TextStyle(color: Colors.white),
          ),
        );
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
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(
                      _isLiked ? Icons.favorite : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                      size: 28,
                    ),
                    onPressed: _toggleLike,
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
