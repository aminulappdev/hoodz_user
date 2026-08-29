import 'dart:async';
import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:hoodz/core/services/socket/socket_service.dart';
import 'package:hoodz/core/utils/share_preference.dart';
import 'package:socket_io_client/socket_io_client.dart';

class UserOrderSocketService extends GetxService {
  UserOrderSocketService(this._socketService);

  final SocketService _socketService;

  final RxBool isListening = false.obs;
  final RxBool isTrackingActive = false.obs;
  final RxString activeOrderId = ''.obs;
  final RxString activeJobId = ''.obs;
  final RxString lastEventName = ''.obs;
  final RxMap<String, dynamic> lastEventPayload = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> locationUpdates =
      <Map<String, dynamic>>[].obs;
  final Rxn<UserOrderTrackingLocation> currentTrackingLocation =
      Rxn<UserOrderTrackingLocation>();

  bool _hasBoundSocketListeners = false;

  Future<void> ensureReady() async {
    if (!_socketService.isInitialized) {
      final accessToken = MySharedPref.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        return;
      }

      await _socketService.init();
    }

    _bindSocketListeners();
  }

  Future<Map<String, dynamic>?> startTracking({
    required String orderId,
  }) async {
    final resolvedOrderId = orderId.trim();
    if (resolvedOrderId.isEmpty) {
      return null;
    }

    if (isTrackingActive.value && activeOrderId.value == resolvedOrderId) {
      return null;
    }

    await ensureReady();
    if (!_socketService.isInitialized) {
      return null;
    }

    activeOrderId.value = resolvedOrderId;
    isTrackingActive.value = true;

    try {
      final response = await _socketService.socket.emitWithAckAsync(
        'track_order',
        {'orderId': resolvedOrderId},
      );
      final payload = _extractPayload(response);
      print('Start tracking order: $resolvedOrderId response => $payload');
      lastEventName.value = 'track_order';
      lastEventPayload.assignAll(payload);
      return payload;
    } catch (e) {
      print('Start tracking order: $resolvedOrderId ack error => $e');
      return null;
    }
  }

  void stopTracking() {
    isTrackingActive.value = false;
    activeOrderId.value = '';
    activeJobId.value = '';
    lastEventName.value = '';
    lastEventPayload.clear();
    locationUpdates.clear();
    currentTrackingLocation.value = null;
  }

  Future<void> submitRating({
    required String jobId,
    required int rating,
    String? review,
    List<String>? files,
  }) async {
    final resolvedJobId = jobId.trim();
    if (resolvedJobId.isEmpty) {
      return;
    }

    await ensureReady();
    if (!_socketService.isInitialized) {
      return;
    }

    _socketService.socket.emit('ride:submit-rating', {
      'jobId': resolvedJobId,
      'rating': rating,
      'review': review ?? '',
      'files': files ?? const <String>[],
    });
  }

  void _bindSocketListeners() {
    if (_hasBoundSocketListeners || !_socketService.isInitialized) {
      return;
    }

    _hasBoundSocketListeners = true;
    isListening.value = true;

    _socketService.socket.on('job:rider-assigned', _handleRiderAssigned);
    _socketService.socket.on('job:picked-up', _handlePickedUp);
    _socketService.socket.on('job:on-the-way', _handleOnTheWay);
    _socketService.socket.on('job:otp-sent', _handleOtpSent);
    _socketService.socket.on('job:otp-verified', _handleOtpVerified);
    _socketService.socket.on('job:delivered', _handleDelivered);
    _socketService.socket.on('ride:request-rating', _handleRatingRequest);
    _socketService.socket.on('order:location', _handleLocationUpdate);
    _socketService.socket.onConnect(_handleReconnect);
    _socketService.socket.onReconnect(_handleReconnect);
  }

  void _handleReconnect(dynamic _) {
    final orderId = activeOrderId.value.trim();
    if (isTrackingActive.value && orderId.isNotEmpty) {
      unawaited(
        startTracking(orderId: orderId),
      );
    }
  }

  void _handleRiderAssigned(dynamic data) {
    _handleTrackingEvent('job:rider-assigned', data);
  }

  void _handlePickedUp(dynamic data) {
    _handleTrackingEvent('job:picked-up', data);
  }

  void _handleOnTheWay(dynamic data) {
    _handleTrackingEvent('job:on-the-way', data);
  }

  void _handleOtpSent(dynamic data) {
    _handleTrackingEvent('job:otp-sent', data);
  }

  void _handleOtpVerified(dynamic data) {
    _handleTrackingEvent('job:otp-verified', data);
  }

  void _handleDelivered(dynamic data) {
    _handleTrackingEvent('job:delivered', data);
  }

  void _handleTrackingEvent(String eventName, dynamic data) {
    final payload = _extractPayload(data);
    lastEventName.value = eventName;
    lastEventPayload.assignAll(payload);

    final orderId = _firstNonEmptyString(
      payload,
      const ['orderId', 'order', 'id'],
    );
    if (orderId.isNotEmpty) {
      activeOrderId.value = orderId;
    }

    final jobId = _firstNonEmptyString(
      payload,
      const ['jobId', 'job', '_id'],
    );
    if (jobId.isNotEmpty) {
      activeJobId.value = jobId;
    }
  }

  void _handleRatingRequest(dynamic data) {
    final payload = _extractPayload(data);
    lastEventName.value = 'ride:request-rating';
    lastEventPayload.assignAll(payload);

    final jobId = _firstNonEmptyString(
      payload,
      const ['jobId', 'job', '_id'],
    );
    if (jobId.isNotEmpty) {
      activeJobId.value = jobId;
    }
  }

  void _handleLocationUpdate(dynamic data) {
    final payload = _extractPayload(data);
    lastEventName.value = 'order:location';
    lastEventPayload.assignAll(payload);
    locationUpdates.add(payload); 

    final lat = _toDouble(payload['lat']);
    final lng = _toDouble(payload['lng']);
    if (lat == null || lng == null) {
      return;
    }

    final encodedRoute = payload['encodedRoute']?.toString().trim() ?? '';
    final routePoints = encodedRoute.isNotEmpty
        ? _decodePolyline(encodedRoute)
        : <TrackingGeoPoint>[];

    currentTrackingLocation.value = UserOrderTrackingLocation(
      riderLocation: TrackingGeoPoint(lat: lat, lng: lng),
      speed: _toDouble(payload['speed']),
      heading: _toDouble(payload['heading']),
      encodedRoute: encodedRoute.isEmpty ? null : encodedRoute,
      routePoints: routePoints,
      destinationLocation: routePoints.isNotEmpty ? routePoints.last : null,
    );
  }

  Map<String, dynamic> _extractPayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      return Map<String, dynamic>.from(data);
    }

    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }

    return {'value': data};
  }

  String _firstNonEmptyString(
    Map<String, dynamic> payload,
    List<String> keys,
  ) {
    for (final key in keys) {
      final value = payload[key];
      final resolved = value?.toString().trim() ?? '';
      if (resolved.isNotEmpty) {
        return resolved;
      }
    }

    return '';
  }

  double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  List<TrackingGeoPoint> _decodePolyline(String encoded) {
    final points = <TrackingGeoPoint>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      result = 0;
      shift = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(
        TrackingGeoPoint(
          lat: lat / 1e5,
          lng: lng / 1e5,
        ),
      );
    }

    return points;
  }

  @override 
  void onClose() {
    if (_socketService.isInitialized) {
      _socketService.socket.off('job:rider-assigned', _handleRiderAssigned);
      _socketService.socket.off('job:picked-up', _handlePickedUp);
      _socketService.socket.off('job:on-the-way', _handleOnTheWay);
      _socketService.socket.off('job:otp-sent', _handleOtpSent);
      _socketService.socket.off('job:otp-verified', _handleOtpVerified);
      _socketService.socket.off('job:delivered', _handleDelivered);
      _socketService.socket.off('ride:request-rating', _handleRatingRequest);
      _socketService.socket.off('order:location', _handleLocationUpdate);
    }

    super.onClose();
  }
}

class UserOrderTrackingLocation {
  const UserOrderTrackingLocation({
    required this.riderLocation,
    required this.speed,
    required this.heading,
    required this.encodedRoute,
    required this.routePoints,
    required this.destinationLocation,
  });

  final TrackingGeoPoint riderLocation;
  final double? speed;
  final double? heading;
  final String? encodedRoute;
  final List<TrackingGeoPoint> routePoints;
  final TrackingGeoPoint? destinationLocation;
}

class TrackingGeoPoint {
  const TrackingGeoPoint({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;
}
