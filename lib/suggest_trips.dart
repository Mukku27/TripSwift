import 'package:flutter/material.dart';

import 'components/location_detailed_view.dart';


class SuggestTripScreen extends StatefulWidget {
  @override
  _SuggestTripScreenState createState() => _SuggestTripScreenState();
}

class _SuggestTripScreenState extends State<SuggestTripScreen> {
  // Sample list of suggested locations
  final List<Map<String, dynamic>> suggestedLocations = [
    {
      "imageUrl": "assets/images/intro_screen_mountain.png", // Placeholder image
      "location": "Paris, France",
      "title": "Eiffel Tower",
      "rating": 4.9,
      "description": "The Eiffel Tower is a wrought-iron lattice tower on the Champ de Mars in Paris, France.",
      "openingHours": "9:00 AM - 11:00 PM",
      "type": "Monument",
      "price": "\$50"
    },
    {
      "imageUrl": "assets/images/intro_screen_mountain.png", // Placeholder image
      "location": "Rome, Italy",
      "title": "Colosseum",
      "rating": 4.8,
      "description": "The Colosseum is an ancient amphitheater located in the center of Rome, Italy.",
      "openingHours": "8:30 AM - 7:00 PM",
      "type": "Historical Site",
      "price": "\$40"
    },
    {
      "imageUrl": "assets/images/intro_screen_mountain.png", // Placeholder image
      "location": "New York, USA",
      "title": "Statue of Liberty",
      "rating": 4.7,
      "description": "The Statue of Liberty is a colossal neoclassical sculpture on Liberty Island in New York Harbor.",
      "openingHours": "8:30 AM - 6:00 PM",
      "type": "Monument",
      "price": "\$30"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text("Suggested Trips"),
      //   backgroundColor: Colors.black,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search),
      //       onPressed: () {
      //         // Implement search functionality if needed
      //       },
      //     ),
      //   ],
      // ),
      body: PageView.builder(
        itemCount: suggestedLocations.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final location = suggestedLocations[index];
          return GestureDetector(
            onTap: () {
              // On tap, navigate to the LocationDetailScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationDetailScreen(
                    documentId: '',
                  ),
                ),
              );
            },
            child: Stack(
              children: [
                Image.asset(
                  location["imageUrl"],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        location["location"],
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            location["rating"].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
