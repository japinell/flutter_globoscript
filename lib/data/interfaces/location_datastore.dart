import "package:flutter_globoscript/models/user-location.dart";

abstract class LocationDataStore {
  void addUserLocation(UserLocation location);
  void updateUserLocation(UserLocation location);
  void deleteUserLocation(UserLocation location);

  Future<UserLocation> getUserLocation(String username);
  Future<List<UserLocation>> getUserLocations();
}
