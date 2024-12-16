import 'package:flutter/material.dart';
import 'package:trip_swift/popular_destinations.dart';
import 'components/location_detailed_view.dart';
import 'components/popular_destination_tile.dart';

void main(){
  runApp(MaterialApp(home: HomeScreen()));
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> destinations = [
      {
        "imageUrl": "https://example.com/image1.jpg",
        "title": "Tranquil Books & Coffee",
        "description": "Coffee Shop · Cosy",
        "price": "\$25",
        "rating": 4.5,
      },
      {
        "imageUrl": "https://example.com/image2.jpg",
        "title": "The Craft House Cathedral",
        "description": "Gift Shop · Souvenir",
        "price": "\$15",
        "rating": 4.8,
      },
      // Add more destinations
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Travel App", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Destinations",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PopularDestinationsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "See More",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
          ),
          // Destination Tiles
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return SizedBox(
                  width: 180,
                  child: DestinationTile(
                    imageUrl: destination["imageUrl"],
                    title: destination["title"],
                    description: destination["description"],
                    price: destination["price"],
                    rating: destination["rating"],
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
