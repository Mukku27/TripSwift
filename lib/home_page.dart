import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trip_swift/components/highlights_tile.dart';
import 'package:trip_swift/popular_destinations.dart';
// import 'package:trip_swift/popular_destinations_data.dart';
import 'package:trip_swift/trip_hightlight_photos.dart';
import 'components/location_detailed_view.dart';
import 'components/ticket_tile.dart'; // Import the TicketTile widget
import 'highligts_data.dart';
import 'tickets_data.dart'; // Ticket data source

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  Future<List<Map<String, dynamic>>> fetchHighlights() async {
    try {
      // Fetch data from Firestore (assuming the collection is named 'highlights')
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(
          'locations').get();

      // Map the data into a list of maps
      List<Map<String, dynamic>> highlights = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'image': doc['image'],
          'name': doc['name'],
          'description': doc['description'],
          'opening_time': doc['opening_time'],
          'closing_time': doc['closing_time'],
          'price': doc['price'],
        };
      }).toList();

      return highlights;
    } catch (e) {
      throw Exception('Failed to load highlights: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
              isButtonRequired: true,
            ),
            // Removed SizedBox and used ListView directly here
            Container(
              height: 230,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchHighlights(), // Fetch data from Firebase
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No highlights found.'));
                  } else {
                    final highlights = snapshot.data!;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final highlight = highlights[index];
                        return HighLightTile(
                          width: 180,
                          imageUrl: highlight['image'],
                          title: highlight['name'],
                          subtitle: highlight['description'],
                          price: highlight['price'],
                          // openingTime: highlight['opening_time'],
                          // closingTime: highlight['closing_time'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationDetailScreen(
                                  documentId: highlight["id"],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
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
              isButtonRequired: true,
            ),
            // Removed SizedBox and used ListView directly here
            Container(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  final highlight = highlights[index];
                  return HighLightTile(
                    width: 180,
                    imageUrl: highlight["photoUrl"] ?? "",
                    title: highlight["location"] ?? "",
                    subtitle: "Visited by ${highlight["userId"]}",
                    // trailingText: highlight["date"] ?? "",
                    price: highlight['price']??"",
                    // openingTime: highlight['opening_time']??"",
                    // closingTime: highlight['closing_time']??"",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HighlightsScreen(
                            locationName: "Eiffel Tower",
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

            // View Tickets Section
            _buildSectionHeader(
              context,
              title: "Your Tickets",
              onSeeMoreTap: () {
                // Navigate to a detailed tickets screen if required
              },
              isButtonRequired: false,
            ),
            // Used ListView to display tickets vertically
            ListView.builder(
              shrinkWrap: true,  // Important: makes it take only the space required by the items
              physics: NeverScrollableScrollPhysics(),  // Prevents scrolling here, handled by SingleChildScrollView
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return TicketTile(
                  startDate: ticket["startDate"] ?? "",
                  startTime: ticket["startTime"] ?? "",
                  endDate: ticket["endDate"] ?? "",
                  endTime: ticket["endTime"] ?? "",
                  startLocation: ticket["startLocation"] ?? "",
                  endLocation: ticket["endLocation"] ?? "",
                  totalDuration: ticket["totalDuration"] ?? "",
                  ticketType: ticket["ticketType"] ?? "",
                  imagePath: ticket["imagePath"] ?? "",
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title, required VoidCallback onSeeMoreTap, required bool isButtonRequired}) {
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
          isButtonRequired
              ? TextButton(
            onPressed: onSeeMoreTap,
            child: const Text(
              "See More",
              style: TextStyle(color: Colors.blueAccent),
            ),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
