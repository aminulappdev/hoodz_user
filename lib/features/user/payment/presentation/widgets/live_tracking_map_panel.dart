import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';

class LiveTrackingMapPanel extends StatelessWidget {
  const LiveTrackingMapPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h(context),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(20.r(context)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r(context)),
        child: Stack(
          children: [
            const _MapBackdrop(),
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
          ],
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
