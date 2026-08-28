import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_page_route.dart';
import '../../data/mock/housing_data.dart';
import 'property_detail_screen.dart';

class SavedHousingScreen extends StatefulWidget {
  const SavedHousingScreen({super.key});

  @override
  State<SavedHousingScreen> createState() => _SavedHousingScreenState();
}

class _SavedHousingScreenState extends State<SavedHousingScreen> {
  String _formatPrice(int price) {
    final str = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $str';
  }

  void _removeSavedItem(String id, String title) {
    setState(() {
      HousingDataStore.removeSavedHousing(id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title dihapus dari tersimpan',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2B124C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = HousingDataStore.savedHousings;

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hunian Tersimpan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                        ),
                      ),
                      Text(
                        'Lihat hunian impian yang kamu simpan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/rumiMikir.png',
                              height: 170,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum Ada Hunian Tersimpan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF5B2E91),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Swipe kanan hunian yang kamu suka di RumiFinder\nuntuk menyimpannya di sini!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF7E57C2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 8.0,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final house = list[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECE6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                SmoothPageRoute(
                                  page: PropertyDetailScreen(housing: house),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.asset(
                                      house.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          house.title,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF241442),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          house.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6B6282),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '${_formatPrice(house.price)} / bulan',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF5A31E1),
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        Row(
                                          children: [
                                            _buildBadge(
                                              label: 'Evaluasi ✓',
                                              bgColor: const Color(0xFFD7ECD9),
                                              textColor: const Color(
                                                0xFF2E7D32,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            _buildBadge(
                                              label: 'Survey ✓',
                                              bgColor: const Color(0xFFD7ECD9),
                                              textColor: const Color(
                                                0xFF2E7D32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () => _removeSavedItem(
                                          house.id,
                                          house.title,
                                        ),
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Color(0xFFE53935),
                                          size: 20,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF43187A),
                                        size: 22,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}
