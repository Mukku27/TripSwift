import 'package:flutter/material.dart';

class ReviewInputBox extends StatelessWidget {
  const ReviewInputBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Add your review...",
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: Colors.grey[400]),
            ),
            style: TextStyle(color: Colors.white),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Submit Review"),
          ),
        ],
      ),
    );
  }
}
