import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  // Ubicación por defecto en caso de que falle el GPS en el navegador
  static const LatLng defaultLocation = LatLng(22.1565, -100.9855);

  static Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return defaultLocation;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return defaultLocation;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return defaultLocation;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5),
      );
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return defaultLocation;
    }
  }
}