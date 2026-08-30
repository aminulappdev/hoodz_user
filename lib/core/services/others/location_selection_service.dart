import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationAddress {
  const LocationAddress({
    required this.label,
    required this.addressLine,
    required this.latitude,
    required this.longitude,
    this.country = 'Bangladesh',
  });

  final String label;
  final String addressLine;
  final double latitude;
  final double longitude;
  final String country;

  String get fullAddress => '$label, $addressLine';
}

class LocationSelectionService {
  static const LocationAddress fallbackLocation = LocationAddress(
    label: 'AQUA Tower',
    addressLine: '43 Mohakhali C/A, Dhaka 1212',
    latitude: 23.777176,
    longitude: 90.399452,
  );

  Future<LocationAddress> getCurrentLocation() async {
    await _ensurePermission();
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return getAddressFromCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<Position> getCurrentPosition() async {
    await _ensurePermission();
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<LocationAddress> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final label = _firstNonEmpty([
          place.name,
          place.street,
          place.subLocality,
          place.locality,
        ]);
        final addressLine = _joinAddress([
          place.street,
          place.subLocality,
          place.locality,
          place.postalCode,
        ]);

        return LocationAddress(
          label: label.isEmpty ? 'Selected Location' : label,
          addressLine: addressLine.isEmpty
              ? '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}'
              : addressLine,
          latitude: latitude,
          longitude: longitude,
          country: place.country?.trim().isNotEmpty == true
              ? place.country!.trim()
              : 'Bangladesh',
        );
      }
    } catch (_) {
      // Fallback below.
    }

    return LocationAddress(
      label: 'Selected Location',
      addressLine:
          '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
      latitude: latitude,
      longitude: longitude,
    );
  }

  Future<void> _ensurePermission() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      throw const LocationServiceException(
        'Location service is turned off. Please enable GPS and try again.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationServiceException(
        'Location permission was denied.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Location permission is permanently denied. Enable it from settings.',
      );
    }
  }

  String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return '';
  }

  String _joinAddress(List<String?> values) {
    final parts = values
        .map((value) => value?.trim() ?? '')
        .where((value) => value.isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

class LocationServiceException implements Exception {
  const LocationServiceException(this.message);

  final String message;

  @override
  String toString() => message;
}
