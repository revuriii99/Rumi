import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyDetailScreen extends StatelessWidget {
  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 320,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 48,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF5B2E91),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),

          Positioned.fill(
            top: 250,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFDECE6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rumah Kotak',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF241442),
                            ),
                          ),
                          Text(
                            'Kota Malang',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF5A31E1),
                            ),
                          ),
                          Text(
                            'Jl. Veteran No.8A, Penanggungan, Kec. Klojen',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF43187A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Sewa',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rp 15.000.000 ',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF241442),
                            ),
                          ),
                          TextSpan(
                            text: '/ Bulan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: Color(0xFFE2D6EE), height: 28),

                  Text(
                    'Deskripsi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rumah ini memiliki 3 kamar tidur yang luas, 2 kamar mandi modern, dan ruang tamu yang nyaman. Dilengkapi dengan dapur yang fungsional dan halaman belakang yang ideal untuk berkumpul. Terletak di kawasan strategis, dekat dengan pusat perbelanjaan dan sekolah. Cocok untuk keluarga yang mencari kenyamanan dan aksesibilitas.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF444444),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Spesifikasi Rumah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildSpecRow('Kamar Tidur', '3'),
                  _buildSpecRow('Kamar Mandi', '2'),
                  _buildSpecRow('Luas Tanah', '120 m²'),
                  _buildSpecRow('Luas Bangunan', '100 m²'),
                  _buildSpecRow('Tipe Properti', 'Rumah'),
                  _buildSpecRow('Alamat', 'Jl. Veteran No.8A'),
                  _buildSpecRow('Lokasi', 'Jawa Timur, Malang, Klojen'),
                  _buildSpecRow('Listrik', '10.000 Watt'),
                  _buildSpecRow('Sertifikat', 'Surat Hak Guna Bangun'),
                  _buildSpecRow('Hadap', 'Timur'),
                  _buildSpecRow('Furnished', 'Non - Furnished'),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
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
