import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../providers/settings_provider.dart';
import '../models/surah_model.dart';
import '../utils/app_colors.dart';
import 'surah_detail_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _showScrollToTop = _scrollController.offset > 300);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final isDark = context.watch<SettingsProvider>().isDarkMode;
    final surahs = quran.filteredSurahs;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(isDark, innerBoxIsScrolled),
        ],
        body: surahs.isEmpty
            ? _EmptyState(query: quran.searchQuery)
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                itemCount: surahs.length,
                itemBuilder: (context, i) => _SurahListItem(
                  surah: surahs[i],
                  index: i,
                  isDark: isDark,
                ).animate().fadeIn(delay: (i * 30).ms).slideX(begin: 0.1, delay: (i * 30).ms),
              ),
      ),
      floatingActionButton: _showScrollToTop
          ? FloatingActionButton.small(
              onPressed: () => _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
              backgroundColor: AppColors.primaryGreen,
              child: const Icon(Icons.arrow_upward_rounded, color: Colors.white),
            ).animate().fadeIn().scale()
          : null,
    );
  }

  SliverAppBar _buildSliverAppBar(bool isDark, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      floating: false,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
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
                  Text(
                    'Surah List',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '114 Surahs of the Noble Quran',
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          color: isDark ? AppColors.darkBackground : AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: _SearchBar(
            controller: _searchController,
            isDark: isDark,
            onChanged: (v) => context.read<QuranProvider>().search(v),
            onClear: () {
              _searchController.clear();
              context.read<QuranProvider>().clearSearch();
            },
          ),
        ),
      ),
    );
  }
}

// ─── Search Bar ───────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.isDark,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? Colors.white12 : AppColors.divider),
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search surah name, number...',
          hintStyle: GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
          prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: AppColors.textHint, size: 18),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─── Surah List Item ──────────────────────────────────────────────────────────
class _SurahListItem extends StatelessWidget {
  final SurahModel surah;
  final int index;
  final bool isDark;

  const _SurahListItem({required this.surah, required this.index, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => SurahDetailScreen(surahId: surah.id),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.06) : AppColors.divider,
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
        child: Row(
          children: [
            // Number badge
            _OrnamentalNumberBadge(number: surah.id),
            const SizedBox(width: 14),

            // Surah info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      _PillTag(
                        label: surah.englishName,
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        textColor: AppColors.primaryGreen,
                      ),
                      const SizedBox(width: 6),
                      _PillTag(
                        label: surah.revelationType,
                        color: AppColors.goldAccent.withOpacity(0.15),
                        textColor: AppColors.gold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${surah.ayahCount} Ayahs',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            // Arabic name
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surah.arabicName,
                  style: GoogleFonts.amiri(
                    fontSize: 22,
                    color: isDark ? AppColors.goldLight : AppColors.gold,
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OrnamentalNumberBadge extends StatelessWidget {
  final int number;
  const _OrnamentalNumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Decorative ring
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
          ),
          Text(
            '$number',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _PillTag({required this.label, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500, color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text(
            'No results for "$query"',
            style: GoogleFonts.poppins(fontSize: 16, color: AppColors.textHint),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching by surah name or number',
            style: GoogleFonts.poppins(fontSize: 13, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }
}
