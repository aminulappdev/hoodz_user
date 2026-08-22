import 'package:flutter/material.dart';
import 'package:hoodz/core/utils/app_responsive.dart';
import 'package:hoodz/features/user/orders/presentation/widgets/checkout_section_card.dart';
import 'package:hoodz/gen/assets.gen.dart';

const Color checkoutAccentOrange = Color(0xFFE8622C);

class CheckoutMapCard extends StatelessWidget {
  const CheckoutMapCard({
    super.key,
    required this.pickedUpLabel,
    required this.riderLabel,
  });

  final String pickedUpLabel;
  final String riderLabel;

  @override
  Widget build(BuildContext context) {
    return CheckoutSectionCard(
      padding: const EdgeInsets.all(2),
      child: CheckoutMapCanvas(
        pickedUpLabel: pickedUpLabel,
        riderLabel: riderLabel,
      ),
    );
  }
}

class CheckoutMapCanvas extends StatelessWidget {
  const CheckoutMapCanvas({
    super.key,
    required this.pickedUpLabel,
    required this.riderLabel,
  });

  final String pickedUpLabel;
  final String riderLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 190.h(context),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: CheckoutMapBackdropPainter()),
            ),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x14FFFFFF), Color(0x0AF3F5F7)],
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: CustomPaint(painter: CheckoutRoutePainter()),
            ),
            Positioned(
              left: 12,
              bottom: 62,
              child: CheckoutMapMarker(
                label: riderLabel,
                icon: Icons.navigation,
              ),
            ),
            Positioned(
              right: 72,
              top: 18,
              child: CheckoutMapMarker(
                label: pickedUpLabel,
                icon: Icons.location_on,
              ),
            ),
            Positioned(
              right: -2,
              bottom: 18,
              child: Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0C79F7), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Assets.icons.avatur.image(fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutMapMarker extends StatelessWidget {
  const CheckoutMapMarker({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: checkoutAccentOrange,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 17),
        ),
      ],
    );
  }
}

class CheckoutMapBackdropPainter extends CustomPainter {
  const CheckoutMapBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = const Color(0xFFF3F5F7);
    canvas.drawRect(Offset.zero & size, background);

    final street = Paint()
      ..color = const Color(0xFFD7DDE4)
      ..strokeWidth = 1.2;
    final avenue = Paint()
      ..color = const Color(0xFFC6CFD8)
      ..strokeWidth = 2.6;
    final park = Paint()..color = const Color(0xFFCDEFD2);

    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.6, size.height * 0.45, 28, 54),
      park,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.18),
      Offset(size.width * 0.82, 0),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.1, 0),
      Offset(size.width * 0.32, size.height),
      avenue,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.36),
      Offset(size.width, size.height * 0.22),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, size.height),
      Offset(size.width, size.height * 0.48),
      avenue,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.72),
      Offset(size.width * 0.7, size.height * 0.58),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width, size.height * 0.3),
      street,
    );
    canvas.drawLine(
      Offset(size.width * 0.76, size.height),
      Offset(size.width, size.height * 0.55),
      street,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CheckoutRoutePainter extends CustomPainter {
  const CheckoutRoutePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final route = Paint()
      ..color = checkoutAccentOrange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.08, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.88,
        size.width * 0.34,
        size.height * 0.88,
      )
      ..quadraticBezierTo(
        size.width * 0.52,
        size.height * 0.84,
        size.width * 0.62,
        size.height * 0.66,
      )
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.4,
        size.width * 0.8,
        size.height * 0.14,
      );
    canvas.drawPath(path, route);

    final dot = Paint()..color = const Color(0xFFFFFFFF);
    final points = <Offset>[
      Offset(size.width * 0.12, size.height * 0.77),
      Offset(size.width * 0.2, size.height * 0.88),
      Offset(size.width * 0.34, size.height * 0.88),
      Offset(size.width * 0.48, size.height * 0.8),
      Offset(size.width * 0.6, size.height * 0.66),
      Offset(size.width * 0.7, size.height * 0.46),
      Offset(size.width * 0.77, size.height * 0.28),
    ];

    for (final point in points) {
      canvas.drawCircle(point, 2.1, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
