import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    final enabled =
    await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      throw Exception(
        'Location services are disabled.',
      );
    }

    LocationPermission permission =
    await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
      await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception(
        'Location permission was denied.',
      );
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception(
        'Location permission was permanently denied. '
            'Please enable location permission in Settings.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
      ),
    );
  }
}