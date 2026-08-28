import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/housing_data.dart';

class PropertyDetailScreen extends StatelessWidget {
  final HousingModel housing;

  const PropertyDetailScreen({super.key, required this.housing});

  String _formatPrice(int price) {
    final str = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $str';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: Stack(
        children: [
          // Gambar Banner Hunian Asli Sesuai Data
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 330,
            child: Image.asset(housing.image, fit: BoxFit.cover),
          ),

          // Gradient Overlay di atas gambar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 330,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),

          // Tombol Kembali
          Positioned(
            top: 48,
            left: 20,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF5B2E91),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),

          // Kontainer Detail Informasi Properti (Scrollable Bottom Card)
          Positioned(
            top: 260,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFDECE6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                children: [
                  // Judul & Badge Tipe
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          housing.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B124C),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          housing.type,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    housing.city,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF6B4EE6),
                    ),
                  ),
                  Text(
                    housing.address,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B6282),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_formatPrice(housing.price)} / Bulan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const Divider(height: 28, color: Color(0xFFE8D4CC)),

                  // Deskripsi
                  Text(
                    'Deskripsi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    housing.desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A4260),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Spesifikasi Rumah
                  Text(
                    'Spesifikasi Rumah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSpecRow('Kamar Tidur', '${housing.bedroom}'),
                  _buildSpecRow('Kamar Mandi', '${housing.bathroom}'),
                  _buildSpecRow('Luas Tanah', '${housing.landArea} m²'),
                  _buildSpecRow('Luas Bangunan', '${housing.buildingArea} m²'),
                  _buildSpecRow('Tipe Properti', housing.propertyType),
                  _buildSpecRow('Alamat', housing.address),
                  _buildSpecRow('Lokasi', housing.locationDetail),
                  _buildSpecRow('Listrik', housing.electricity),
                  _buildSpecRow('Sertifikat', housing.certificate),
                  _buildSpecRow('Hadap', housing.orientation),
                  _buildSpecRow('Furnished', housing.furnished),
                  const SizedBox(height: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 4.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B6282),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF241442),
            ),
          ),
        ],
      ),
    );
  }
}
