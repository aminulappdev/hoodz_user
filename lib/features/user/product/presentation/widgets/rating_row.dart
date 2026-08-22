// lib/core/widgets/star_rating_row.dart

import 'package:flutter/material.dart';

/// A small reusable widget that draws N stars (filled vs outlined)
/// based on a rating value. Kept generic (not review-specific)
/// so it can be reused for products, stores, etc. too.
class StarRatingRow extends StatelessWidget {
  final double rating;   // e.g. 4.0
  final double size;     // icon size, defaults to 16
  final int starCount;   // usually 5

  const StarRatingRow({
    super.key,
    required this.rating,
    this.size = 16,
    this.starCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // don't take full width, only as much as stars need
      children: List.generate(starCount, (index) {
        final starPosition = index + 1; // stars are 1-indexed visually
        return Icon(
          starPosition <= rating ? Icons.star : Icons.star_border,
          size: size,
          color: starPosition <= rating
              ? Colors.orange
              : Colors.grey.shade400,
        );
      }),
    );
  }
}