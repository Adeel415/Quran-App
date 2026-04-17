import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Geometric Pattern Decoration ──
              _IslamicPattern()
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .scale(begin: const Offset(0.6, 0.6), duration: 800.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 32),

              // ── Logo Mark ──
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: AppColors.goldLight.withOpacity(0.5), width: 1.5),
                ),
                child: Center(
                  child: Text(
                    'ق',
                    style: GoogleFonts.amiri(
                      fontSize: 52,
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 700.ms, delay: 400.ms)
                  .scale(begin: const Offset(0.5, 0.5), duration: 700.ms, curve: Curves.easeOutBack),

              const SizedBox(height: 24),

              // ── App Name ──
              Text(
                'القرآن الكريم',
                style: GoogleFonts.amiri(
                  fontSize: 34,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 700.ms)
                  .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut),

              const SizedBox(height: 8),

              Text(
                'THE NOBLE QURAN',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.goldLight,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 4,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 900.ms)
                  .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut),

              const SizedBox(height: 16),

              // ── Bismillah ──
              Text(
                'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.75),
                  fontWeight: FontWeight.w400,
                  height: 2,
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 1100.ms),

              const Spacer(flex: 2),

              // ── Loading indicator ──
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.15),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldLight),
                  borderRadius: BorderRadius.circular(4),
                  minHeight: 3,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 1400.ms),

              const SizedBox(height: 16),

              Text(
                'Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 1600.ms),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _IslamicPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: CustomPaint(painter: _GeometricPatternPainter()),
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    final outerPaint = Paint()
      ..color = AppColors.goldLight.withOpacity(0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final innerPaint = Paint()
      ..color = AppColors.goldLight.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Outer circle
    canvas.drawCircle(Offset(cx, cy), r * 0.95, outerPaint);
    // Middle circle
    canvas.drawCircle(Offset(cx, cy), r * 0.75, innerPaint);
    // Inner circle
    canvas.drawCircle(Offset(cx, cy), r * 0.5, outerPaint);

    // 8-pointed star
    final starPaint = Paint()
      ..color = AppColors.goldLight.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    _drawStar(canvas, cx, cy, r * 0.7, 8, starPaint);
    _drawStar(canvas, cx, cy, r * 0.45, 8, innerPaint);

    // Decorative dots on outer ring
    final dotPaint = Paint()
      ..color = AppColors.goldLight.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 16; i++) {
      final angle = (i * 22.5) * (3.14159 / 180);
      canvas.drawCircle(
        Offset(cx + r * 0.95 * cos(angle), cy + r * 0.95 * sin(angle)),
        2,
        dotPaint,
      );
    }
  }

  void _drawStar(Canvas canvas, double cx, double cy, double r, int points, Paint paint) {
    final path = Path();
    final innerR = r * 0.5;
    for (int i = 0; i <= points * 2; i++) {
      final angle = (i * 180 / points - 90) * (3.14159 / 180);
      final radius = i.isEven ? r : innerR;
      final x = cx + radius * cos(angle);
      final y = cy + radius * sin(angle);
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double cos(double radians) => _cos(radians);
  double sin(double radians) => _sin(radians);

  double _cos(double r) {
    // Simple cos approximation using Dart's dart:math would be preferred
    // but to avoid the import conflict in this painter, using direct math
    return _mathCos(r);
  }

  double _sin(double r) => _mathSin(r);

  double _mathCos(double x) {
    // Taylor series: 1 - x²/2! + x⁴/4! - ...
    x = x % (2 * 3.14159265358979);
    double result = 1;
    double term = 1;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i - 1) * (2 * i));
      result += term;
    }
    return result;
  }

  double _mathSin(double x) {
    x = x % (2 * 3.14159265358979);
    double result = x;
    double term = x;
    for (int i = 1; i <= 10; i++) {
      term *= -x * x / ((2 * i) * (2 * i + 1));
      result += term;
    }
    return result;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
