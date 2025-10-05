import "dart:core";

import "package:flutter_globoscript/data/interfaces/location_datastore.dart";
import "package:flutter_globoscript/models/user-location.dart";

class InMemoryLocationDataStore implements LocationDataStore {
  final List<UserLocation> _locations = [];

  @override
  void addUserLocation(UserLocation location) {
    _locations.add(location);
  }

  @override
  void updateUserLocation(UserLocation location) {
    final index = _locations.indexWhere(
      (loc) => loc.username == location.username,
    );

    if (index != -1) {
      _locations[index] = location;
    }
  }

  @override
  void deleteUserLocation(UserLocation location) {
    _locations.removeWhere((loc) => loc.username == location.username);
  }

  @override
  Future<UserLocation> getUserLocation(String username) async {
    return _locations.firstWhere((location) => location.username == username);
  }

  @override
  Future<List<UserLocation>> getUserLocations() async {
    return List.from(_locations);
  }
}
