import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_planner/services/collaborative_planning_service.dart';

class CollaborativePlanningPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final planningService = Provider.of<CollaborativePlanningService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Collaborative Planning')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Add Interest'),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  planningService.addInterest(value);
                }
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: planningService.groupInterests.length,
                itemBuilder: (context, index) {
                  final interest = planningService.groupInterests[index];
                  return ListTile(
                    title: Text(interest),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        planningService.removeInterest(interest);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 