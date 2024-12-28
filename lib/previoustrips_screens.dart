import 'package:flutter/material.dart';
import 'package:trip_swift/trip_hightlight_photos.dart';

// HighlightTile widget as provided earlier
import 'components/highlights_tile.dart';


// Entry point for the app
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PreviousTripsScreen(),
    );
  }
}

class PreviousTripsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> trips = [
    {
      "tripID": "1",
      "imageUrl": "assets/images/intro_screen_mountain.png",
      "title": "Trip to Paris",
      "subtitle": "France",
      "trailingText": "4 days",
    },
    {
      "tripID": "2",
      "imageUrl": "assets/images/intro_screen_mountain.png",
      "title": "Beach Vacation",
      "subtitle": "Maldives",
      "trailingText": "6 days",
    },
    {
      "tripID": "3",
      "imageUrl": "assets/images/intro_screen_mountain.png",
      "title": "Mountain Trek",
      "subtitle": "Nepal",
      "trailingText": "8 days",
    },
    {
      "tripID": "4",
      "imageUrl": "assets/images/intro_screen_mountain.png",
      "title": "Safari Adventure",
      "subtitle": "Kenya",
      "trailingText": "5 days",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trips Overview"),
        backgroundColor: Colors.grey[850],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 tiles per row
            mainAxisSpacing: 12.0,
            crossAxisSpacing: 12.0,
            childAspectRatio: 0.8,
          ),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return HighLightTile(
              price: trip['price'],
              width: double.infinity,
              imageUrl: trip['imageUrl'],
              title: trip['title'],
              subtitle: trip['subtitle'],
              // openingTime: trip['opening_time'],
              // closingTime: trip['closing_time'],
              // trailingText: trip['trailingText'],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewEntireTripDetailsPage(tripID: trip['tripID']),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ViewEntireTripDetailsPage extends StatelessWidget {
  final String tripID;

  const ViewEntireTripDetailsPage({Key? key, required this.tripID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details ($tripID)"),
        backgroundColor: Colors.grey[850],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Details about the trip go here.",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HighlightsScreen(
                      locationName: "Beautiful Destination",
                      imageUrls: [
                        "assets/images/intro_screen_mountain.png",
                        "assets/images/intro_screen_mountain.png",
                        "assets/images/intro_screen_mountain.png",
                      ],
                      visitDate: DateTime.now(),
                    ),
                  ),
                );
              },
              child: const Text("View Photos"),
            ),
          ],
        ),
      ),
    );
  }
}
