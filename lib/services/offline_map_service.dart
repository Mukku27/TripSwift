import 'dart:io';
import 'package:flutter_map/flutter_map.dart';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class OfflineMapService {
  // Base URL for the map tiles
  final String tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

  // Directory to store offline map tiles
  late Directory _offlineMapDir;

  OfflineMapService() {
    _initialize();
  }

  // Initialize the directory for offline maps
  Future<void> _initialize() async {
    _offlineMapDir = await getApplicationDocumentsDirectory();
    final offlineDir = Directory('${_offlineMapDir.path}/offline_maps');
    if (!await offlineDir.exists()) {
      await offlineDir.create();
    }
  }

  // Download a map tile and save it to the offline directory
  Future<void> downloadTile(int zoom, int x, int y) async {
    final tilePath = '${_offlineMapDir.path}/offline_maps/$zoom/$x/$y.png';
    final tileDir = Directory('${_offlineMapDir.path}/offline_maps/$zoom/$x');

    if (!await tileDir.exists()) {
      await tileDir.create(recursive: true);
    }

    // Check if the tile already exists
    if (await File(tilePath).exists()) {
      print('Tile already exists: $tilePath');
      return;
    }

    // Download the tile
    final url = tileUrl.replaceAll('{z}', zoom.toString()).replaceAll('{x}', x.toString()).replaceAll('{y}', y.toString());
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      await File(tilePath).writeAsBytes(response.bodyBytes);
      print('Downloaded tile: $tilePath');
    } else {
      print('Failed to download tile: $url');
    }
  }

  // Load offline map tiles
  TileProvider getOfflineTileProvider() {
    return CachedNetworkTileProvider(
      tileUrlTemplate: tileUrl,
      // Use the local file path for offline tiles
      getTile: (zoom, x, y) async {
        final tilePath = '${_offlineMapDir.path}/offline_maps/$zoom/$x/$y.png';
        if (await File(tilePath).exists()) {
          return File(tilePath).readAsBytesSync();
        }
        return null; // Return null if the tile does not exist
      },
    );
  }
} 