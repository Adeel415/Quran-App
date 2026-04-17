import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/app_colors.dart';

class SurahShimmerLoading extends StatelessWidget {
  const SurahShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE);
    final highlightColor = isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        itemCount: 5,
        itemBuilder: (_, i) => _ShimmerCard(),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _ShimmerBox(width: 36, height: 36, radius: 18),
              const SizedBox(width: 10),
              _ShimmerBox(width: 100, height: 12, radius: 6),
              const Spacer(),
              _ShimmerBox(width: 36, height: 36, radius: 18),
            ],
          ),
          const SizedBox(height: 16),
          // Arabic text (right side)
          Align(alignment: Alignment.centerRight, child: _ShimmerBox(width: 220, height: 22, radius: 6)),
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerRight, child: _ShimmerBox(width: 180, height: 22, radius: 6)),
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerRight, child: _ShimmerBox(width: 260, height: 22, radius: 6)),
          const SizedBox(height: 16),
          // Translation lines
          _ShimmerBox(width: double.infinity, height: 12, radius: 6),
          const SizedBox(height: 8),
          _ShimmerBox(width: double.infinity, height: 12, radius: 6),
          const SizedBox(height: 8),
          _ShimmerBox(width: 200, height: 12, radius: 6),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _ShimmerBox({required this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── General shimmer list for surah list ──────────────────────────────────────
class SurahListShimmer extends StatelessWidget {
  const SurahListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
      highlightColor: isDark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        itemCount: 12,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
