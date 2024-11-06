# TripSwift:The Ultimate AI-Powered Travel Companion

**Welcome to TripSwift!**
TripSwift is a smart travel app designed to help users make the most of their vacations, especially when time is limited. With real-time itinerary management, group planning, offline access, and in-depth cultural insights, TripSwift adapts to the needs of individuals and groups for seamless, immersive travel experiences. The app integrates features like Google OAuth for secure authentication, Firebase Firestore for data storage, and offline map capabilities to ensure a smooth journey, even without an internet connection. Collaborate with friends, customize your trips, and gain valuable insights about each destination with TripSwift.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Folder Structure](#folder-structure)
- [License](#license)

## Features

- **User Authentication**: Secure login using Google accounts.
- **Trip Customization**: Users can select options for trip location, duration, budget, and number of travelers.
- **Collaborative Planning**: Users can add and manage group interests for shared experiences.
- **Cultural Insights**: Fetch local event calendars and etiquette advice for enriching travel experiences.
- **AI-Generated Itineraries**: Integrate with Gemini AI to provide personalized travel itineraries.
- **Offline Maps**: Download maps of specific locations for offline use.
- **Real-Time Data Storage**: Utilize Firebase Firestore for efficient data storage and management.

## Technologies Used

- **Flutter**: The framework for building the application.
- **Firebase**: For authentication and Firestore database.
- **Provider**: State management solution for managing app state.
- **HTTP**: For making API calls to external services.
- **Flutter Form Builder**: For building forms with validation.
- **Flutter Map**: For displaying maps and offline map functionality.

## Installation

To get started with the Travel Planner project, follow these steps:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/travel_planner.git
   cd travel_planner
   ```

2. **Install dependencies**:
   Make sure you have Flutter installed on your machine. Then run:
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**:
   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add your app to the Firebase project and follow the instructions to configure it for Android and iOS.
   - Download the `google-services.json` for Android and `GoogleService-Info.plist` for iOS and place them in the appropriate directories.

4. **Run the app**:
   ```bash
   flutter run
   ```

## Usage

- **Authentication**: Users can sign in using their Google accounts.
- **Trip Customization**: Navigate to the trip customization page to enter trip details.
- **Collaborative Planning**: Add interests for group trips and manage them.
- **Cultural Insights**: View cultural insights for selected destinations.
- **Offline Maps**: Download and view maps for offline use.

## Folder Structure

```
lib/
├── main.dart                     # Entry point of the application
├── screens/                      # Contains all the screens of the app
│   ├── homePage.dart             # Home page of the app
│   ├── trip_customization.dart    # Trip customization page
│   ├── travelPage.dart           # Travel details page
│   ├── offline_map_page.dart     # Offline maps page
│   ├── collaborative_planning_page.dart # Collaborative planning page
│   └── cultural_insights_page.dart # Cultural insights page
├── services/                     # Contains services for API calls and data management
│   ├── auth_service.dart         # Google authentication service
│   ├── itinerary_service.dart     # Service for generating itineraries
│   ├── collaborative_planning_service.dart # Service for managing group interests
│   ├── cultural_insights_service.dart # Service for fetching cultural insights
│   └── firestore_service.dart     # Service for Firestore database interactions
├── models/                       # Contains data models (if any)
└── utils/                        # Utility functions (if any)
```


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Thank you for checking out the Travel Planner project! We hope you find it useful for your travel planning needs. Happy travels!