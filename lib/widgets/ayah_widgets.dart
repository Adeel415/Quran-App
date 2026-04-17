import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Reusable ornamental divider with Islamic star motif
class AyahDivider extends StatelessWidget {
  final Color? color;
  const AyahDivider({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.gold.withOpacity(0.4);
    return Row(
      children: [
        Expanded(child: Divider(color: c, thickness: 0.8)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('✦', style: TextStyle(color: c, fontSize: 10)),
        ),
        Expanded(child: Divider(color: c, thickness: 0.8)),
      ],
    );
  }
}

/// Number badge with ornamental design matching Islamic calligraphy style
class AyahNumberBadge extends StatelessWidget {
  final int number;
  final bool highlighted;
  final double size;

  const AyahNumberBadge({
    super.key,
    required this.number,
    this.highlighted = false,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: highlighted
            ? AppColors.primaryGradient
            : LinearGradient(
                colors: [AppColors.goldAccent.withOpacity(0.9), AppColors.gold],
              ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (highlighted ? AppColors.primaryGreen : AppColors.gold).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$number',
          style: GoogleFonts.poppins(
            fontSize: size * 0.35,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Surah type pill badge (Meccan / Medinan)
class RevelationTypeBadge extends StatelessWidget {
  final String type;
  const RevelationTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isMeccan = type.toLowerCase().contains('meccan');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: (isMeccan ? AppColors.gold : const Color(0xFF1565C0)).withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isMeccan ? AppColors.gold : const Color(0xFF1565C0)).withOpacity(0.3),
        ),
      ),
      child: Text(
        type,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isMeccan ? AppColors.gold : const Color(0xFF1565C0),
        ),
      ),
    );
  }
}

/// Islamic geometric pattern divider for section headers
class IslamicSectionDivider extends StatelessWidget {
  final String? title;
  const IslamicSectionDivider({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const _StarPattern(),
          const SizedBox(width: 12),
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.amiri(
                fontSize: 14,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
          ],
          const _StarPattern(),
        ],
      ),
    );
  }
}

class _StarPattern extends StatelessWidget {
  const _StarPattern();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: List.generate(
          5,
          (i) => Expanded(
            child: Container(
              height: 1,
              color: i.isEven
                  ? AppColors.gold.withOpacity(0.3)
                  : AppColors.gold.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}
