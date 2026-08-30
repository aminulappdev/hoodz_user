import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as lat;

const String _googleMapsApiKey = 'AIzaSyCTnKPaarHYePg0Z9EvUgCt5OWYYcUvVlw';

class LiveTrackingMapPanel extends StatefulWidget {
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool expand;
  final UserOrderTrackingLocation? trackingLocation;
  final lat.LatLng? fallbackDestination;

  const LiveTrackingMapPanel({
    super.key,
    this.height,
    this.borderRadius,
    this.expand = false,
    this.trackingLocation,
    this.fallbackDestination,
  });

  @override
  State<LiveTrackingMapPanel> createState() => _LiveTrackingMapPanelState();
}

class _LiveTrackingMapPanelState extends State<LiveTrackingMapPanel> {
  gmap.GoogleMapController? _mapController;
  Set<gmap.Marker> _markers = <gmap.Marker>{};
  Set<gmap.Polyline> _polylines = <gmap.Polyline>{};
  String? _routeSignature;
  int _routeRequestToken = 0;

  @override
  void initState() {
    super.initState();
    _syncMapState(forceCenter: true);
  }

  @override
  void didUpdateWidget(covariant LiveTrackingMapPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.trackingLocation != widget.trackingLocation ||
        oldWidget.fallbackDestination != widget.fallbackDestination) {
      _syncMapState();
    }
  }

  gmap.LatLng? _toGoogleLatLng(lat.LatLng? point) {
    if (point == null) {
      return null;
    }

    return gmap.LatLng(point.latitude, point.longitude);
  }

  gmap.LatLng? _riderPoint() {
    final trackingLocation = widget.trackingLocation;
    if (trackingLocation == null) {
      return null;
    }

    return gmap.LatLng(
      trackingLocation.riderLocation.lat,
      trackingLocation.riderLocation.lng,
    );
  }

  gmap.LatLng? _destinationPoint() {
    final trackingLocation = widget.trackingLocation;
    final fallbackDestination = _toGoogleLatLng(widget.fallbackDestination);

    if (trackingLocation != null) {
      final trackingDestination = trackingLocation.destinationLocation;
      final socketDestination = trackingDestination == null
          ? null
          : gmap.LatLng(trackingDestination.lat, trackingDestination.lng);

      return fallbackDestination ?? socketDestination;
    }

    return fallbackDestination;
  }

  List<gmap.LatLng> _cameraPoints() {
    final points = <gmap.LatLng>[];
    final rider = _riderPoint();
    final fallbackDestination = _toGoogleLatLng(widget.fallbackDestination);
    final socketDestination = widget.trackingLocation?.destinationLocation;
    final trackingDestination = socketDestination == null
        ? null
        : gmap.LatLng(socketDestination.lat, socketDestination.lng);

    if (rider != null) {
      points.add(rider);
    }
    if (fallbackDestination != null) {
      points.add(fallbackDestination);
    }
    if (trackingDestination != null) {
      points.add(trackingDestination);
    }

    return points;
  }

  List<gmap.LatLng> _fallbackStraightRoute(
    gmap.LatLng origin,
    gmap.LatLng destination,
  ) {
    return [origin, destination];
  }

  Future<List<gmap.LatLng>> _fetchDirectionsRoute(
    gmap.LatLng origin,
    gmap.LatLng destination,
  ) async {
    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/directions/json',
      {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'mode': 'driving',
        'alternatives': 'false',
        'key': _googleMapsApiKey,
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        return _fallbackStraightRoute(origin, destination);
      }

      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic>) {
        return _fallbackStraightRoute(origin, destination);
      }

      if (body['status']?.toString() != 'OK') {
        return _fallbackStraightRoute(origin, destination);
      }

      final routes = body['routes'];
      if (routes is! List || routes.isEmpty) {
        return _fallbackStraightRoute(origin, destination);
      }

      final firstRoute = routes.first;
      if (firstRoute is! Map<String, dynamic>) {
        return _fallbackStraightRoute(origin, destination);
      }

      final overviewPolyline = firstRoute['overview_polyline'];
      if (overviewPolyline is! Map<String, dynamic>) {
        return _fallbackStraightRoute(origin, destination);
      }

      final encoded = overviewPolyline['points']?.toString().trim() ?? '';
      if (encoded.isEmpty) {
        return _fallbackStraightRoute(origin, destination);
      }

      final decoded = _decodePolyline(encoded);
      return decoded.length >= 2
          ? decoded
          : _fallbackStraightRoute(origin, destination);
    } catch (error) {
      debugPrint('LiveTrackingMapPanel directions error: $error');
      return _fallbackStraightRoute(origin, destination);
    }
  }

  List<gmap.LatLng> _decodePolyline(String encoded) {
    final points = <gmap.LatLng>[];
    int index = 0;
    int latValue = 0;
    int lngValue = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int byteValue;
      do {
        byteValue = encoded.codeUnitAt(index++) - 63;
        result |= (byteValue & 0x1f) << shift;
        shift += 5;
      } while (byteValue >= 0x20);
      final deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      latValue += deltaLat;

      result = 0;
      shift = 0;
      do {
        byteValue = encoded.codeUnitAt(index++) - 63;
        result |= (byteValue & 0x1f) << shift;
        shift += 5;
      } while (byteValue >= 0x20);
      final deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lngValue += deltaLng;

      points.add(gmap.LatLng(latValue / 1e5, lngValue / 1e5));
    }

    return points;
  }

  gmap.Marker _buildMarker({
    required String id,
    required gmap.LatLng position,
    required String label,
    required double hue,
    String? snippet,
  }) {
    return gmap.Marker(
      markerId: gmap.MarkerId(id),
      position: position,
      icon: gmap.BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: gmap.InfoWindow(title: label, snippet: snippet),
      anchor: const Offset(0.5, 1),
      zIndex: hue,
    );
  }

  Set<gmap.Marker> _buildMarkers() {
    final markers = <gmap.Marker>{};
    final trackingLocation = widget.trackingLocation;
    final rider = _riderPoint();
    final fallbackDestination = _toGoogleLatLng(widget.fallbackDestination);
    final socketDestination = trackingLocation?.destinationLocation == null
        ? null
        : gmap.LatLng(
            trackingLocation!.destinationLocation!.lat,
            trackingLocation.destinationLocation!.lng,
          );

    if (rider != null) {
      markers.add(
        _buildMarker(
          id: 'rider',
          position: rider,
          label: 'Rider',
          hue: gmap.BitmapDescriptor.hueOrange,
          snippet: trackingLocation?.speed == null
              ? null
              : '${trackingLocation!.speed!.toStringAsFixed(0)} km/h',
        ),
      );
    }

    final destinationPoint = fallbackDestination ?? socketDestination;
    if (destinationPoint != null) {
      markers.add(
        _buildMarker(
          id: 'destination',
          position: destinationPoint,
          label: 'Destination',
          hue: gmap.BitmapDescriptor.hueRed,
        ),
      );
    }

    return markers;
  }

  Set<gmap.Polyline> _buildPolylines(List<gmap.LatLng> routePoints) {
    if (routePoints.length < 2) {
      return <gmap.Polyline>{};
    }

    return {
      gmap.Polyline(
        polylineId: const gmap.PolylineId('live_tracking_route'),
        points: routePoints,
        color: const Color(0xFF1E88E5),
        width: 6,
        geodesic: true,
      ),
    };
  }

  Future<void> _syncMapState({bool forceCenter = false}) async {
    final origin = _riderPoint();
    final destination = _destinationPoint();
    final markers = _buildMarkers();

    if (mounted) {
      setState(() {
        _markers = markers;
      });
    }

    if (origin == null || destination == null) {
      if (mounted) {
        setState(() {
          _polylines = <gmap.Polyline>{};
        });
      }
      _fitCameraToVisiblePoints(forceCenter: forceCenter);
      return;
    }

    final signature =
        '${origin.latitude},${origin.longitude}|${destination.latitude},${destination.longitude}';
    if (!forceCenter && _routeSignature == signature) {
      _fitCameraToVisiblePoints(forceCenter: forceCenter);
      return;
    }

    _routeSignature = signature;
    final requestToken = ++_routeRequestToken;
    final routePoints = await _fetchDirectionsRoute(origin, destination);
    if (!mounted || requestToken != _routeRequestToken) {
      return;
    }

    setState(() {
      _polylines = _buildPolylines(routePoints);
    });

    _fitCameraToVisiblePoints(forceCenter: forceCenter);
  }

  Future<void> _fitCameraToVisiblePoints({bool forceCenter = false}) async {
    final controller = _mapController;
    if (controller == null) {
      return;
    }

    final points = _cameraPoints();
    if (points.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _mapController == null) {
        return;
      }

      try {
        if (points.length == 1) {
          await _mapController!.animateCamera(
            gmap.CameraUpdate.newLatLngZoom(
              points.first,
              widget.trackingLocation == null ? 14.5 : 15.0,
            ),
          );
          return;
        }

        final bounds = _boundsFromPoints(points);
        await _mapController!.animateCamera(
          gmap.CameraUpdate.newLatLngBounds(bounds, 72),
        );
      } catch (error) {
        debugPrint('LiveTrackingMapPanel camera fit error: $error');
        final fallback = _riderPoint() ?? _toGoogleLatLng(widget.fallbackDestination);
        if (fallback != null) {
          await _mapController!.animateCamera(
            gmap.CameraUpdate.newLatLngZoom(
              fallback,
              widget.trackingLocation == null ? 14.5 : 15.0,
            ),
          );
        }
      }
    });
  }

  gmap.LatLngBounds _boundsFromPoints(List<gmap.LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (final point in points.skip(1)) {
      south = math.min(south, point.latitude);
      north = math.max(north, point.latitude);
      west = math.min(west, point.longitude);
      east = math.max(east, point.longitude);
    }

    return gmap.LatLngBounds(
      southwest: gmap.LatLng(south, west),
      northeast: gmap.LatLng(north, east),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(20.r(context));
    final fallbackCenter =
        _riderPoint() ??
        _toGoogleLatLng(widget.fallbackDestination) ??
        const gmap.LatLng(23.8103, 90.4125);
    final hasTracking = widget.trackingLocation != null;
    final isLoadingRoute = _routeRequestToken > 0 && _polylines.isEmpty;

    return SizedBox(
      width: double.infinity,
      height: widget.expand ? null : (widget.height ?? 300.h(context)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: effectiveBorderRadius,
        ),
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: Stack(
            children: [
              gmap.GoogleMap(
                initialCameraPosition: gmap.CameraPosition(
                  target: fallbackCenter,
                  zoom: hasTracking ? 14.5 : 13.5,
                ),
                onMapCreated: (controller) {
                  _mapController = controller;
                  _fitCameraToVisiblePoints(forceCenter: true);
                },
                markers: _markers,
                polylines: _polylines,
                mapType: gmap.MapType.normal,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: false,
                trafficEnabled: false,
                buildingsEnabled: true,
                indoorViewEnabled: false,
                mapToolbarEnabled: false,
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
              ),
              Positioned(
                top: 14.h(context),
                left: 14.w(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w(context),
                    vertical: 6.h(context),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999.r(context)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLoadingRoute) ...[
                        SizedBox(
                          width: 12.w(context),
                          height: 12.w(context),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 8.w(context)),
                      ],
                      Text(
                        hasTracking ? 'Live Tracking' : 'Tracking Preview',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.sp(context),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF303030),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
