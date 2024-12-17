import 'package:flutter/material.dart';

class ErrorPopup {
  static void showError(BuildContext context, String typefail, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              const Color.fromARGB(255, 211, 210, 210), // Dark background
          title: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 30),
              const SizedBox(width: 20),
              Text(
                "$typefail Faliled",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(
                color: Color.fromARGB(179, 4, 4, 4),
                fontWeight: FontWeight.w500),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(240, 39, 39, 39),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 4, 4, 4),
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
