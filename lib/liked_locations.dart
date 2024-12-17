// lib/liked_locations.dart

class LikedLocations {
  // A static list to store liked locations globally
  static final List<Map<String, dynamic>> _likedLocations = [];

  // Method to add a location to the liked list
  static void addLocation(Map<String, dynamic> location) {
    if (!_likedLocations.contains(location)) {
      _likedLocations.add(location);
    }
  }

  // Method to remove a location from the liked list
  static void removeLocation(Map<String, dynamic> location) {
    _likedLocations.remove(location);
  }

  // Method to get the liked locations
  static List<Map<String, dynamic>> getLikedLocations() {
    return _likedLocations;
  }

  // Method to check if a location is liked
  static bool isLiked(Map<String, dynamic> location) {
    return _likedLocations.contains(location);
  }
}
