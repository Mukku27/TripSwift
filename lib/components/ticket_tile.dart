import 'package:flutter/material.dart';

class TicketTile extends StatelessWidget {
  final String startDate;
  final String startTime;
  final String endDate;
  final String endTime;
  final String startLocation;
  final String endLocation;
  final String totalDuration;
  final String ticketType; // 'flight', 'train', 'bus'
  final String imagePath; // Path to flight, train, or bus image

  const TicketTile({
    Key? key,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.startLocation,
    required this.endLocation,
    required this.totalDuration,
    required this.ticketType,
    required this.imagePath,
  }) : super(key: key);

  Widget _buildTransportIcon() {
    // Choose the appropriate icon based on the ticket type
    switch (ticketType.toLowerCase()) {
      case 'flight':
        return Image.asset('assets/images/flight_icon.png', height: 24, width: 24);
      case 'train':
        return Image.asset('assets/images/train_icon.png', height: 24, width: 24);
      case 'bus':
        return Image.asset('assets/images/bus_icon.png', height: 24, width: 24);
      default:
        return const Icon(Icons.directions, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF10212A), // Dark background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Column: Start Date, Time, and Location
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                startDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                startTime,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                startLocation,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),

          // Middle Column: Transport Icon and Duration
          Column(
            children: [
              _buildTransportIcon(),
              const SizedBox(height: 8),
              Text(
                totalDuration,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                ticketType.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),

          // Right Column: End Date, Time, and Location
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                endDate,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                endTime,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                endLocation,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
