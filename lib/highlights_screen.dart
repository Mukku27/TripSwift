import 'package:flutter/material.dart';
import 'package:trip_swift/popular_destinations.dart';
import 'package:trip_swift/popular_destinations_data.dart';
import 'package:trip_swift/components/highlights_tile.dart';
import 'package:trip_swift/trip_hightlight_photos.dart';
import 'components/location_detailed_view.dart';
import 'highligts_data.dart';



void main() {
  runApp(MaterialApp(home: const HomeScreen(documentId: '')));
}

class HomeScreen extends StatelessWidget {
  final String documentId;
  const HomeScreen({required this.documentId, Key? key}) : super(key: key);


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
              // height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: destinations.length,
                itemBuilder: (context, index) {
                  final destination = destinations[index];
                  return HighLightTile(
                    // openingTime: destination['opening_time'],
                    // closingTime: destination['closing_time'],
                    width: 180,
                    imageUrl: destination["imageUrl"],
                    title: destination["title"],
                    subtitle: destination["description"],
                    price: "\$${destination["price"]}",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocationDetailScreen(
                            documentId: documentId,
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
              // height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final highlight = highlights[index];
                  return HighLightTile(
                    // openingTime: highlight['opening_time']??"",
                    // closingTime: highlight['closing_time']??"",
                    price: highlight['price']??"",
                    width: 180,
                    imageUrl: highlight["photoUrl"]??"",
                    title: highlight["location"]??"",
                    subtitle: "Visited by ${highlight["userId"]}",
                    // trailingText: highlight["date"]??"",
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
