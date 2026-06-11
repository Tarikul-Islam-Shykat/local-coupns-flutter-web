import 'dart:io';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageShape {
  rectangle,
  roundedRectangle,
  circle,
  oval,
  square,
  hexagon,
  diamond,
  star,
  triangle,
  pentagon,
}

enum ImageSourceType { network, asset, file }

class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);
    for (int i = 0; i < 6; i++) {
      final angle = (math.pi / 3) * i - math.pi / 6;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_HexagonClipper old) => false;
}

class _DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(0, size.height / 2)
      ..close();
  }

  @override
  bool shouldReclip(_DiamondClipper old) => false;
}

class _StarClipper extends CustomClipper<Path> {
  final int points;
  _StarClipper({this.points = 5});

  @override
  Path getClip(Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = math.min(cx, cy);
    final innerR = outerR * 0.45;
    final total = points * 2;
    for (int i = 0; i < total; i++) {
      final angle = (math.pi * 2 / total) * i - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_StarClipper old) => false;
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(_TriangleClipper old) => false;
}

class _PentagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy);
    for (int i = 0; i < 5; i++) {
      final angle = (math.pi * 2 / 5) * i - math.pi / 2;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_PentagonClipper old) => false;
}

class _FullScreenImageViewer extends StatelessWidget {
  final Widget imageWidget;
  final String? heroTag;

  const _FullScreenImageViewer({required this.imageWidget, this.heroTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: heroTag != null
                  ? Hero(tag: heroTag!, child: imageWidget)
                  : imageWidget,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveImage extends StatelessWidget {
  /// The image source: URL for network, asset path for asset, file path for file.
  final String imageSource;

  /// Where the image comes from.
  final ImageSourceType sourceType;

  /// Visual shape to clip the image into.
  final ImageShape shape;

  /// Border radius — only applies to [ImageShape.roundedRectangle].
  final double borderRadius;

  /// Width as a fraction of screen width (0.0 – 1.0). Overrides [width].
  final double? widthPercent;

  /// Height as a fraction of screen height (0.0 – 1.0). Overrides [height].
  final double? heightPercent;

  /// Absolute width in logical pixels.
  final double? width;

  /// Absolute height in logical pixels.
  final double? height;

  /// How the image is inscribed into its box.
  final BoxFit fit;

  /// Custom loading placeholder (network only).
  final Widget? placeholderWidget;

  /// Custom error widget.
  final Widget? errorWidget;

  /// When true, tapping the image opens a full-screen viewer with a close button.
  final bool enableImageView;

  /// Optional hero animation tag for the full-screen transition.
  final String? heroTag;

  const ResponsiveImage({
    Key? key,
    required this.imageSource,
    this.sourceType = ImageSourceType.network,
    this.shape = ImageShape.roundedRectangle,
    this.borderRadius = 8.0,
    this.widthPercent,
    this.heightPercent,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderWidget,
    this.errorWidget,
    this.enableImageView = false,
    this.heroTag,
  }) : super(key: key);

  const ResponsiveImage.network({
    Key? key,
    required String url,
    ImageShape shape = ImageShape.roundedRectangle,
    double borderRadius = 8.0,
    double? widthPercent,
    double? heightPercent,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholderWidget,
    Widget? errorWidget,
    bool enableImageView = false,
    String? heroTag,
  }) : this(
         key: key,
         imageSource: url,
         sourceType: ImageSourceType.network,
         shape: shape,
         borderRadius: borderRadius,
         widthPercent: widthPercent,
         heightPercent: heightPercent,
         width: width,
         height: height,
         fit: fit,
         placeholderWidget: placeholderWidget,
         errorWidget: errorWidget,
         enableImageView: enableImageView,
         heroTag: heroTag,
       );

  /// Asset image (from pubspec assets).
  const ResponsiveImage.asset({
    Key? key,
    required String assetPath,
    ImageShape shape = ImageShape.roundedRectangle,
    double borderRadius = 8.0,
    double? widthPercent,
    double? heightPercent,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    bool enableImageView = false,
    String? heroTag,
  }) : this(
         key: key,
         imageSource: assetPath,
         sourceType: ImageSourceType.asset,
         shape: shape,
         borderRadius: borderRadius,
         widthPercent: widthPercent,
         heightPercent: heightPercent,
         width: width,
         height: height,
         fit: fit,
         errorWidget: errorWidget,
         enableImageView: enableImageView,
         heroTag: heroTag,
       );

  /// Local file image (e.g. picked from gallery).
  const ResponsiveImage.file({
    Key? key,
    required String filePath,
    ImageShape shape = ImageShape.roundedRectangle,
    double borderRadius = 8.0,
    double? widthPercent,
    double? heightPercent,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    bool enableImageView = false,
    String? heroTag,
  }) : this(
         key: key,
         imageSource: filePath,
         sourceType: ImageSourceType.file,
         shape: shape,
         borderRadius: borderRadius,
         widthPercent: widthPercent,
         heightPercent: heightPercent,
         width: width,
         height: height,
         fit: fit,
         errorWidget: errorWidget,
         enableImageView: enableImageView,
         heroTag: heroTag,
       );

  // ── Resolve sizes ─────────────────────────────

  double? _resolveWidth(BuildContext context) {
    if (widthPercent != null) {
      return MediaQuery.of(context).size.width * widthPercent!;
    }
    return width;
  }

  double? _resolveHeight(BuildContext context) {
    if (heightPercent != null) {
      return MediaQuery.of(context).size.height * heightPercent!;
    }
    return height;
  }

  // ── Build raw image ───────────────────────────

  Widget _buildRawImage(BuildContext context, double? w, double? h) {
    final fallbackError =
        errorWidget ??
        Container(
          width: w ?? double.infinity,
          height: h ?? double.infinity,
          color: Colors.grey[850],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white54, size: 40),
          ),
        );

    switch (sourceType) {
      case ImageSourceType.network:
        return CachedNetworkImage(
          imageUrl: imageSource,
          width: w,
          height: h,
          fit: fit,
          placeholder: (_, __) =>
              placeholderWidget ??
              Container(
                width: w ?? double.infinity,
                height: h ?? double.infinity,
                color: Colors.transparent,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
          errorWidget: (_, __, ___) => fallbackError,
        );

      case ImageSourceType.asset:
        return Image.asset(
          imageSource,
          width: w,
          height: h,
          fit: fit,
          errorBuilder: (_, __, ___) => fallbackError,
        );

      case ImageSourceType.file:
        return Image.file(
          File(imageSource),
          width: w,
          height: h,
          fit: fit,
          errorBuilder: (_, __, ___) => fallbackError,
        );
    }
  }

  // ── Apply shape clipping ──────────────────────

  Widget _applyShape(Widget child, double? w, double? h) {
    switch (shape) {
      case ImageShape.circle:
        return ClipOval(child: child);

      case ImageShape.oval:
        return ClipOval(child: child);

      case ImageShape.square:
        final side = (w != null && h != null)
            ? math.min(w, h)
            : (w ?? h ?? double.infinity);
        return ClipRRect(
          borderRadius: BorderRadius.zero,
          child: SizedBox(width: side, height: side, child: child),
        );

      case ImageShape.roundedRectangle:
        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: child,
        );

      case ImageShape.rectangle:
        return ClipRect(child: child);

      case ImageShape.hexagon:
        return ClipPath(clipper: _HexagonClipper(), child: child);

      case ImageShape.diamond:
        return ClipPath(clipper: _DiamondClipper(), child: child);

      case ImageShape.star:
        return ClipPath(clipper: _StarClipper(), child: child);

      case ImageShape.triangle:
        return ClipPath(clipper: _TriangleClipper(), child: child);

      case ImageShape.pentagon:
        return ClipPath(clipper: _PentagonClipper(), child: child);
    }
  }

  // ── Full-screen viewer ────────────────────────

  void _openFullScreen(BuildContext context, Widget rawImage) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (_, __, ___) =>
            _FullScreenImageViewer(imageWidget: rawImage, heroTag: heroTag),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = _resolveWidth(context);
    final h = _resolveHeight(context);

    // Raw image (unshaped) for full-screen viewer
    final rawImage = _buildRawImage(context, null, null);

    // Shaped image for display
    final shapedImage = _applyShape(_buildRawImage(context, w, h), w, h);

    // Optionally wrap with Hero for smooth transition
    final displayWidget = heroTag != null
        ? Hero(tag: heroTag!, child: shapedImage)
        : shapedImage;

    if (!enableImageView) return displayWidget;

    return GestureDetector(
      onTap: () => _openFullScreen(context, rawImage),
      child: displayWidget,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  USAGE EXAMPLES
// ─────────────────────────────────────────────────────────────────────────────

/*

// ── 1. Network image · rounded rectangle · tap to view ────────────────────────
ResponsiveImage.network(
  url: 'https://example.com/cover.jpg',
  shape: ImageShape.roundedRectangle,
  borderRadius: 16,
  widthPercent: 0.9,
  heightPercent: 0.25,
  fit: BoxFit.cover,
  enableImageView: true,
  heroTag: 'cover-hero',
),

// ── 2. Network image · circle avatar ──────────────────────────────────────────
ResponsiveImage.network(
  url: user.profileImage,
  shape: ImageShape.circle,
  widthPercent: 0.15,
  heightPercent: 0.15,
  fit: BoxFit.cover,
  enableImageView: true,
  heroTag: 'avatar-${user.id}',
),

// ── 3. Asset image · hexagon · fixed size ─────────────────────────────────────
ResponsiveImage.asset(
  assetPath: 'assets/images/badge.png',
  shape: ImageShape.hexagon,
  width: 120,
  height: 120,
  fit: BoxFit.cover,
  enableImageView: true,
  heroTag: 'badge-hero',
),

// ── 4. Local file image · diamond (e.g. after image picker) ───────────────────
ResponsiveImage.file(
  filePath: pickedFile.path,
  shape: ImageShape.diamond,
  width: 160,
  height: 160,
  fit: BoxFit.cover,
  enableImageView: true,
),

// ── 5. Network image · star shape · decorative ────────────────────────────────
ResponsiveImage.network(
  url: 'https://example.com/promo.jpg',
  shape: ImageShape.star,
  width: 200,
  height: 200,
  fit: BoxFit.cover,
),

// ── 6. Asset image · pentagon ─────────────────────────────────────────────────
ResponsiveImage.asset(
  assetPath: 'assets/icons/profile.png',
  shape: ImageShape.pentagon,
  width: 100,
  height: 100,
),

// ── 7. Network · triangle banner ──────────────────────────────────────────────
ResponsiveImage.network(
  url: 'https://example.com/banner.png',
  shape: ImageShape.triangle,
  widthPercent: 0.6,
  heightPercent: 0.15,
),

// ── 8. Network · plain rectangle with tap-to-view ─────────────────────────────
ResponsiveImage.network(
  url: 'https://example.com/photo.jpg',
  shape: ImageShape.rectangle,
  widthPercent: 1.0,
  heightPercent: 0.3,
  enableImageView: true,
  heroTag: 'photo-fullscreen',
),

// ── 9. Generic constructor with full control ───────────────────────────────────
ResponsiveImage(
  imageSource: 'https://example.com/product.jpg',
  sourceType: ImageSourceType.network,
  shape: ImageShape.oval,
  widthPercent: 0.5,
  heightPercent: 0.2,
  fit: BoxFit.cover,
  enableImageView: true,
  placeholderWidget: MyCustomShimmer(),
  errorWidget: MyCustomErrorWidget(),
  heroTag: 'product-oval',
),

*/
