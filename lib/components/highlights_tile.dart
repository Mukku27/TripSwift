import 'package:flutter/material.dart';

class HighLightTile extends StatelessWidget {
  final double width;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  // final String openingTime;
  // final String closingTime;
  final VoidCallback onTap;

  const HighLightTile({
    Key? key,
    required this.width,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    // required this.openingTime,
    // required this.closingTime,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 16.0),
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.grey[850],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Display image from network with loading spinner
                  Image.network(
                    imageUrl,
                    height: 120,
                    width: width,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image has loaded
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 4.0),
                  // Text(
                  //   "Opening: $openingTime",
                  //   style: TextStyle(color: Colors.grey[500]),
                  // ),
                  // Text(
                  //   "Closing: $closingTime",
                  //   style: TextStyle(color: Colors.grey[500]),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
