import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/mock/survey_journal_store.dart';

class SurveyFormScreen extends StatefulWidget {
  final Map<String, String> housing;

  const SurveyFormScreen({super.key, required this.housing});

  @override
  State<SurveyFormScreen> createState() => _SurveyFormScreenState();
}

class _SurveyFormScreenState extends State<SurveyFormScreen> {
  final TextEditingController _notesCtrl = TextEditingController();
  DateTime? _selectedDate;
  File? _selectedImage; // Menyimpan file foto yang dipilih
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  bool _isAirExpanded = true;
  bool _isStopkontakExpanded = false;
  bool _isPencahayaanExpanded = false;

  final Map<String, bool> _airChecklist = {
    'Air mengalir deras & jernih': true,
    'Kloset berfungsi baik (tidak mampet)': false,
    'Saluran pembuangan lancar & tidak bau': true,
  };

  final Map<String, bool> _stopkontakChecklist = {
    'Jumlah stopkontak cukup di tiap ruangan': true,
    'Posisi stopkontak strategis & aman': false,
    'Daya listrik memadai (tidak sering jeglek)': false,
  };

  final Map<String, bool> _pencahayaanChecklist = {
    'Cahaya alami matahari masuk saat siang': true,
    'Ventilasi & sirkulasi udara baik': true,
    'Lampu & penerangan ruangan memadai': false,
  };

  Future<void> _pickImageSource() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFDECE6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Pilih Foto Dokumentasi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF241442),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_rounded,
                    color: Color(0xFF43187A),
                  ),
                  title: Text(
                    'Pilih dari Galeri',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final picked = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      setState(() => _selectedImage = File(picked.path));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF43187A),
                  ),
                  title: Text(
                    'Ambil Foto dari Kamera',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final picked = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (picked != null) {
                      setState(() => _selectedImage = File(picked.path));
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF43187A),
              onPrimary: Colors.white,
              onSurface: Color(0xFF241442),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveSurveyJournal() {
    setState(() => _isSaving = true);

    final dateStr = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    SurveyJournalStore.addJournal({
      'title': widget.housing['title'] ?? 'Rumah Survei',
      'address': widget.housing['address'] ?? 'Kota Malang',
      'date': dateStr,
      'lastEdited': 'Baru saja',
      'image': widget.housing['image'] ?? 'assets/images/rumahKotak.png',
      'docImagePath': _selectedImage?.path, // Path foto dokumentasi
      'notes': _notesCtrl.text.trim().isEmpty ? '-' : _notesCtrl.text.trim(),
      'airChecklist': Map<String, bool>.from(_airChecklist),
      'stopkontakChecklist': Map<String, bool>.from(_stopkontakChecklist),
      'pencahayaanChecklist': Map<String, bool>.from(_pencahayaanChecklist),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Jurnal survei berhasil disimpan! 🎉',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2B124C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : 'mm/dd/yyyy';

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
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
                  // Header
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 90.0,
                          top: 6.0,
                          bottom: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.housing['title'] ?? 'Rumah Kotak',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF241442),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.housing['address'] ??
                                  'Jl. Veteran No.8A, Kota Malang',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -4,
                        top: -10,
                        child: SvgPicture.asset(
                          'assets/images/rumiObservatif.svg',
                          height: 95,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _buildChecklistAccordion(
                    title: 'Air & Toilet',
                    icon: Icons.water_drop_outlined,
                    isExpanded: _isAirExpanded,
                    onToggle: () =>
                        setState(() => _isAirExpanded = !_isAirExpanded),
                    items: _airChecklist,
                  ),
                  const SizedBox(height: 12),

                  _buildChecklistAccordion(
                    title: 'Stopkontak',
                    icon: Icons.power_outlined,
                    isExpanded: _isStopkontakExpanded,
                    onToggle: () => setState(
                      () => _isStopkontakExpanded = !_isStopkontakExpanded,
                    ),
                    items: _stopkontakChecklist,
                  ),
                  const SizedBox(height: 12),

                  _buildChecklistAccordion(
                    title: 'Pencahayaan',
                    icon: Icons.lightbulb_outline_rounded,
                    isExpanded: _isPencahayaanExpanded,
                    onToggle: () => setState(
                      () => _isPencahayaanExpanded = !_isPencahayaanExpanded,
                    ),
                    items: _pencahayaanChecklist,
                  ),
                  const SizedBox(height: 16),

                  // Tanggal Survei Card
                  Container(
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
                              Icons.calendar_month_outlined,
                              size: 18,
                              color: Color(0xFF43187A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tanggal Survei',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF241442),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEADBCE).withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: _selectedDate != null
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: _selectedDate != null
                                        ? const Color(0xFF241442)
                                        : const Color(0xFF7E729C),
                                  ),
                                ),
                                const Icon(
                                  Icons.edit_calendar_rounded,
                                  size: 16,
                                  color: Color(0xFF43187A),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Catatan Tambahan Card
                  Container(
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
                              size: 20,
                              color: Color(0xFF43187A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Catatan Tambahan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF241442),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEADBCE).withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _notesCtrl,
                            maxLines: 3,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF241442),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Ada hal lain yang perlu dicatat? (Misal: ibu kos ramah, jalan depan sempit)',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7E729C),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Foto Dokumentasi Card (Bisa Di-tap & Ada Preview)
                  GestureDetector(
                    onTap: _pickImageSource,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8DBE5).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                                color: Color(0xFF43187A),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _selectedImage != null
                                    ? 'Foto Terpilih'
                                    : 'Foto Dokumentasi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                _selectedImage != null
                                    ? Icons.change_circle_outlined
                                    : Icons.add_photo_alternate_rounded,
                                size: 20,
                                color: const Color(0xFF43187A),
                              ),
                            ],
                          ),
                          if (_selectedImage != null) ...[
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.file(
                                    _selectedImage!,
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedImage = null),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Tombol Simpan Jurnal
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSurveyJournal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan Jurnal',
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

  Widget _buildChecklistAccordion({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Map<String, bool> items,
  }) {
    final checkedCount = items.values.where((v) => v).length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFDECE6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: const Color(0xFF241442), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        Text(
                          '$checkedCount dari ${items.length} item terpenuhi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.0 : 0.5,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Color(0xFF241442),
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: items.keys.map((itemTitle) {
                  final isChecked = items[itemTitle] ?? false;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        items[itemTitle] = !isChecked;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 4.0,
                      ),
                      child: Row(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? const Color(0xFF241442)
                                  : const Color(0xFFFDECE6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isChecked
                                    ? const Color(0xFF241442)
                                    : const Color(0xFF6B6282),
                                width: 1.5,
                              ),
                            ),
                            child: isChecked
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              itemTitle,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: isChecked
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: const Color(0xFF241442),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
          ),
        ],
      ),
    );
  }
}
