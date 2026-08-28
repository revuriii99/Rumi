import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SurveyDetailScreen extends StatefulWidget {
  final Map<String, dynamic> journalData;

  const SurveyDetailScreen({super.key, required this.journalData});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  final Map<String, bool> _expandedState = {
    'Air & Toilet': false,
    'Stopkontak': false,
    'Pencahayaan': false,
    'Sinyal Seluler': false,
    'Kebocoran/Kerusakan': false,
    'Ventilasi': false,
    'Lingkungan Sekitar': false,
  };

  @override
  Widget build(BuildContext context) {
    final title = widget.journalData['title'] ?? 'Rumah Pilihan';
    final date = widget.journalData['date'] ?? '28/08/2026';
    final notes = widget.journalData['notes'] ?? '-';
    final docImagePath = widget.journalData['docImagePath'] as String?;

    final airMap =
        widget.journalData['airChecklist'] as Map<String, bool>? ??
        {'Air mengalir deras & jernih': true, 'Kloset berfungsi baik': true};
    final stopkontakMap =
        widget.journalData['stopkontakChecklist'] as Map<String, bool>? ??
        {'Jumlah stopkontak cukup': true, 'Daya listrik stabil': true};
    final pencahayaanMap =
        widget.journalData['pencahayaanChecklist'] as Map<String, bool>? ??
        {'Cahaya alami masuk siang hari': true, 'Ventilasi baik': true};

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header Top Bar
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
                        'Jurnal Survei',
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  // Card Judul Hasil Survei
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Survei – $title',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              size: 15,
                              color: Color(0xFF7E729C),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              date,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7E729C),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Kriteria Dinamis Checklist
                  _buildDynamicCategoryCard(
                    title: 'Air & Toilet',
                    icon: Icons.water_drop_outlined,
                    checklistMap: airMap,
                  ),
                  const SizedBox(height: 10),

                  _buildDynamicCategoryCard(
                    title: 'Stopkontak',
                    icon: Icons.power_outlined,
                    checklistMap: stopkontakMap,
                  ),
                  const SizedBox(height: 10),

                  _buildDynamicCategoryCard(
                    title: 'Pencahayaan',
                    icon: Icons.lightbulb_outline_rounded,
                    checklistMap: pencahayaanMap,
                  ),
                  const SizedBox(height: 10),

                  _buildStaticCategoryCard(
                    title: 'Sinyal Seluler',
                    icon: Icons.signal_cellular_alt_rounded,
                  ),
                  const SizedBox(height: 10),

                  _buildStaticCategoryCard(
                    title: 'Kebocoran/Kerusakan',
                    icon: Icons.home_repair_service_outlined,
                  ),
                  const SizedBox(height: 10),

                  _buildStaticCategoryCard(
                    title: 'Ventilasi',
                    icon: Icons.air_rounded,
                  ),
                  const SizedBox(height: 10),

                  _buildStaticCategoryCard(
                    title: 'Lingkungan Sekitar',
                    icon: Icons.holiday_village_outlined,
                  ),
                  const SizedBox(height: 14),

                  // Card Catatan Tambahan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              size: 18,
                              color: Color(0xFF43187A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Catatan Tambahan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF241442),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notes,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF555555),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Card Foto Dokumentasi (Jika Ada)
                  if (docImagePath != null &&
                      docImagePath.isNotEmpty &&
                      File(docImagePath).existsSync()) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDECE6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 18,
                                color: Color(0xFF43187A),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Foto Dokumentasi Survei',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(docImagePath),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  const SizedBox(height: 10),
                ],
              ),
            ),

            // Tombol Kembali
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Kembali',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card Kriteria Dinamis (Berdasarkan Checkbox Form)
  Widget _buildDynamicCategoryCard({
    required String title,
    required IconData icon,
    required Map<String, bool> checklistMap,
  }) {
    final total = checklistMap.length;
    final checked = checklistMap.values.where((v) => v).length;
    final isAllChecked = total > 0 && checked == total;
    final isExpanded = _expandedState[title] ?? false;

    final badgeText = isAllChecked
        ? 'Aman'
        : checked == 0
        ? 'Perlu Cek'
        : '$checked/$total Terpenuhi';

    final badgeBgColor = isAllChecked
        ? const Color(0xFFFDECE6)
        : const Color(0xFFFFEBEE);
    final badgeTextColor = isAllChecked
        ? const Color(0xFF241442)
        : const Color(0xFFC62828);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedState[title] = !isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDECE6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF241442), size: 17),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF241442),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                children: checklistMap.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3.0),
                    child: Row(
                      children: [
                        Icon(
                          entry.value
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          size: 15,
                          color: entry.value
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF241442),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Card Kriteria Statis (Aman)
  Widget _buildStaticCategoryCard({
    required String title,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFDECE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF241442), size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF241442),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECE6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Aman',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF241442),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
