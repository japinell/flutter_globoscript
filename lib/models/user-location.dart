class UserLocation {
  final String username;
  final double latitude;
  final double longitude;

  const UserLocation({
    required this.username,
    required this.latitude,
    required this.longitude,
  });

  String get getUsername {
    return username;
  }

  double get getLatitude {
    return latitude;
  }

  double get getLongitude {
    return longitude;
  }
}
