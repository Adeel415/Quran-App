import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/favorite_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import 'surah_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesProvider>();
    final isDark = context.watch<SettingsProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF1A3A1A) : AppColors.primaryGreen,
            automaticallyImplyLeading: false,
            actions: [
              if (favs.count > 0)
                IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.white70),
                  onPressed: () => _confirmClearAll(context, favs),
                  tooltip: 'Clear All',
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Favorites',
                              style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${favs.count} saved ${favs.count == 1 ? 'ayah' : 'ayahs'}',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          favs.count == 0
              ? SliverFillRemaining(child: _EmptyFavoritesState(isDark: isDark))
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _FavoriteCard(
                        favorite: favs.favorites[i],
                        isDark: isDark,
                        index: i,
                        onRemove: () => favs.removeFavorite(favs.favorites[i]),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SurahDetailScreen(
                              surahId: favs.favorites[i].surahId,
                              scrollToAyah: favs.favorites[i].ayahNumber,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: (i * 60).ms).slideX(begin: 0.1, delay: (i * 60).ms),
                      childCount: favs.count,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, FavoritesProvider favs) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text('Are you sure you want to remove all saved ayahs?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              favs.clearAll();
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

// ─── Favorite Card ────────────────────────────────────────────────────────────
class _FavoriteCard extends StatelessWidget {
  final FavoriteModel favorite;
  final bool isDark;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FavoriteCard({
    required this.favorite,
    required this.isDark,
    required this.index,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Dismissible(
        key: Key(favorite.id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.red.shade600,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_rounded, color: Colors.white, size: 26),
              SizedBox(height: 4),
              Text('Remove', style: TextStyle(color: Colors.white, fontSize: 11)),
            ],
          ),
        ),
        onDismissed: (_) => onRemove(),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.07) : AppColors.divider,
            ),
            boxShadow: isDark
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
              // ── Card Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primaryGreen.withOpacity(0.1)
                      : AppColors.surfaceGreen,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        favorite.surahName,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Ayah ${favorite.ayahNumber}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.favorite_rounded, size: 16, color: Colors.red.shade400),
                  ],
                ),
              ),

              // ── Arabic ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Text(
                  favorite.arabicText,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    height: 1.8,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ── Divider ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  color: (isDark ? Colors.white : AppColors.divider).withOpacity(0.3),
                  height: 1,
                ),
              ),

              // ── Translation ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Text(
                  favorite.translation.isEmpty ? 'Translation not available' : favorite.translation,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.6,
                    color: isDark ? Colors.white60 : AppColors.textSecondary,
                    fontStyle: favorite.translation.isEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ── Footer ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(favorite.savedAt),
                      style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textHint),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onRemove,
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 14, color: Colors.red.shade300),
                          const SizedBox(width: 3),
                          Text(
                            'Remove',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.red.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// ─── Empty State ─────────────────────────────────────────────────────────────
class _EmptyFavoritesState extends StatelessWidget {
  final bool isDark;
  const _EmptyFavoritesState({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border_rounded, size: 48, color: Colors.red.shade300),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.05, 1.05), duration: 1500.ms),
          const SizedBox(height: 24),
          Text(
            'No Favorites Yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Tap the ❤️ button on any Ayah\nto save it here for quick access.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textHint,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
