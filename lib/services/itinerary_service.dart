import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_planner/apikey.dart'; // Ensure you have your API key here

class ItineraryService {
  Future<String> generateItinerary(String destination, String startDate, String endDate, double budget, List<String> interests) async {
    String travelPrompt = 'Generate a travel itinerary for a trip to $destination from $startDate to $endDate. The traveler has a budget of ₹$budget and is interested in ${interests.join(", ")}.';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {
              'text': travelPrompt,
            },
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.9,
        'maxOutputTokens': 16000,
      },
    };

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=${ApiKeys.apiKey}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('Failed to generate itinerary');
    }
  }
} 