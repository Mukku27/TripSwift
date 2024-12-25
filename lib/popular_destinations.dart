import 'package:flutter/material.dart';
import 'components/location_detailed_view.dart';
import 'components/popular_destination_tile.dart';
import 'popular_destinations_data.dart';


class PopularDestinationsScreen extends StatelessWidget {
  const PopularDestinationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      // Add more destinations here

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
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
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
    );
  }
}
