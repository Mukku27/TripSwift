import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_planner/services/offline_map_service.dart';

class OfflineMapPage extends StatefulWidget {
  @override
  _OfflineMapPageState createState() => _OfflineMapPageState();
}

class _OfflineMapPageState extends State<OfflineMapPage> {
  final OfflineMapService _offlineMapService = OfflineMapService();
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Offline Maps')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(51.5, -0.09), // Default center
                zoom: 13.0,
              ),
              layers: [
                TileLayerOptions(
                  tileProvider: _offlineMapService.getOfflineTileProvider(),
                  urlTemplate: _offlineMapService.tileUrl,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Example: Download a specific tile (zoom level 13, x: 4096, y: 8192)
              await _offlineMapService.downloadTile(13, 4096, 8192);
            },
            child: Text('Download Tile'),
          ),
        ],
      ),
    );
  }
} 