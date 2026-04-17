class QuranData {
  /// All 114 Surahs: [id, arabicName, transliteratedName, englishName, ayahCount, revelationType, globalStartAyah]
  static const List<Map<String, dynamic>> surahs = [
    {'id': 1, 'arabic': 'الفاتحة', 'name': 'Al-Fatihah', 'english': 'The Opening', 'ayahs': 7, 'type': 'Meccan', 'start': 1},
    {'id': 2, 'arabic': 'البقرة', 'name': 'Al-Baqarah', 'english': 'The Cow', 'ayahs': 286, 'type': 'Medinan', 'start': 8},
    {'id': 3, 'arabic': 'آل عمران', 'name': "Ali 'Imran", 'english': 'Family of Imran', 'ayahs': 200, 'type': 'Medinan', 'start': 294},
    {'id': 4, 'arabic': 'النساء', 'name': "An-Nisa'", 'english': 'The Women', 'ayahs': 176, 'type': 'Medinan', 'start': 494},
    {'id': 5, 'arabic': 'المائدة', 'name': "Al-Ma'idah", 'english': 'The Table Spread', 'ayahs': 120, 'type': 'Medinan', 'start': 670},
    {'id': 6, 'arabic': 'الأنعام', 'name': "Al-An'am", 'english': 'The Cattle', 'ayahs': 165, 'type': 'Meccan', 'start': 790},
    {'id': 7, 'arabic': 'الأعراف', 'name': "Al-A'raf", 'english': 'The Heights', 'ayahs': 206, 'type': 'Meccan', 'start': 955},
    {'id': 8, 'arabic': 'الأنفال', 'name': 'Al-Anfal', 'english': 'The Spoils of War', 'ayahs': 75, 'type': 'Medinan', 'start': 1161},
    {'id': 9, 'arabic': 'التوبة', 'name': 'At-Tawbah', 'english': 'The Repentance', 'ayahs': 129, 'type': 'Medinan', 'start': 1236},
    {'id': 10, 'arabic': 'يونس', 'name': 'Yunus', 'english': 'Jonah', 'ayahs': 109, 'type': 'Meccan', 'start': 1365},
    {'id': 11, 'arabic': 'هود', 'name': 'Hud', 'english': 'Hud', 'ayahs': 123, 'type': 'Meccan', 'start': 1474},
    {'id': 12, 'arabic': 'يوسف', 'name': 'Yusuf', 'english': 'Joseph', 'ayahs': 111, 'type': 'Meccan', 'start': 1597},
    {'id': 13, 'arabic': 'الرعد', 'name': "Ar-Ra'd", 'english': 'The Thunder', 'ayahs': 43, 'type': 'Medinan', 'start': 1708},
    {'id': 14, 'arabic': 'إبراهيم', 'name': 'Ibrahim', 'english': 'Abraham', 'ayahs': 52, 'type': 'Meccan', 'start': 1751},
    {'id': 15, 'arabic': 'الحجر', 'name': 'Al-Hijr', 'english': 'The Rocky Tract', 'ayahs': 99, 'type': 'Meccan', 'start': 1803},
    {'id': 16, 'arabic': 'النحل', 'name': 'An-Nahl', 'english': 'The Bee', 'ayahs': 128, 'type': 'Meccan', 'start': 1902},
    {'id': 17, 'arabic': 'الإسراء', 'name': "Al-Isra'", 'english': 'The Night Journey', 'ayahs': 111, 'type': 'Meccan', 'start': 2030},
    {'id': 18, 'arabic': 'الكهف', 'name': 'Al-Kahf', 'english': 'The Cave', 'ayahs': 110, 'type': 'Meccan', 'start': 2141},
    {'id': 19, 'arabic': 'مريم', 'name': 'Maryam', 'english': 'Mary', 'ayahs': 98, 'type': 'Meccan', 'start': 2251},
    {'id': 20, 'arabic': 'طه', 'name': "Ta-Ha", 'english': 'Ta-Ha', 'ayahs': 135, 'type': 'Meccan', 'start': 2349},
    {'id': 21, 'arabic': 'الأنبياء', 'name': "Al-Anbiya'", 'english': 'The Prophets', 'ayahs': 112, 'type': 'Meccan', 'start': 2484},
    {'id': 22, 'arabic': 'الحج', 'name': 'Al-Hajj', 'english': 'The Pilgrimage', 'ayahs': 78, 'type': 'Medinan', 'start': 2596},
    {'id': 23, 'arabic': 'المؤمنون', 'name': "Al-Mu'minun", 'english': 'The Believers', 'ayahs': 118, 'type': 'Meccan', 'start': 2674},
    {'id': 24, 'arabic': 'النور', 'name': 'An-Nur', 'english': 'The Light', 'ayahs': 64, 'type': 'Medinan', 'start': 2792},
    {'id': 25, 'arabic': 'الفرقان', 'name': 'Al-Furqan', 'english': 'The Criterion', 'ayahs': 77, 'type': 'Meccan', 'start': 2856},
    {'id': 26, 'arabic': 'الشعراء', 'name': "Ash-Shu'ara'", 'english': 'The Poets', 'ayahs': 227, 'type': 'Meccan', 'start': 2933},
    {'id': 27, 'arabic': 'النمل', 'name': 'An-Naml', 'english': 'The Ant', 'ayahs': 93, 'type': 'Meccan', 'start': 3160},
    {'id': 28, 'arabic': 'القصص', 'name': 'Al-Qasas', 'english': 'The Stories', 'ayahs': 88, 'type': 'Meccan', 'start': 3253},
    {'id': 29, 'arabic': 'العنكبوت', 'name': 'Al-Ankabut', 'english': 'The Spider', 'ayahs': 69, 'type': 'Meccan', 'start': 3341},
    {'id': 30, 'arabic': 'الروم', 'name': 'Ar-Rum', 'english': 'The Romans', 'ayahs': 60, 'type': 'Meccan', 'start': 3410},
    {'id': 31, 'arabic': 'لقمان', 'name': 'Luqman', 'english': 'Luqman', 'ayahs': 34, 'type': 'Meccan', 'start': 3470},
    {'id': 32, 'arabic': 'السجدة', 'name': 'As-Sajdah', 'english': 'The Prostration', 'ayahs': 30, 'type': 'Meccan', 'start': 3504},
    {'id': 33, 'arabic': 'الأحزاب', 'name': 'Al-Ahzab', 'english': 'The Combined Forces', 'ayahs': 73, 'type': 'Medinan', 'start': 3534},
    {'id': 34, 'arabic': 'سبأ', 'name': "Saba'", 'english': 'Sheba', 'ayahs': 54, 'type': 'Meccan', 'start': 3607},
    {'id': 35, 'arabic': 'فاطر', 'name': 'Fatir', 'english': 'Originator', 'ayahs': 45, 'type': 'Meccan', 'start': 3661},
    {'id': 36, 'arabic': 'يس', 'name': 'Ya-Sin', 'english': 'Ya Sin', 'ayahs': 83, 'type': 'Meccan', 'start': 3706},
    {'id': 37, 'arabic': 'الصافات', 'name': 'As-Saffat', 'english': 'Those Who Set The Ranks', 'ayahs': 182, 'type': 'Meccan', 'start': 3789},
    {'id': 38, 'arabic': 'ص', 'name': 'Sad', 'english': 'The Letter Sad', 'ayahs': 88, 'type': 'Meccan', 'start': 3971},
    {'id': 39, 'arabic': 'الزمر', 'name': 'Az-Zumar', 'english': 'The Troops', 'ayahs': 75, 'type': 'Meccan', 'start': 4059},
    {'id': 40, 'arabic': 'غافر', 'name': 'Ghafir', 'english': 'The Forgiver', 'ayahs': 85, 'type': 'Meccan', 'start': 4134},
    {'id': 41, 'arabic': 'فصلت', 'name': 'Fussilat', 'english': 'Explained in Detail', 'ayahs': 54, 'type': 'Meccan', 'start': 4219},
    {'id': 42, 'arabic': 'الشورى', 'name': 'Ash-Shuraa', 'english': 'The Consultation', 'ayahs': 53, 'type': 'Meccan', 'start': 4273},
    {'id': 43, 'arabic': 'الزخرف', 'name': 'Az-Zukhruf', 'english': 'The Ornaments of Gold', 'ayahs': 89, 'type': 'Meccan', 'start': 4326},
    {'id': 44, 'arabic': 'الدخان', 'name': 'Ad-Dukhan', 'english': 'The Smoke', 'ayahs': 59, 'type': 'Meccan', 'start': 4415},
    {'id': 45, 'arabic': 'الجاثية', 'name': 'Al-Jathiyah', 'english': 'The Crouching', 'ayahs': 37, 'type': 'Meccan', 'start': 4474},
    {'id': 46, 'arabic': 'الأحقاف', 'name': 'Al-Ahqaf', 'english': 'The Wind-Curved Sandhills', 'ayahs': 35, 'type': 'Meccan', 'start': 4511},
    {'id': 47, 'arabic': 'محمد', 'name': 'Muhammad', 'english': 'Muhammad', 'ayahs': 38, 'type': 'Medinan', 'start': 4546},
    {'id': 48, 'arabic': 'الفتح', 'name': 'Al-Fath', 'english': 'The Victory', 'ayahs': 29, 'type': 'Medinan', 'start': 4584},
    {'id': 49, 'arabic': 'الحجرات', 'name': 'Al-Hujurat', 'english': 'The Rooms', 'ayahs': 18, 'type': 'Medinan', 'start': 4613},
    {'id': 50, 'arabic': 'ق', 'name': 'Qaf', 'english': 'The Letter Qaf', 'ayahs': 45, 'type': 'Meccan', 'start': 4631},
    {'id': 51, 'arabic': 'الذاريات', 'name': 'Adh-Dhariyat', 'english': 'The Winnowing Winds', 'ayahs': 60, 'type': 'Meccan', 'start': 4676},
    {'id': 52, 'arabic': 'الطور', 'name': 'At-Tur', 'english': 'The Mount', 'ayahs': 49, 'type': 'Meccan', 'start': 4736},
    {'id': 53, 'arabic': 'النجم', 'name': 'An-Najm', 'english': 'The Star', 'ayahs': 62, 'type': 'Meccan', 'start': 4785},
    {'id': 54, 'arabic': 'القمر', 'name': 'Al-Qamar', 'english': 'The Moon', 'ayahs': 55, 'type': 'Meccan', 'start': 4847},
    {'id': 55, 'arabic': 'الرحمن', 'name': 'Ar-Rahman', 'english': 'The Beneficent', 'ayahs': 78, 'type': 'Medinan', 'start': 4902},
    {'id': 56, 'arabic': 'الواقعة', 'name': "Al-Waqi'ah", 'english': 'The Inevitable', 'ayahs': 96, 'type': 'Meccan', 'start': 4980},
    {'id': 57, 'arabic': 'الحديد', 'name': 'Al-Hadid', 'english': 'The Iron', 'ayahs': 29, 'type': 'Medinan', 'start': 5076},
    {'id': 58, 'arabic': 'المجادلة', 'name': 'Al-Mujadila', 'english': 'The Pleading Woman', 'ayahs': 22, 'type': 'Medinan', 'start': 5105},
    {'id': 59, 'arabic': 'الحشر', 'name': 'Al-Hashr', 'english': 'The Exile', 'ayahs': 24, 'type': 'Medinan', 'start': 5127},
    {'id': 60, 'arabic': 'الممتحنة', 'name': 'Al-Mumtahanah', 'english': 'She That Is To Be Examined', 'ayahs': 13, 'type': 'Medinan', 'start': 5151},
    {'id': 61, 'arabic': 'الصف', 'name': 'As-Saf', 'english': 'The Ranks', 'ayahs': 14, 'type': 'Medinan', 'start': 5164},
    {'id': 62, 'arabic': 'الجمعة', 'name': "Al-Jumu'ah", 'english': 'The Congregation, Friday', 'ayahs': 11, 'type': 'Medinan', 'start': 5178},
    {'id': 63, 'arabic': 'المنافقون', 'name': 'Al-Munafiqun', 'english': 'The Hypocrites', 'ayahs': 11, 'type': 'Medinan', 'start': 5189},
    {'id': 64, 'arabic': 'التغابن', 'name': 'At-Taghabun', 'english': 'The Mutual Disillusion', 'ayahs': 18, 'type': 'Medinan', 'start': 5200},
    {'id': 65, 'arabic': 'الطلاق', 'name': 'At-Talaq', 'english': 'The Divorce', 'ayahs': 12, 'type': 'Medinan', 'start': 5218},
    {'id': 66, 'arabic': 'التحريم', 'name': 'At-Tahrim', 'english': 'The Prohibition', 'ayahs': 12, 'type': 'Medinan', 'start': 5230},
    {'id': 67, 'arabic': 'الملك', 'name': 'Al-Mulk', 'english': 'The Sovereignty', 'ayahs': 30, 'type': 'Meccan', 'start': 5242},
    {'id': 68, 'arabic': 'القلم', 'name': 'Al-Qalam', 'english': 'The Pen', 'ayahs': 52, 'type': 'Meccan', 'start': 5272},
    {'id': 69, 'arabic': 'الحاقة', 'name': 'Al-Haqqah', 'english': 'The Reality', 'ayahs': 52, 'type': 'Meccan', 'start': 5324},
    {'id': 70, 'arabic': 'المعارج', 'name': "Al-Ma'arij", 'english': 'The Ascending Stairways', 'ayahs': 44, 'type': 'Meccan', 'start': 5376},
    {'id': 71, 'arabic': 'نوح', 'name': 'Nuh', 'english': 'Noah', 'ayahs': 28, 'type': 'Meccan', 'start': 5420},
    {'id': 72, 'arabic': 'الجن', 'name': 'Al-Jinn', 'english': 'The Jinn', 'ayahs': 28, 'type': 'Meccan', 'start': 5448},
    {'id': 73, 'arabic': 'المزمل', 'name': 'Al-Muzzammil', 'english': 'The Enshrouded One', 'ayahs': 20, 'type': 'Meccan', 'start': 5476},
    {'id': 74, 'arabic': 'المدثر', 'name': 'Al-Muddaththir', 'english': 'The Cloaked One', 'ayahs': 56, 'type': 'Meccan', 'start': 5496},
    {'id': 75, 'arabic': 'القيامة', 'name': 'Al-Qiyamah', 'english': 'The Resurrection', 'ayahs': 40, 'type': 'Meccan', 'start': 5552},
    {'id': 76, 'arabic': 'الإنسان', 'name': 'Al-Insan', 'english': 'The Human', 'ayahs': 31, 'type': 'Medinan', 'start': 5592},
    {'id': 77, 'arabic': 'المرسلات', 'name': 'Al-Mursalat', 'english': 'The Emissaries', 'ayahs': 50, 'type': 'Meccan', 'start': 5623},
    {'id': 78, 'arabic': 'النبأ', 'name': "An-Naba'", 'english': 'The Tidings', 'ayahs': 40, 'type': 'Meccan', 'start': 5673},
    {'id': 79, 'arabic': 'النازعات', 'name': "An-Nazi'at", 'english': 'Those Who Drag Forth', 'ayahs': 46, 'type': 'Meccan', 'start': 5713},
    {'id': 80, 'arabic': 'عبس', 'name': 'Abasa', 'english': 'He Frowned', 'ayahs': 42, 'type': 'Meccan', 'start': 5759},
    {'id': 81, 'arabic': 'التكوير', 'name': 'At-Takwir', 'english': 'The Overthrowing', 'ayahs': 29, 'type': 'Meccan', 'start': 5801},
    {'id': 82, 'arabic': 'الانفطار', 'name': 'Al-Infitar', 'english': 'The Cleaving', 'ayahs': 19, 'type': 'Meccan', 'start': 5830},
    {'id': 83, 'arabic': 'المطففين', 'name': 'Al-Mutaffifin', 'english': 'The Defrauding', 'ayahs': 36, 'type': 'Meccan', 'start': 5849},
    {'id': 84, 'arabic': 'الانشقاق', 'name': 'Al-Inshiqaq', 'english': 'The Sundering', 'ayahs': 25, 'type': 'Meccan', 'start': 5885},
    {'id': 85, 'arabic': 'البروج', 'name': 'Al-Buruj', 'english': 'The Mansions of the Stars', 'ayahs': 22, 'type': 'Meccan', 'start': 5910},
    {'id': 86, 'arabic': 'الطارق', 'name': 'At-Tariq', 'english': 'The Nightcommer', 'ayahs': 17, 'type': 'Meccan', 'start': 5932},
    {'id': 87, 'arabic': 'الأعلى', 'name': "Al-A'la", 'english': 'The Most High', 'ayahs': 19, 'type': 'Meccan', 'start': 5949},
    {'id': 88, 'arabic': 'الغاشية', 'name': 'Al-Ghashiyah', 'english': 'The Overwhelming', 'ayahs': 26, 'type': 'Meccan', 'start': 5968},
    {'id': 89, 'arabic': 'الفجر', 'name': 'Al-Fajr', 'english': 'The Dawn', 'ayahs': 30, 'type': 'Meccan', 'start': 5994},
    {'id': 90, 'arabic': 'البلد', 'name': 'Al-Balad', 'english': 'The City', 'ayahs': 20, 'type': 'Meccan', 'start': 6024},
    {'id': 91, 'arabic': 'الشمس', 'name': 'Ash-Shams', 'english': 'The Sun', 'ayahs': 15, 'type': 'Meccan', 'start': 6044},
    {'id': 92, 'arabic': 'الليل', 'name': 'Al-Layl', 'english': 'The Night', 'ayahs': 21, 'type': 'Meccan', 'start': 6059},
    {'id': 93, 'arabic': 'الضحى', 'name': 'Ad-Duhaa', 'english': 'The Morning Hours', 'ayahs': 11, 'type': 'Meccan', 'start': 6080},
    {'id': 94, 'arabic': 'الشرح', 'name': 'Ash-Sharh', 'english': 'The Relief', 'ayahs': 8, 'type': 'Meccan', 'start': 6091},
    {'id': 95, 'arabic': 'التين', 'name': 'At-Tin', 'english': 'The Fig', 'ayahs': 8, 'type': 'Meccan', 'start': 6099},
    {'id': 96, 'arabic': 'العلق', 'name': "Al-'Alaq", 'english': 'The Clot', 'ayahs': 19, 'type': 'Meccan', 'start': 6107},
    {'id': 97, 'arabic': 'القدر', 'name': 'Al-Qadr', 'english': 'The Power', 'ayahs': 5, 'type': 'Meccan', 'start': 6126},
    {'id': 98, 'arabic': 'البينة', 'name': 'Al-Bayyinah', 'english': 'The Clear Proof', 'ayahs': 8, 'type': 'Medinan', 'start': 6131},
    {'id': 99, 'arabic': 'الزلزلة', 'name': 'Az-Zalzalah', 'english': 'The Earthquake', 'ayahs': 8, 'type': 'Medinan', 'start': 6139},
    {'id': 100, 'arabic': 'العاديات', 'name': "Al-'Adiyat", 'english': 'The Courser', 'ayahs': 11, 'type': 'Meccan', 'start': 6147},
    {'id': 101, 'arabic': 'القارعة', 'name': "Al-Qari'ah", 'english': 'The Calamity', 'ayahs': 11, 'type': 'Meccan', 'start': 6158},
    {'id': 102, 'arabic': 'التكاثر', 'name': 'At-Takathur', 'english': 'The Rivalry in World Increase', 'ayahs': 8, 'type': 'Meccan', 'start': 6169},
    {'id': 103, 'arabic': 'العصر', 'name': "Al-'Asr", 'english': 'The Declining Day', 'ayahs': 3, 'type': 'Meccan', 'start': 6177},
    {'id': 104, 'arabic': 'الهمزة', 'name': 'Al-Humazah', 'english': 'The Traducer', 'ayahs': 9, 'type': 'Meccan', 'start': 6180},
    {'id': 105, 'arabic': 'الفيل', 'name': 'Al-Fil', 'english': 'The Elephant', 'ayahs': 5, 'type': 'Meccan', 'start': 6189},
    {'id': 106, 'arabic': 'قريش', 'name': 'Quraysh', 'english': 'Quraysh', 'ayahs': 4, 'type': 'Meccan', 'start': 6194},
    {'id': 107, 'arabic': 'الماعون', 'name': "Al-Ma'un", 'english': 'The Small Kindnesses', 'ayahs': 7, 'type': 'Meccan', 'start': 6198},
    {'id': 108, 'arabic': 'الكوثر', 'name': 'Al-Kawthar', 'english': 'The Abundance', 'ayahs': 3, 'type': 'Meccan', 'start': 6205},
    {'id': 109, 'arabic': 'الكافرون', 'name': 'Al-Kafirun', 'english': 'The Disbelievers', 'ayahs': 6, 'type': 'Meccan', 'start': 6208},
    {'id': 110, 'arabic': 'النصر', 'name': 'An-Nasr', 'english': 'The Divine Support', 'ayahs': 3, 'type': 'Medinan', 'start': 6214},
    {'id': 111, 'arabic': 'المسد', 'name': 'Al-Masad', 'english': 'The Palm Fibre', 'ayahs': 5, 'type': 'Meccan', 'start': 6217},
    {'id': 112, 'arabic': 'الإخلاص', 'name': 'Al-Ikhlas', 'english': 'The Sincerity', 'ayahs': 4, 'type': 'Meccan', 'start': 6222},
    {'id': 113, 'arabic': 'الفلق', 'name': 'Al-Falaq', 'english': 'The Daybreak', 'ayahs': 5, 'type': 'Meccan', 'start': 6226},
    {'id': 114, 'arabic': 'الناس', 'name': 'An-Nas', 'english': 'The Mankind', 'ayahs': 6, 'type': 'Meccan', 'start': 6231},
  ];

  static Map<String, dynamic>? getSurahById(int id) {
    try {
      return surahs.firstWhere((s) => s['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static int getGlobalAyahNumber(int surahId, int ayahNumber) {
    final surah = getSurahById(surahId);
    if (surah == null) return ayahNumber;
    return (surah['start'] as int) + ayahNumber - 1;
  }

  static List<Map<String, dynamic>> search(String query) {
    final q = query.toLowerCase();
    return surahs.where((s) {
      return s['name'].toString().toLowerCase().contains(q) ||
          s['english'].toString().toLowerCase().contains(q) ||
          s['arabic'].toString().contains(query) ||
          s['id'].toString() == query;
    }).toList();
  }
}
