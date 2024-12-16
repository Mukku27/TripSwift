import 'package:flutter/material.dart';

class PhotoGrid extends StatelessWidget {
  final List<String> photoPaths;

  const PhotoGrid({Key? key, required this.photoPaths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photoPaths.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(photoPaths[index], fit: BoxFit.cover),
        );
      },
    );
  }
}
