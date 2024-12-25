import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';  // For LatLng
import 'package:permission_handler/permission_handler.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  setPathUrlStrategy(); // For handling clean URLs
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_map Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF8dea88),
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    // Check and request location permissions
    if (await Permission.location.request().isGranted) {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(

      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Handle permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission is required to access your location.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(
        child: CircularProgressIndicator(), // Show loading until location is fetched
      )
          : FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation!, // Center the map on the user's location
          initialZoom: 15.0,
          maxZoom: 18.0,
          minZoom: 3.0,
        ),
        children: [
          // Tile Layer for OSM
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          // Marker Layer for user's location
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLocation!,
                child: const Icon(
                  Icons.location_pin,
                  size: 40.0,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}