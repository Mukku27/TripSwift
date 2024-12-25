import 'package:flutter/material.dart';
import 'package:trip_swift/components/highlights_tile.dart';
import 'package:trip_swift/popular_destinations.dart';
import 'package:trip_swift/popular_destinations_data.dart';
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
                    trailingText: "\$ ${destination["price"]}",
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
                    trailingText: highlight["date"] ?? "",
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
