import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/app_colors.dart';
import '../utils/quran_data.dart';
import 'surah_list_screen.dart';
import 'surah_detail_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _screens = const [_HomeTab(), SurahListScreen(), FavoritesScreen()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuranProvider>().initialize();
      context.read<FavoritesProvider>().loadFavorites();
      context.read<SettingsProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: _buildBottomNav(settings.isDarkMode),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_rounded, label: 'Home', index: 0, selected: _selectedIndex, onTap: _onTap),
              _NavItem(icon: Icons.menu_book_rounded, label: 'Surahs', index: 1, selected: _selectedIndex, onTap: _onTap),
              _NavItem(icon: Icons.favorite_rounded, label: 'Favorites', index: 2, selected: _selectedIndex, onTap: _onTap),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(int index) => setState(() => _selectedIndex = index);
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selected;
  final void Function(int) onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryGreen : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primaryGreen : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home Tab Content
// ─────────────────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final quran = context.watch<QuranProvider>();
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────────────────
          SliverToBoxAdapter(child: _HomeHeader(isDark: isDark)),

          // ── Continue Reading ───────────────────────────────────────────────
          if (quran.lastRead != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _ContinueReadingCard(lastRead: quran.lastRead!, isDark: isDark),
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, delay: 200.ms),
            ),

          // ── Section Title ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quick Access',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SurahListScreen()),
                    ),
                    child: Text(
                      'See all',
                      style: GoogleFonts.poppins(
                        color: AppColors.primaryGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 300.ms),
          ),

          // ── Quick Surah Grid ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final s = QuranData.surahs[i];
                  return _QuickSurahCard(data: s, isDark: isDark)
                      .animate()
                      .fadeIn(delay: (350 + i * 60).ms)
                      .slideX(begin: 0.1, delay: (350 + i * 60).ms);
                },
                childCount: 6,
              ),
            ),
          ),

          // ── Last 10 Surahs ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              child: Text(
                'Short Surahs',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
              ),
            ).animate().fadeIn(delay: 700.ms),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final idx = 113 - i; // last 10 surahs (109-114)
                  final s = QuranData.surahs[idx];
                  return _ShortSurahListTile(data: s, isDark: isDark)
                      .animate()
                      .fadeIn(delay: (750 + i * 80).ms)
                      .slideX(begin: 0.15, delay: (750 + i * 80).ms);
                },
                childCount: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Home Header ─────────────────────────────────────────────────────────────
class _HomeHeader extends StatelessWidget {
  final bool isDark;
  const _HomeHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeaderGradient : AppColors.headerGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu Alaikum',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Noble Quran',
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: settings.toggleDarkMode,
                        icon: Icon(
                          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                          color: AppColors.goldLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bismillah ornamental card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.goldLight.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      '﷽',
                      style: GoogleFonts.amiri(
                        fontSize: 28,
                        color: AppColors.goldLight,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                        height: 1.8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, duration: 600.ms);
  }
}

// ─── Continue Reading Card ────────────────────────────────────────────────────
class _ContinueReadingCard extends StatelessWidget {
  final Map<String, dynamic> lastRead;
  final bool isDark;

  const _ContinueReadingCard({required this.lastRead, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final surahId = lastRead['surah_id'] as int;
    final ayahNumber = lastRead['ayah_number'] as int;
    final surahName = lastRead['surah_name'] as String;
    final staticData = QuranData.getSurahById(surahId);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SurahDetailScreen(
            surahId: surahId,
            scrollToAyah: ayahNumber,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1565C0).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bookmark_rounded, color: AppColors.goldLight, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Continue Reading',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    surahName,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (staticData != null)
                    Text(
                      staticData['english'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Ayah $ayahNumber',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (staticData != null)
                  Text(
                    staticData['arabic'] as String,
                    style: GoogleFonts.amiri(
                      fontSize: 28,
                      color: AppColors.goldLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 22),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Surah Card ─────────────────────────────────────────────────────────
class _QuickSurahCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const _QuickSurahCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SurahDetailScreen(surahId: data['id'] as int)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.divider,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${data['id']}',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data['name'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${data['ayahs']} Ayahs',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              data['arabic'] as String,
              style: GoogleFonts.amiri(
                fontSize: 16,
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Short Surah List Tile ────────────────────────────────────────────────────
class _ShortSurahListTile extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;

  const _ShortSurahListTile({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SurahDetailScreen(surahId: data['id'] as int)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? Colors.white10 : AppColors.divider),
        ),
        child: Row(
          children: [
            _SurahNumberBadge(number: data['id'] as int),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${data['english']} • ${data['ayahs']} Ayahs • ${data['type']}',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            Text(
              data['arabic'] as String,
              style: GoogleFonts.amiri(
                fontSize: 20,
                color: AppColors.gold,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurahNumberBadge extends StatelessWidget {
  final int number;
  const _SurahNumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
