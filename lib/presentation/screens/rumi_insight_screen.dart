import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_page_route.dart';
import '../../data/mock/survey_journal_store.dart';
import 'select_housing_survey_screen.dart';
import 'survey_detail_screen.dart';
import 'rumi_insight_detail_screen.dart';

class RumiInsightScreen extends StatefulWidget {
  final int initialTabIndex;

  const RumiInsightScreen({super.key, this.initialTabIndex = 0});

  @override
  State<RumiInsightScreen> createState() => _RumiInsightScreenState();
}

class _RumiInsightScreenState extends State<RumiInsightScreen> {
  late int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex;
  }

  void _navigateToNewJournal() async {
    final result = await Navigator.push(
      context,
      SmoothPageRoute(page: const SelectHousingSurveyScreen()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  void _confirmDeleteJournal(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDECE6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Jurnal Survei?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF241442),
          ),
        ),
        content: Text(
          'Jurnal survei yang dihapus tidak dapat dikembalikan lagi.',
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
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6B6282),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                SurveyJournalStore.deleteJournal(index);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Jurnal survei berhasil dihapus',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: const Color(0xFF2B124C),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
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
                        onTap: () => setState(() => _tabIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tabIndex == 0
                                ? const Color(0xFF2B124C)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Belajar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: _tabIndex == 0
                                  ? Colors.white
                                  : const Color(0xFF241442),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _tabIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _tabIndex == 1
                                ? const Color(0xFF2B124C)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Jurnal Survei',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: _tabIndex == 1
                                  ? Colors.white
                                  : const Color(0xFF241442),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: _tabIndex == 0
                  ? _buildBelajarContent()
                  : _buildJurnalContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBelajarContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        _buildEduCard(
          title: 'KPR Tanpa Bikin Pusing Keliling',
          desc:
              'Kenali KPR, DP, bunga, dan cicilan sebelum memutuskan membeli rumah.',
          category: 'KPR',
          readTime: '3 menit baca',
          imagePath: 'assets/images/kpr1.png',
        ),
        const SizedBox(height: 14),
        _buildEduCard(
          title: 'Nabung Buat DP, Bukan Nahan Ngopi',
          desc:
              'Kenali KPR, DP, bunga, dan cicilan sebelum memutuskan membeli rumah.',
          category: 'Mencari Hunian',
          readTime: '3 menit baca',
          imagePath: 'assets/images/kpr2.png',
        ),
      ],
    );
  }

  Widget _buildEduCard({
    required String title,
    required String desc,
    required String category,
    required String readTime,
    required String imagePath,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          SmoothPageRoute(
            page: RumiInsightDetailScreen(
              title: title,
              category: category,
              readTime: readTime,
              imagePath: imagePath,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                imagePath,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF241442),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
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
                    category,
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
                  readTime,
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
                        title: title,
                        category: category,
                        readTime: readTime,
                        imagePath: imagePath,
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
      ),
    );
  }

  Widget _buildJurnalContent() {
    final list = SurveyJournalStore.journals;

    if (list.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: _navigateToNewJournal,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2B124C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Tulis Jurnal Baru',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
                SmoothPageRoute(page: SurveyDetailScreen(journalData: j)),
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
                          j['image'] ?? 'assets/images/rumahKotak.png',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: InkWell(
                          onTap: () => _confirmDeleteJournal(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          j['title'] ?? 'Rumah',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          j['address'] ?? 'Kota Malang',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF555555),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Disurvei: ${j['date'] ?? '-'}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF6B6282),
                              ),
                            ),
                            Text(
                              'Lihat Detail >',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF43187A),
                              ),
                            ),
                          ],
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
