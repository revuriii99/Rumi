import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/survey_journal_store.dart';

class SurveyFormScreen extends StatefulWidget {
  final Map<String, String> housing;

  const SurveyFormScreen({super.key, required this.housing});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final TextEditingController _dateCtrl = TextEditingController(
    text: '27/08/2026',
  );
  final TextEditingController _notesCtrl = TextEditingController();

  bool _isSaved = false;

  void _saveAndShowSummary() {
    SurveyJournalStore.addJournal({
      'title': widget.housing['title'] ?? 'Rumah Pilihan',
      'address': widget.housing['address'] ?? 'Kota Malang',
      'date': _dateCtrl.text,
      'notes': _notesCtrl.text.trim(),
      'lastEdited': 'Baru saja',
      'image': widget.housing['image'] ?? 'assets/images/rumahKotak.png',
    });

    setState(() {
      _isSaved = true;
    });
  }

  void _returnToInsight() {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);
  }

  @override
  Widget build(BuildContext context) {
    if (_isSaved) {
      return _buildSuccessSummary();
    }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.housing['title'] ?? 'Rumah Pilihan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF241442),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.housing['address'] ?? 'Kota Malang',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/images/rumiNgoding.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _buildAspectTile('Air & Toilet', Icons.water_drop_outlined),
                  const SizedBox(height: 10),
                  _buildAspectTile('Stopkontak', Icons.power_outlined),
                  const SizedBox(height: 10),
                  _buildAspectTile(
                    'Pencahayaan',
                    Icons.lightbulb_outline_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildAspectTile(
                    'Sinyal Seluler',
                    Icons.signal_cellular_alt_rounded,
                  ),
                  const SizedBox(height: 10),
                  _buildAspectTile(
                    'Kebocoran/Kerusakan',
                    Icons.home_repair_service_outlined,
                  ),
                  const SizedBox(height: 10),
                  _buildAspectTile('Ventilasi', Icons.air_rounded),
                  const SizedBox(height: 10),
                  _buildAspectTile(
                    'Lingkungan Sekitar',
                    Icons.location_city_rounded,
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Color(0xFF7E57C2),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tanggal Survei',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF241442),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8CAF6).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _dateCtrl,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF7E57C2),
                              size: 20,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD8CAF6).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText:
                                  'Ada hal lain yang perlu dicatat? (Misal: ibu kos ramah, jalan depan sempit)',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF7E57C2),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Foto Dokumentasi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF241442),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _saveAndShowSummary,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B124C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Simpan Jurnal',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAspectTile(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFDECE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF2B124C)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2B124C),
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF2B124C),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessSummary() {
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
                    onPressed: _returnToInsight,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                children: [
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/rumiHepi.svg',
                          height: 120,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Jurnal surveimu telah\ndisimpan!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Yuk lihat ringkasan jurnal survei mu!',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hasil Survei – ${widget.housing['title'] ?? 'Rumah Pilihan'}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              size: 14,
                              color: Color(0xFF555555),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _dateCtrl.text,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildResultAspectTile(
                    'Air & Toilet',
                    Icons.water_drop_outlined,
                    'Aman',
                  ),
                  const SizedBox(height: 8),
                  _buildResultAspectTile(
                    'Stopkontak',
                    Icons.power_outlined,
                    'Aman',
                  ),
                  const SizedBox(height: 8),
                  _buildResultAspectTile(
                    'Pencahayaan',
                    Icons.lightbulb_outline_rounded,
                    'Aman',
                  ),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit_note_rounded,
                              color: Color(0xFF7E57C2),
                              size: 20,
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
                          _notesCtrl.text.trim().isEmpty
                              ? 'Mungkin perlu tambah kipas angin besar atau AC'
                              : _notesCtrl.text.trim(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF444444),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _returnToInsight,
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
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultAspectTile(String title, IconData icon, String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFDECE6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF2B124C)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2B124C),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECE6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2B124C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
