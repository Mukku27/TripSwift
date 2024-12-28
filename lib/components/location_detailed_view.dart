import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trip_swift/components/photo_grid.dart';
import 'package:trip_swift/components/review_input.dart';

class LocationDetailScreen extends StatefulWidget {
  final String documentId; // Pass the document ID to fetch data

  const LocationDetailScreen({
    Key? key,
    required this.documentId, // Document ID passed to fetch location data
  }) : super(key: key);

  @override
  _LocationDetailScreenState createState() => _LocationDetailScreenState();
}

class _LocationDetailScreenState extends State<LocationDetailScreen> {
  int _currentIndex = 0;

  final List<String> _tabs = ["Overview", "Photo", "Review", "Community"];
  List<String> _photos = []; // List to hold photo URLs
  List<Map<String, dynamic>> _reviews = []; // List to hold reviews

  bool _isLoading = true; // State to manage loading indicator

  late Map<String, dynamic> _locationData; // Holds location data

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _loadLocationData(); // Load location data when the screen is initialized
  }

  // Fetch location data from Firestore using the document ID
  Future<void> _loadLocationData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(widget.documentId) // Fetch the location using the document ID
          .get();

      if (snapshot.exists) {
        setState(() {
          _locationData = snapshot.data() as Map<String, dynamic>;
          _isLoading = false;
        });
        _fetchPhotos(); // Fetch photos after location data is loaded
        _fetchReviews(); // Fetch reviews after location data is loaded
      } else {
        // Handle error if document does not exist
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text("Location not found."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      print("Error fetching location data: $e");
    }
  }

  // Fetch photos from Firestore (assuming photos are stored as URLs or paths in the document)
  Future<void> _fetchPhotos() async {
    try {
      QuerySnapshot photoSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(widget.documentId)
          .collection('photos') // Assuming photos are in a subcollection 'photos'
          .get();

      List<String> photoUrls = photoSnapshot.docs
          .map((doc) => doc['url'] as String) // Assuming each photo document has a 'url' field
          .toList();

      setState(() {
        _photos = photoUrls;
      });
    } catch (e) {
      print("Error fetching photos: $e");
    }
  }

  // Fetch reviews from Firestore (assuming reviews are stored in a subcollection 'reviews')
  Future<void> _fetchReviews() async {
    try {
      QuerySnapshot reviewSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc(widget.documentId)
          .collection('reviews') // Assuming reviews are in a subcollection 'reviews'
          .get();

      List<Map<String, dynamic>> reviews = reviewSnapshot.docs
          .map((doc) {
        return {
          'name': doc['name'] ?? 'Anonymous', // Assuming reviews have 'name' and 'comment' fields
          'rating': doc['rating'] ?? 0.0,
          'comment': doc['comment'] ?? 'No comment',
        };
      })
          .toList();

      setState(() {
        _reviews = reviews;
      });
    } catch (e) {
      print("Error fetching reviews: $e");
    }
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  Widget _buildTabContent() {
    switch (_currentIndex) {
      case 0:
        return _buildOverviewSection();
      case 1:
        return _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PhotoGrid(photoPaths: _photos);
      case 2:
        return _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildReviewSection(_reviews);
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
            _locationData['description'] ?? 'No description available',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 16),
          _buildInfoRow("Opening hours", _locationData['opening_hours'] ?? 'N/A', Colors.greenAccent),
          _buildInfoRow("Type", _locationData['type'] ?? 'N/A', Colors.blueAccent),
          _buildInfoRow("Price", _locationData['price'] ?? 'N/A', Colors.amber),
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
                _isLoading
                    ? const SizedBox.shrink()
                    : Image.network(
                  _locationData['image'] ?? '',
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
