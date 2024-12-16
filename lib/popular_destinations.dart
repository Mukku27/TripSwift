import 'package:flutter/material.dart';
import 'components/location_detailed_view.dart';
import 'components/popular_destination_tile.dart';


class PopularDestinationsScreen extends StatelessWidget {
  const PopularDestinationsScreen({Key? key}) : super(key: key);

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
      // Add more destinations here
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Popular Destinations", style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return DestinationTile(
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
          );
        },
      ),
    );
  }
}
