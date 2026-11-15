import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {

  final Geocoding _geocoding = Geocoding();

  Future<Position> getPosition() async {
    // Conserva aquí tu código actual para obtener permisos y ubicación.
    return Geolocator.getCurrentPosition();
  }

  Future<String> getAddress() async {
    final position = await getPosition();

    final places = await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (places.isEmpty) {
      return 'Dirección no encontrada';
    }

    final place = places.first;

    return '${place.street}, ${place.locality}, ${place.country}';
  }
}