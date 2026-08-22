import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoodz/core/services/others/image_cache_service.dart';
import 'package:hoodz/gen/assets.gen.dart';

class AppCachedNetworkImage extends StatelessWidget {
  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.imageWidth,
    this.imageHeight,
    this.imageFit,
    this.radius,
    this.imageSize = 0,
    this.errorImagePath,
  });

  final String? imageUrl;
  final double? imageWidth;
  final double? imageHeight;
  final BoxFit? imageFit;
  final double? radius;
  final double imageSize;
  final String? errorImagePath;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius ?? 6);
    final cacheWidth = ImageCacheService.getMemCacheWidth(
      context,
      imageWidth: imageWidth,
      imageSize: imageSize,
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _FallbackImage(
        width: imageWidth,
        height: imageHeight,
        radius: borderRadius,
        imageFit: imageFit,
        imagePath: errorImagePath,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: imageWidth,
      height: imageHeight,
      fit: imageFit ?? BoxFit.cover,
      memCacheWidth: cacheWidth,
      imageBuilder: (context, imageProvider) => Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: imageFit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        width: imageWidth,
        height: imageHeight,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          gradient: const LinearGradient(
            colors: [Color(0xFFF7F7F7), Color(0xFFECECEC)],
          ),
        ),
        child: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      errorWidget: (context, url, error) => _FallbackImage(
        width: imageWidth,
        height: imageHeight,
        radius: borderRadius,
        imageFit: imageFit,
        imagePath: errorImagePath,
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  const _FallbackImage({
    required this.width,
    required this.height,
    required this.radius,
    required this.imageFit,
    this.imagePath,
  });

  final double? width;
  final double? height;
  final BorderRadius radius;
  final BoxFit? imageFit;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        image: DecorationImage(
          image: AssetImage(imagePath ?? Assets.images.background02.path),
          fit: imageFit ?? BoxFit.cover,
        ),
      ),
    );
  }
}
