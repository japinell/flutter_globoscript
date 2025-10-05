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
    return;
  }

  @override
  void deleteUserLocation(UserLocation location) {
    return;
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
