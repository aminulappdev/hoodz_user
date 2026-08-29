import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hoodz/core/services/socket/user_order_socket_service.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class LiveTrackingMapPanel extends StatelessWidget {
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final bool expand;
  final UserOrderTrackingLocation? trackingLocation;

  const LiveTrackingMapPanel({
    super.key,
    this.height,
    this.borderRadius,
    this.expand = false,
    this.trackingLocation,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(20.r(context));

    return SizedBox(
      width: double.infinity,
      height: expand ? null : (height ?? 300.h(context)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4F6),
          borderRadius: effectiveBorderRadius,
        ),
        child: ClipRRect(
          borderRadius: effectiveBorderRadius,
          child: Stack(
            children: [
              const _MapBackdrop(),
              if (trackingLocation == null) ...[
                Positioned(
                  left: 28.w(context),
                  top: 112.h(context),
                  child: const _MapPin(
                    label: 'Rider',
                    markerColor: Color(0xFF2E2E2E),
                    badgeColor: Color(0xFFFF6B00),
                    icon: Icons.navigation_rounded,
                  ),
                ),
                Positioned(
                  right: 44.w(context),
                  top: 42.h(context),
                  child: const _MapPin(
                    label: 'Your location',
                    markerColor: Color(0xFF2E2E2E),
                    badgeColor: Color(0xFFFF6B00),
                    icon: Icons.location_on_rounded,
                  ),
                ),
                Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
              ] else
                Positioned.fill(
                  child: _RealtimeTrackingOverlay(
                    location: trackingLocation!,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapBackdrop extends StatelessWidget {
  const _MapBackdrop();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _MapPainter(), child: Container());
  }
}

class _RealtimeTrackingOverlay extends StatelessWidget {
  final UserOrderTrackingLocation location;

  const _RealtimeTrackingOverlay({
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final projection = _TrackingProjection.fromLocation(location, size);

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _RealtimeRoutePainter(
                  route: projection.routeOffsets,
                ),
              ),
            ),
            Positioned(
              left: projection.riderOffset.dx,
              top: projection.riderOffset.dy,
              child: Transform.translate(
                offset: const Offset(-18, -48),
                child: _TrackingMarker(
                  label: 'Rider',
                  icon: Icons.navigation_rounded,
                  markerColor: const Color(0xFF2E2E2E),
                  badgeColor: const Color(0xFFFF6B00),
                  subtitle: location.speed == null
                      ? null
                      : '${location.speed!.toStringAsFixed(0)} km/h',
                ),
              ),
            ),
            Positioned(
              left: projection.destinationOffset.dx,
              top: projection.destinationOffset.dy,
              child: Transform.translate(
                offset: const Offset(-18, -48),
                child: _TrackingMarker(
                  label: 'Your location',
                  icon: Icons.location_on_rounded,
                  markerColor: const Color(0xFF2E2E2E),
                  badgeColor: const Color(0xFFFF6B00),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrackingMarker extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color markerColor;
  final Color badgeColor;
  final String? subtitle;

  const _TrackingMarker({
    required this.label,
    required this.icon,
    required this.markerColor,
    required this.badgeColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w(context),
            vertical: 4.h(context),
          ),
          decoration: BoxDecoration(
            color: markerColor,
            borderRadius: BorderRadius.circular(8.r(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 10.sp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 2.h(context)),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                    fontSize: 9.sp(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 4.h(context)),
        Center(
          child: Container(
            width: 24.w(context),
            height: 24.w(context),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16.sp(context)),
          ),
        ),
      ],
    );
  }
}

class _TrackingProjection {
  const _TrackingProjection({
    required this.routeOffsets,
    required this.riderOffset,
    required this.destinationOffset,
  });

  final List<Offset> routeOffsets;
  final Offset riderOffset;
  final Offset destinationOffset;

  factory _TrackingProjection.fromLocation(
    UserOrderTrackingLocation location,
    Size size,
  ) {
    final points = <TrackingGeoPoint>[
      location.riderLocation,
      if (location.destinationLocation != null) location.destinationLocation!,
      ...location.routePoints,
    ];

    final bounds = _GeoBounds.fromPoints(points);
    final projectedRoute =
        location.routePoints.isNotEmpty
            ? location.routePoints
                .map((point) => bounds.project(point, size))
                .toList()
            : <Offset>[
              bounds.project(location.riderLocation, size),
              if (location.destinationLocation != null)
                bounds.project(location.destinationLocation!, size),
            ];

    final riderOffset = bounds.project(location.riderLocation, size);
    final destinationPoint =
        location.destinationLocation ?? location.routePoints.lastOrNull ??
        location.riderLocation;
    final destinationOffset = bounds.project(destinationPoint, size);

    return _TrackingProjection(
      routeOffsets: projectedRoute,
      riderOffset: riderOffset,
      destinationOffset: destinationOffset,
    );
  }
}

class _GeoBounds {
  const _GeoBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
  });

  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;

  factory _GeoBounds.fromPoints(List<TrackingGeoPoint> points) {
    var minLat = points.first.lat;
    var maxLat = points.first.lat;
    var minLng = points.first.lng;
    var maxLng = points.first.lng;

    for (final point in points.skip(1)) {
      minLat = math.min(minLat, point.lat);
      maxLat = math.max(maxLat, point.lat);
      minLng = math.min(minLng, point.lng);
      maxLng = math.max(maxLng, point.lng);
    }

    if ((maxLat - minLat).abs() < 0.0001) {
      minLat -= 0.002;
      maxLat += 0.002;
    }
    if ((maxLng - minLng).abs() < 0.0001) {
      minLng -= 0.002;
      maxLng += 0.002;
    }

    return _GeoBounds(
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
    );
  }

  Offset project(TrackingGeoPoint point, Size size) {
    const padding = 28.0;
    final usableWidth = (size.width - padding * 2).clamp(1.0, size.width);
    final usableHeight = (size.height - padding * 2).clamp(1.0, size.height);

    final xPercent = (point.lng - minLng) / (maxLng - minLng);
    final yPercent = (maxLat - point.lat) / (maxLat - minLat);

    return Offset(
      padding + usableWidth * xPercent,
      padding + usableHeight * yPercent,
    );
  }
}

class _RealtimeRoutePainter extends CustomPainter {
  _RealtimeRoutePainter({required this.route});

  final List<Offset> route;

  @override
  void paint(Canvas canvas, Size size) {
    if (route.length < 2) {
      return;
    }

    final path = Path()..moveTo(route.first.dx, route.first.dy);
    for (final point in route.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }

    final routePaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final glowPaint = Paint()
      ..color = const Color(0x22FF6B00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, routePaint);

    final dotPaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.fill;

    for (final point in route) {
      canvas.drawCircle(point, 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RealtimeRoutePainter oldDelegate) {
    return oldDelegate.route != route;
  }
}

class _MapPin extends StatelessWidget {
  final String label;
  final Color markerColor;
  final Color badgeColor;
  final IconData icon;

  const _MapPin({
    required this.label,
    required this.markerColor,
    required this.badgeColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8.w(context),
            vertical: 4.h(context),
          ),
          decoration: BoxDecoration(
            color: markerColor,
            borderRadius: BorderRadius.circular(8.r(context)),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 10.sp(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 4.h(context)),
        Center(
          child: Container(
            width: 24.w(context),
            height: 24.w(context),
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16.sp(context)),
          ),
        ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF3F4F6);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFFD9E0E6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final majorRoad = Paint()
      ..color = const Color(0xFFC7D0D7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path1 = Path()
      ..moveTo(0, size.height * .25)
      ..quadraticBezierTo(
        size.width * .2,
        size.height * .18,
        size.width * .45,
        size.height * .22,
      )
      ..quadraticBezierTo(
        size.width * .7,
        size.height * .28,
        size.width,
        size.height * .18,
      );
    canvas.drawPath(path1, majorRoad);

    final path2 = Path()
      ..moveTo(size.width * .12, 0)
      ..lineTo(size.width * .22, size.height)
      ..moveTo(size.width * .42, 0)
      ..lineTo(size.width * .58, size.height)
      ..moveTo(size.width * .74, 0)
      ..lineTo(size.width * .88, size.height);
    canvas.drawPath(path2, road);

    for (double y = 46; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 6), road);
    }
    for (double x = 24; x < size.width; x += 48) {
      canvas.drawLine(Offset(x, 0), Offset(x + 18, size.height), road);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .17, size.height * .52)
      ..quadraticBezierTo(
        size.width * .29,
        size.height * .64,
        size.width * .45,
        size.height * .52,
      )
      ..quadraticBezierTo(
        size.width * .63,
        size.height * .38,
        size.width * .78,
        size.height * .24,
      );

    final routePaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final dottedPaint = Paint()
      ..color = const Color(0xFFFF6B00)
      ..style = PaintingStyle.fill;

    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 8) {
        final tangent = metric.getTangentForOffset(d);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, 1.4, dottedPaint);
        }
      }
    }

    canvas.drawPath(path, routePaint..color = const Color(0x44FF6B00));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension _LastOrNullExtension<T> on List<T> {
  T? get lastOrNull => isEmpty ? null : last;
}
