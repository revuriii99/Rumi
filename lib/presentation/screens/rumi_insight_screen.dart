import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_page_route.dart';
import '../../data/mock/survey_journal_store.dart';
import 'rumi_insight_detail_screen.dart';
import 'select_housing_survey_screen.dart';
import 'survey_detail_screen.dart';

class RumiInsightScreen extends StatefulWidget {
  final bool initialTabJurnal;
  const RumiInsightScreen({super.key, this.initialTabJurnal = false});

  @override
  State<RumiInsightScreen> createState() => _RumiInsightScreenState();
}

class _RumiInsightScreenState extends State<RumiInsightScreen> {
  late bool _isBelajarTab;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'Semua',
    'Mencari Hunian',
    'KPR',
    'Keuangan',
  ];

  final List<Map<String, String>> _allModules = [
    {
      'title': 'KPR Tanpa Bikin Pusing Keliling',
      'desc':
          'Kenali KPR, DP, bunga, dan cicilan sebelum memutuskan membeli rumah.',
      'category': 'KPR',
      'readTime': '3 menit baca',
      'image': 'assets/images/kpr1.png',
    },
    {
      'title': 'Nabung Buat DP, Bukan Nahan Ngopi',
      'desc': 'Kenali strategi tabungan dan dana awal untuk hunian impianmu.',
      'category': 'Mencari Hunian',
      'readTime': '3 menit baca',
      'image': 'assets/images/kpr2.png',
    },
    {
      'title': 'Dompet Aman, Tidur Nyenyak',
      'desc':
          'Hitung rasio pengeluaran hunian agar keuangan bulanan tetap sehat.',
      'category': 'Keuangan',
      'readTime': '4 menit baca',
      'image': 'assets/images/kpr1.png',
    },
    {
      'title': 'Jodoh-Jodohan Sama Hunian',
      'desc':
          'Tips memilih lokasi, akses transportasi, dan lingkungan hunian tepat.',
      'category': 'Mencari Hunian',
      'readTime': '2 menit baca',
      'image': 'assets/images/kpr2.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _isBelajarTab = !widget.initialTabJurnal;
  }

  List<Map<String, String>> get _filteredModules {
    if (_selectedCategoryIndex == 0) {
      return _allModules;
    }
    final selectedCategory = _categories[_selectedCategoryIndex];
    return _allModules.where((m) => m['category'] == selectedCategory).toList();
  }

  Future<void> _navigateToNewJournal() async {
    await Navigator.push(
      context,
      SmoothPageRoute(page: const SelectHousingSurveyScreen()),
    );

    setState(() {
      _isBelajarTab = false;
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDECE6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Jurnal?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF241442),
          ),
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus jurnal survei ini?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF555555),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF555555),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                SurveyJournalStore.deleteJournal(index);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF241442),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'RumiInsight',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFB5A4DD),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBelajarTab = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isBelajarTab
                                ? const Color(0xFF43187A)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Belajar',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isBelajarTab = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isBelajarTab
                                ? const Color(0xFF43187A)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Jurnal Survei',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _isBelajarTab
                    ? _buildBelajarContent()
                    : _buildJurnalContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBelajarContent() {
    final displayedList = _filteredModules;

    return ListView(
      key: const ValueKey('BelajarContent'),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF241442)
                        : const Color(0xFFFDECE6),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      _categories[index],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF241442),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        if (displayedList.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Text(
                'Belum ada modul di kategori ini.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF555555),
                ),
              ),
            ),
          )
        else
          ...displayedList.map((m) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      m['image']!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    m['title']!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m['desc']!,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB5A4DD),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m['category']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF241442),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.access_time_rounded,
                        size: 13,
                        color: Color(0xFF555555),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        m['readTime']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          SmoothPageRoute(
                            page: RumiInsightDetailScreen(
                              title: m['title']!,
                              category: m['category']!,
                              readTime: m['readTime']!,
                              imagePath: m['image']!,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B124C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        'Baca',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildJurnalContent() {
    final list = SurveyJournalStore.journals;

    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            key: const ValueKey('EmptyJurnal'),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/rumiMikir.png',
                height: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              Text(
                'Belum Ada Jurnal Survei',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5B2E91),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Yuk tulis jurnal survei untuk mencatat hasil\nkunjunganmu ke suatu hunian!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF7E57C2),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: _navigateToNewJournal,
                  icon: const Icon(Icons.add_rounded, color: Colors.white),
                  label: Text(
                    'Tulis Jurnal Baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      key: const ValueKey('ListJurnal'),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: _navigateToNewJournal,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECE6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    size: 16,
                    color: Color(0xFF241442),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Buat Baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF241442),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(list.length, (index) {
          final j = list[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                SmoothPageRoute(page: SurveyDetailScreen(journal: j)),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: Image.asset(
                          j['image']!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECE6).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_rounded,
                                size: 12,
                                color: Color(0xFF241442),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                j['date']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                j['title']!,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 13,
                                    color: Color(0xFF555555),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    j['address']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF555555),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Terakhir diubah: ${j['lastEdited']!}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF777777),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => _showDeleteDialog(index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFFE53935),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
