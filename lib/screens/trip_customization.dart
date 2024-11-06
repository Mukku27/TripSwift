import 'package:flutter/material.dart';

class TripCustomizationPage extends StatefulWidget {
  @override
  _TripCustomizationPageState createState() => _TripCustomizationPageState();
}

class _TripCustomizationPageState extends State<TripCustomizationPage> {
  String destination = '';
  int duration = 1; // in days
  double budget = 0.0;
  int travelers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customize Your Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Destination'),
              onChanged: (value) {
                setState(() {
                  destination = value;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Duration (days)'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  duration = int.tryParse(value) ?? 1;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Budget'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  budget = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Number of Travelers'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  travelers = int.tryParse(value) ?? 1;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Handle trip customization submission
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
} 