import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_page_route.dart';
import 'survey_form_screen.dart';

class SelectHousingSurveyScreen extends StatefulWidget {
  const SelectHousingSurveyScreen({super.key});

  @override
  State<SelectHousingSurveyScreen> createState() =>
      _SelectHousingSurveyScreenState();
}

class _SelectHousingSurveyScreenState extends State<SelectHousingSurveyScreen> {
  int _selectedIndex = 0;

  final List<Map<String, String>> _savedHousings = [
    {
      'title': 'Rumah Kotak',
      'address': 'Jl. Veteran No.8A, Kota Malang',
      'price': 'Rp 15.000.000 / bulan',
      'image': 'assets/images/rumahKotak.png',
    },
    {
      'title': 'Rumah Nanas',
      'address': 'Jl. Jakarta No.8A, Kota Malang',
      'price': 'Rp 30.000.000 / bulan',
      'image': 'assets/images/rumahNanas.png',
    },
    {
      'title': 'Rumah Mawar',
      'address': 'Jl. Pagi No.8A, Kota Malang',
      'price': 'Rp 25.000.000 / bulan',
      'image': 'assets/images/rumahMawar.png',
    },
  ];

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
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 90.0,
                          top: 8.0,
                          bottom: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pilih Hunian',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF241442),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Hunian mana yang ingin kamu tulis jurnal survei nya?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF555555),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: -10,
                        top: -12,
                        child: SvgPicture.asset(
                          'assets/images/rumiObservatif.svg',
                          height: 105,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ...List.generate(_savedHousings.length, (index) {
                    final h = _savedHousings[index];
                    final isSelected = _selectedIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB5A4DD),
                          borderRadius: BorderRadius.circular(18),
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF2B124C),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                h['image']!,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF43187A),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'Sewa',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    h['title']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF241442),
                                    ),
                                  ),
                                  Text(
                                    h['address']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF555555),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    h['price']!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF241442),
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
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      SmoothPageRoute(
                        page: SurveyFormScreen(
                          housing: _savedHousings[_selectedIndex],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Lanjutkan',
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
}
