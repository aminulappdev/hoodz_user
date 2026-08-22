import 'package:flutter/material.dart';

class ImageCacheService {
  const ImageCacheService._();

  static int? getMemCacheWidth(
    BuildContext context, {
    double? imageWidth,
    double imageSize = 0,
  }) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final logicalWidth = imageWidth ?? (imageSize > 0 ? imageSize : null);

    if (logicalWidth == null || !logicalWidth.isFinite || logicalWidth <= 0) {
      return null;
    }

    return (logicalWidth * pixelRatio).toInt();
  }
}
