import 'package:flutter/material.dart';
import 'package:hoodz/features/user/orders/presentation/pages/check_out_popup.dart';

class MapCard extends StatelessWidget {
  final String pickedUpLabel;
  final String riderLabel;
  final double height;

  const MapCard({
    super.key,
    required this.pickedUpLabel,
    required this.riderLabel,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(
              color: const Color(0xFFE9ECEF),
              child: CustomPaint(
                painter: _FakeStreetsPainter(),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              top: 40,
              right: 70,
              child: MapMarker(
                label: pickedUpLabel,
                icon: Icons.location_on,
                iconColor: kOrange,
              ),
            ),
            Positioned(
              bottom: 60,
              left: 30,
              child: MapMarker(
                label: riderLabel,
                icon: Icons.navigation,
                iconColor: kOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MapMarker extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;

  const MapMarker({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ),
        const SizedBox(height: 2),
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ],
    );
  }
}

// Decorative background lines for the fake map. Not a "widget" in the
// public API sense (no reason another screen would import just this),
// so it stays private with the leading underscore.
class _FakeStreetsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.35), paint);
    canvas.drawLine(Offset(size.width * 0.2, 0), Offset(size.width * 0.4, size.height), paint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}