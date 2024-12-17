import 'package:flutter/material.dart';
import 'package:trip_swift/home_page.dart';
import 'package:trip_swift/suggest_trips.dart';
import 'package:trip_swift/testing_features/maps_osm.dart';

import 'chat_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _selectedStatus = "Free"; // Default status

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Update status
  void _updateStatus(String? value) {
    setState(() {
      _selectedStatus = value ?? "Free"; // Update the status if it's changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF131617),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
        actions: [Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "John Doe", // Placeholder for the username
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Color(0xFF22DD85)),
                SizedBox(width: 5),
                Text(
                  "New York, USA", // Placeholder for the location
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(width: 10),
                Text(
                  "22°C", // Placeholder for the temperature
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),],
        title: Text('Trip Swift',
        style: TextStyle(color: Color(0xFF22DD85),),),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          SuggestTripScreen(),
          ChatScreen(),
          MapPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF131617),
        selectedItemColor: const Color(0xFF22DD85),
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Plan Trip",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Maps",
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF131617),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Profile Section
            ListTile(
              leading: const CircleAvatar(
                radius: 40, // Increased size for profile photo
                backgroundColor: Color(0xFF22DD85),
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              title: const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "John Doe", // Placeholder for username
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              onTap: () {
                // Navigate to Profile Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileScreen()),
                );
              },
            ),
            const Divider(color: Colors.white),

            // Set Status Dropdown (with styled dropdown)
            ListTile(
              leading: const Icon(Icons.account_circle, color: Color(0xFF22DD85)),
              title: DropdownButton<String>(
                isExpanded: true,
                value: _selectedStatus, // Current status value
                items: const [
                  DropdownMenuItem(
                    child: Text("Free", style: TextStyle(color: Colors.white)),
                    value: "Free",
                  ),
                  DropdownMenuItem(
                    child: Text("Busy", style: TextStyle(color: Colors.white)),
                    value: "Busy",
                  ),
                  DropdownMenuItem(
                    child: Text("At Work", style: TextStyle(color: Colors.white)),
                    value: "At Work",
                  ),
                ],
                onChanged: _updateStatus, // Call the update function
                hint: const Text(
                  "Select Status",
                  style: TextStyle(color: Colors.white70),
                ),
                dropdownColor: const Color(0xFF131617), // Dark background for dropdown
                style: const TextStyle(color: Colors.white), // White text for dropdown
              ),
            ),
            const Divider(color: Colors.white),

            // Upcoming Schedule
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF22DD85)),
              title: const Text(
                "Upcoming Schedule",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Upcoming Schedule Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpcomingScheduleScreen()),
                );
              },
            ),
            const Divider(color: Colors.white),

            // Previous Trips
            ListTile(
              leading: const Icon(Icons.trip_origin, color: Color(0xFF22DD85)),
              title: const Text(
                "Previous Trips",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Previous Trips Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PreviousTripsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Screen (Placeholder)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("Profile Screen")),
    );
  }
}

// Upcoming Schedule Screen (Placeholder)
class UpcomingScheduleScreen extends StatelessWidget {
  const UpcomingScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upcoming Schedule")),
      body: const Center(child: Text("Upcoming Schedule Screen")),
    );
  }
}

// Previous Trips Screen (Placeholder)
class PreviousTripsScreen extends StatelessWidget {
  const PreviousTripsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Previous Trips")),
      body: const Center(child: Text("Previous Trips Screen")),
    );
  }
}
