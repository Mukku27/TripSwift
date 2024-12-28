import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'components/location_detailed_view.dart';
import 'components/popular_destination_tile.dart';

class PopularDestinationsScreen extends StatelessWidget {
  const PopularDestinationsScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Popular Destinations",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
              padding: const EdgeInsets.all(8.0),
              itemCount: highlights.length,
              itemBuilder: (context, index) {
                final highlight = highlights[index];
                // Handle the rating field gracefully (if reviews exist)
                final rating = (highlight['reviews'] != null && highlight['reviews'].isNotEmpty)
                    ? highlight['reviews'][0]['rating']
                    : 0.0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DestinationTile(
                    width: 180,
                    imageUrl: highlight['image'],
                    title: highlight['name'],
                    description: highlight['description'],
                    price: highlight['price'],
                    rating: rating,
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
