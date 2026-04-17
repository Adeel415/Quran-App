import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/ayah_model.dart';
import '../providers/audio_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/quran_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/floating_audio_bar.dart';
import '../widgets/shimmer_loading.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahId;
  final int? scrollToAyah;

  const SurahDetailScreen({super.key, required this.surahId, this.scrollToAyah});

  @override
  State<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  final _scrollController = ScrollController();
  bool _headerCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final collapsed = _scrollController.offset > 140;
      if (collapsed != _headerCollapsed) setState(() => _headerCollapsed = collapsed);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final quran = context.read<QuranProvider>();
      await quran.loadSurah(widget.surahId);

      if (widget.scrollToAyah != null && widget.scrollToAyah! > 1) {
        await Future.delayed(const Duration(milliseconds: 500));
        _scrollToAyah(widget.scrollToAyah!);
      }
    });
  }

  void _scrollToAyah(int ayahNumber) {
    const estimatedCardHeight = 200.0;
    const headerHeight = 200.0;
    final targetOffset = headerHeight + (ayahNumber - 1) * estimatedCardHeight;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final audio = context.watch<AudioProvider>();
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (ctx, inner) => [
              _buildSliverAppBar(quran, isDark),
            ],
            body: _buildBody(quran, audio, isDark),
          ),

          // Floating audio bar
          if (audio.hasActiveAudio && audio.currentSurahId == widget.surahId)
            const Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: FloatingAudioBar(),
            ),
        ],
      ),
    );
  }

  SliverAppBar _buildSliverAppBar(QuranProvider quran, bool isDark) {
    final surah = quran.currentSurah;
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: isDark ? const Color(0xFF1A3A1A) : AppColors.primaryGreen,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.white),
          onPressed: () => _showShareSheet(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (surah != null) ...[
                  Text(
                    surah.arabicName,
                    style: GoogleFonts.amiri(
                      fontSize: 36,
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    surah.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${surah.englishName} • ${surah.ayahCount} Ayahs • ${surah.revelationType}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Bismillah
                  if (surah.id != 1 && surah.id != 9)
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.goldLight.withOpacity(0.3)),
                      ),
                      child: Text(
                        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                        style: GoogleFonts.amiri(
                          fontSize: 16,
                          color: AppColors.goldLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ] else ...[
                  Text(
                    'Loading...',
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(QuranProvider quran, AudioProvider audio, bool isDark) {
    if (quran.detailState == LoadState.loading) {
      return const SurahShimmerLoading();
    }

    if (quran.detailState == LoadState.error) {
      return _ErrorState(
        message: quran.errorMessage ?? 'An error occurred',
        onRetry: () => quran.reloadSurah(widget.surahId),
      );
    }

    final surah = quran.currentSurah;
    if (surah == null || surah.ayahs.isEmpty) {
      return const _EmptyAyahsState();
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        audio.hasActiveAudio ? 120 : 32,
      ),
      itemCount: surah.ayahs.length,
      itemBuilder: (context, i) {
        final ayah = surah.ayahs[i];
        final isPlaying = audio.isCurrentAyah(surah.id, ayah.number) && audio.isPlaying;
        final isLoading = audio.isCurrentAyah(surah.id, ayah.number) && audio.isLoading;
        final isHighlighted = audio.isCurrentAyah(surah.id, ayah.number);

        return _AyahCard(
          ayah: ayah,
          surahName: surah.name,
          isPlaying: isPlaying,
          isLoading: isLoading,
          isHighlighted: isHighlighted,
          isDark: isDark,
          index: i,
          onPlayTap: () => _handlePlayTap(ayah, surah.id),
          onSaveLastRead: () => context.read<QuranProvider>().saveLastRead(
                surah.id,
                ayah.number,
                surah.name,
              ),
        ).animate().fadeIn(delay: (i * 40).ms).slideY(begin: 0.08, delay: (i * 40).ms, duration: 300.ms);
      },
    );
  }

  Future<void> _handlePlayTap(AyahModel ayah, int surahId) async {
    final audioProvider = context.read<AudioProvider>();
    await audioProvider.playAyah(
      surahId: surahId,
      ayahNumber: ayah.number,
      globalNumber: ayah.globalNumber,
      audioUrl: ayah.audioUrl ?? AppConstants.ayahAudioUrl(ayah.globalNumber),
    );
  }

  void _showShareSheet(BuildContext context) {
    final surah = context.read<QuranProvider>().currentSurah;
    if (surah == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share ${surah.name} — coming soon!')),
    );
  }
}

// ─── Ayah Card ────────────────────────────────────────────────────────────────
class _AyahCard extends StatefulWidget {
  final AyahModel ayah;
  final String surahName;
  final bool isPlaying;
  final bool isLoading;
  final bool isHighlighted;
  final bool isDark;
  final int index;
  final VoidCallback onPlayTap;
  final VoidCallback onSaveLastRead;

  const _AyahCard({
    required this.ayah,
    required this.surahName,
    required this.isPlaying,
    required this.isLoading,
    required this.isHighlighted,
    required this.isDark,
    required this.index,
    required this.onPlayTap,
    required this.onSaveLastRead,
  });

  @override
  State<_AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<_AyahCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final isFav = favs.isFavorite(widget.ayah.surahId, widget.ayah.number);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onLongPress: () {
        widget.onSaveLastRead();
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Saved as last read — Ayah ${widget.ayah.number}'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        decoration: BoxDecoration(
          color: _cardColor(widget.isDark),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.isHighlighted
                ? AppColors.primaryGreen.withOpacity(0.5)
                : widget.isDark
                    ? Colors.white.withOpacity(0.07)
                    : AppColors.divider,
            width: widget.isHighlighted ? 1.5 : 1,
          ),
          boxShadow: widget.isHighlighted
              ? [
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : widget.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Ayah Header ──
            _AyahHeader(
              ayahNumber: widget.ayah.number,
              surahName: widget.surahName,
              isPlaying: widget.isPlaying,
              isLoading: widget.isLoading,
              isHighlighted: widget.isHighlighted,
              isFavorite: isFav,
              isDark: widget.isDark,
              onPlayTap: widget.onPlayTap,
              onFavTap: () => _toggleFavorite(context, isFav),
            ),

            const Divider(height: 1, thickness: 0.5),

            // ── Arabic Text ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                widget.ayah.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: GoogleFonts.amiri(
                  fontSize: 26,
                  height: 1.8,
                  color: widget.isHighlighted
                      ? AppColors.primaryGreen
                      : widget.isDark
                          ? Colors.white
                          : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // ── Ornamental Divider ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(child: Divider(color: AppColors.divider.withOpacity(0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '۞',
                      style: TextStyle(color: AppColors.goldAccent.withOpacity(0.6), fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.divider.withOpacity(0.5))),
                ],
              ),
            ),

            // ── Translation ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                widget.ayah.translation.isEmpty
                    ? 'Translation not available'
                    : widget.ayah.translation,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  height: 1.65,
                  color: widget.isDark ? Colors.white70 : AppColors.textSecondary,
                  fontStyle: widget.ayah.translation.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _cardColor(bool isDark) {
    if (widget.isHighlighted) {
      return isDark
          ? AppColors.primaryGreen.withOpacity(0.12)
          : AppColors.surfaceGreen;
    }
    return isDark ? AppColors.darkCard : AppColors.surface;
  }

  Future<void> _toggleFavorite(BuildContext context, bool isFav) async {
    HapticFeedback.lightImpact();
    final added = await context.read<FavoritesProvider>().toggleFavorite(
          surahId: widget.ayah.surahId,
          ayahNumber: widget.ayah.number,
          surahName: widget.surahName,
          arabicText: widget.ayah.arabic,
          translation: widget.ayah.translation,
          globalNumber: widget.ayah.globalNumber,
        );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(added ? '❤️ Added to favorites' : 'Removed from favorites'),
          backgroundColor: added ? AppColors.primaryGreen : AppColors.textSecondary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

// ─── Ayah Header ─────────────────────────────────────────────────────────────
class _AyahHeader extends StatelessWidget {
  final int ayahNumber;
  final String surahName;
  final bool isPlaying;
  final bool isLoading;
  final bool isHighlighted;
  final bool isFavorite;
  final bool isDark;
  final VoidCallback onPlayTap;
  final VoidCallback onFavTap;

  const _AyahHeader({
    required this.ayahNumber,
    required this.surahName,
    required this.isPlaying,
    required this.isLoading,
    required this.isHighlighted,
    required this.isFavorite,
    required this.isDark,
    required this.onPlayTap,
    required this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Row(
        children: [
          // Ayah number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: isHighlighted
                  ? AppColors.primaryGradient
                  : LinearGradient(
                      colors: [
                        AppColors.goldAccent.withOpacity(0.8),
                        AppColors.gold,
                      ],
                    ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$ayahNumber',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$surahName · $ayahNumber',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: isDark ? Colors.white60 : AppColors.textHint,
            ),
          ),
          const Spacer(),

          // Favorite button
          IconButton(
            onPressed: onFavTap,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isFavorite),
                size: 20,
                color: isFavorite ? Colors.red.shade400 : AppColors.textHint,
              ),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),

          // Play button
          GestureDetector(
            onTap: onPlayTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isHighlighted
                    ? AppColors.primaryGreen
                    : AppColors.primaryGreen.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(9),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isHighlighted ? Colors.white : AppColors.primaryGreen,
                        ),
                      ),
                    )
                  : Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 20,
                      color: isHighlighted ? Colors.white : AppColors.primaryGreen,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Error State ─────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.textHint),
            const SizedBox(height: 16),
            Text(
              'Connection Error',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAyahsState extends StatelessWidget {
  const _EmptyAyahsState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No ayahs found'),
    );
  }
}
