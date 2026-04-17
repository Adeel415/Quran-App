import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/quran_provider.dart';
import '../services/audio_service.dart';
import '../utils/app_colors.dart';

class FloatingAudioBar extends StatelessWidget {
  const FloatingAudioBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.watch<AudioProvider>();
    final quran = context.watch<QuranProvider>();

    if (!audio.hasActiveAudio) return const SizedBox.shrink();

    final surahName = quran.currentSurah?.name ?? 'Quran';
    final ayahNum = audio.currentAyahNumber ?? 0;
    final isPlaying = audio.isPlaying;
    final isLoading = audio.isLoading;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Progress Bar ──
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: audio.progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.goldLight),
              minHeight: 3,
            ),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              // ── Surah + Ayah info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surahName,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Ayah $ayahNum • ${_formatDuration(audio.position)} / ${_formatDuration(audio.duration)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Controls ──
              Row(
                children: [
                  // Rewind 5s
                  _ControlButton(
                    icon: Icons.replay_5_rounded,
                    onTap: () => audio.seek(
                      Duration(milliseconds: (audio.position.inMilliseconds - 5000).clamp(0, double.maxFinite.toInt())),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Play / Pause
                  GestureDetector(
                    onTap: () => isPlaying ? audio.pause() : audio.resume(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: isLoading
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: AppColors.primaryGreen,
                              size: 26,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Forward 5s
                  _ControlButton(
                    icon: Icons.forward_5_rounded,
                    onTap: () => audio.seek(
                      Duration(milliseconds: audio.position.inMilliseconds + 5000),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Stop
                  _ControlButton(
                    icon: Icons.stop_rounded,
                    onTap: () => audio.stop(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, duration: 300.ms, curve: Curves.easeOut);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
