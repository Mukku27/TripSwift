import 'package:flutter/material.dart';
import 'package:trip_swift/popular_destinations.dart';
import 'package:trip_swift/popular_destinations_data.dart';
import 'package:trip_swift/components/highlights_tile.dart';
import 'package:trip_swift/trip_hightlight_photos.dart';
import 'components/location_detailed_view.dart';
import 'highligts_data.dart';



void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Travel App", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Popular Destinations Section
            _buildSectionHeader(
              context,
              title: "Popular Destinations",
              onSeeMoreTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PopularDestinationsScreen()),
                );
              },
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return HighLightTile(
                    width: 180,
                    imageUrl: destination["imageUrl"],
                    title: destination["title"],
                    subtitle: destination["description"],
                    trailingText: "\$${destination["price"]}",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationDetailScreen(
                            title: destination["title"],
                            imageUrl: destination["imageUrl"],
                            description: destination["description"],
                            price: destination["price"],
                            rating: destination["rating"],
                            location: destination["location"],
                            openingHours: destination["openingHours"],
                            type: destination["type"],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Highlights Section
            _buildSectionHeader(
              context,
              title: "Highlights",
              onSeeMoreTap: () {
                // Action for See More in Highlights

              },
            ),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  final highlight = highlights[index];
                  return HighLightTile(
                    width: 180,
                    imageUrl: highlight["photoUrl"]??"",
                    title: highlight["location"]??"",
                    subtitle: "Visited by ${highlight["userId"]}",
                    trailingText: highlight["date"]??"",
                    onTap: () {
                      // Action for tile tap (e.g., detailed view of highlight)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HighlightsScreen(
                            locationName: highlight["location"]??"",
                            imageUrls: highlightImages,
                            visitDate: DateTime.now(),
                          ),
                        ),
                      );

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onSeeMoreTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: onSeeMoreTap,
            child: const Text(
              "See More",
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
