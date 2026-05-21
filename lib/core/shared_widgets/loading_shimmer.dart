import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/colors.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const LoadingShimmer.rectangular({
    Key? key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  }) : super(key: key);

  const LoadingShimmer.circular({
    Key? key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFE0E0E0);
    final highlightColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder,
        ),
      ),
    );
  }

  // Common UI preset: Product Card Shimmer
  static Widget productCardPlaceholder({double height = 240, double width = 160}) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer.rectangular(height: height * 0.65),
          const SizedBox(height: 8),
          const LoadingShimmer.rectangular(height: 16, width: 100),
          const SizedBox(height: 6),
          const LoadingShimmer.rectangular(height: 12, width: 60),
        ],
      ),
    );
  }

  // Common UI preset: List Item Shimmer
  static Widget listItemPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const LoadingShimmer.rectangular(width: 80, height: 80),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LoadingShimmer.rectangular(height: 16, width: double.infinity),
                const SizedBox(height: 8),
                const LoadingShimmer.rectangular(height: 12, width: 150),
                const SizedBox(height: 6),
                LoadingShimmer.rectangular(height: 12, width: 85, shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
