import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/housing_data.dart';

class RumiFinderScreen extends StatefulWidget {
  const RumiFinderScreen({super.key});

  @override
  State<RumiFinderScreen> createState() => _RumiFinderScreenState();
}

class _RumiFinderScreenState extends State<RumiFinderScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  List<HousingModel> _filteredList = [];
  int _currentIndex = 0;

  // Swipe gesture & drag physics
  Offset _dragOffset = Offset.zero;
  late AnimationController _animController;
  Animation<Offset>? _flyAnimation;

  @override
  void initState() {
    super.initState();
    _filteredList = List.from(HousingDataStore.sampleHousings);
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          if (_flyAnimation != null) {
            setState(() {
              _dragOffset = _flyAnimation!.value;
            });
          }
        });

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_dragOffset.dx > 120) {
          final savedHouse = _filteredList[_currentIndex];
          HousingDataStore.saveHousing(savedHouse);
          _showSavedSuccessDialog(savedHouse.title);
        }
        setState(() {
          _currentIndex++;
          _dragOffset = Offset.zero;
          _flyAnimation = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final str = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return 'Rp $str';
  }

  void _filterHouses(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredList = List.from(HousingDataStore.sampleHousings);
      } else {
        _filteredList = HousingDataStore.sampleHousings.where((h) {
          final title = h.title.toLowerCase();
          final address = h.address.toLowerCase();
          final city = h.city.toLowerCase();
          final q = query.toLowerCase();
          return title.contains(q) || address.contains(q) || city.contains(q);
        }).toList();
      }
      _currentIndex = 0;
      _dragOffset = Offset.zero;
    });
  }

  // 1. POPUP DIALOG BERHASIL TAMBAH KE WISHLIST (SWIPE RIGHT)
  void _showSavedSuccessDialog(String houseTitle) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFFD8CAF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/maskotRumi.svg',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: const Color(0xFF241442),
                    height: 1.35,
                  ),
                  children: [
                    const TextSpan(text: 'Kamu berhasil menambahkan\n'),
                    TextSpan(
                      text: houseTitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' ke tersimpan'),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Lihat di Daftar Tersimpan nanti ya',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B4EE6),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EE6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Lanjutkan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 2. POPUP DIALOG EVALUASI BERHASIL DISIMPAN (FRAME FIGMA)
  void _showEvaluationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFFD8CAF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 36),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFF704BEA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 44,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Evaluasi Berhasil\nDisimpan',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1E1538),
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF704BEA),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Lanjutkan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. MODAL HASIL EVALUASI KEUANGAN DINAMIS (FRAME 313)
  void _showEvaluationModal(HousingModel house) {
    const int userIncome = 10000000;
    const int userExpenses = 2800000;
    final int rentPrice = house.price;

    final double housingRatio = userIncome > 0
        ? (rentPrice / userIncome) * 100
        : 0;
    final int totalMonthlyBurden = userExpenses + rentPrice;
    final int remainingCash = userIncome - totalMonthlyBurden;
    final double breathingRoomRatio = userIncome > 0
        ? (remainingCash / userIncome) * 100
        : 0;

    final String status;
    final String statusSubtitle;
    final Color statusColor;
    final String tipsRumi;

    if (housingRatio <= 30 && remainingCash > 0 && breathingRoomRatio >= 15) {
      status = 'HIJAU';
      statusSubtitle = 'Sangat Direkomendasikan';
      statusColor = const Color(0xFF2E7D32);
      tipsRumi =
          'Biaya hunian ini sangat ideal dan aman untuk kondisi finansialmu. Kamu masih memiliki cadangan kas dan ruang bernapas yang cukup setiap bulannya.';
    } else if (housingRatio <= 40 && remainingCash >= 0) {
      status = 'KUNING';
      statusSubtitle = 'Waspada / Perlu Penyesuaian';
      statusColor = const Color(0xFFF57C00);
      tipsRumi =
          'Biaya hunian ini masih dapat ditoleransi, namun porsi pengeluaranmu cukup ketat. Kurangi pengeluaran non-primer jika memilih hunian ini.';
    } else {
      status = 'MERAH';
      statusSubtitle = 'Tidak Disarankan';
      statusColor = const Color(0xFFE53935);
      tipsRumi =
          'Biaya hunian ini terlalu besar untuk pendapatanmu saat ini (${housingRatio.toStringAsFixed(0)}% dari pendapatan). Sangat disarankan mencari hunian dengan harga sewa yang lebih terjangkau.';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        decoration: const BoxDecoration(
          color: Color(0xFFD8CAF6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFC0AFF2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            house.image,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                house.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_formatPrice(house.price)} / bulan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF6B4EE6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Hasil Evaluasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildEvaluationRow(
                          label: 'Housing Ratio',
                          value: '${housingRatio.toStringAsFixed(0)}%',
                          valueColor: housingRatio > 35
                              ? const Color(0xFFE53935)
                              : const Color(0xFF241442),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2D7F7)),
                        _buildEvaluationRow(
                          label: 'Sisa Keuangan',
                          value: remainingCash < 0
                              ? '- ${_formatPrice(remainingCash.abs())}'
                              : _formatPrice(remainingCash),
                          valueColor: remainingCash < 0
                              ? const Color(0xFFE53935)
                              : const Color(0xFF2E7D32),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2D7F7)),
                        _buildEvaluationRow(
                          label: 'Breathing Room Ratio',
                          value: '${breathingRoomRatio.toStringAsFixed(0)}%',
                          valueColor: breathingRoomRatio < 0
                              ? const Color(0xFFE53935)
                              : const Color(0xFF241442),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          status,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          statusSubtitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tips RUMI',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tipsRumi,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4A4260),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Rincian Perhitungan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Komponen',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                              Text(
                                'Jumlah',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2D7F7)),
                        _buildCalculationDetailRow(
                          'Pendapatan Bulanan',
                          _formatPrice(userIncome),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2D7F7)),
                        _buildCalculationDetailRow(
                          'Pengeluaran Rutin',
                          _formatPrice(userExpenses),
                        ),
                        const Divider(height: 1, color: Color(0xFFE2D7F7)),
                        _buildCalculationDetailRow(
                          'Biaya Sewa Hunian',
                          _formatPrice(rentPrice),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF704BEA),
                          foregroundColor: Colors.white,
                          elevation: 0,
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
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          HousingDataStore.saveHousing(house);
                          Navigator.pop(ctx);
                          _showEvaluationSuccessDialog();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF704BEA),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(
                          'Simpan Hunian',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
  }

  Widget _buildEvaluationRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF241442),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A4260),
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

  // 4. MODAL BOTTOM SHEET DESKRIPSI & SPESIFIKASI PROPERTI (SWIPE UP)
  void _showPropertyDetailSheet(HousingModel house) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFFF3EFFF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFC0AFF2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          house.title,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B124C),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          house.type,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    house.city,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  Text(
                    house.address,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B6282),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_formatPrice(house.price)} / Bulan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const Divider(height: 28, color: Color(0xFFD8CAF6)),
                  Text(
                    'Deskripsi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    house.desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF4A4260),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Spesifikasi Rumah',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSpecRow('Kamar Tidur', '${house.bedroom}'),
                  _buildSpecRow('Kamar Mandi', '${house.bathroom}'),
                  _buildSpecRow('Luas Tanah', '${house.landArea} m²'),
                  _buildSpecRow('Luas Bangunan', '${house.buildingArea} m²'),
                  _buildSpecRow('Tipe Properti', house.propertyType),
                  _buildSpecRow('Alamat', house.address),
                  _buildSpecRow('Lokasi', house.locationDetail),
                  _buildSpecRow('Listrik', house.electricity),
                  _buildSpecRow('Sertifikat', house.certificate),
                  _buildSpecRow('Hadap', house.orientation),
                  _buildSpecRow('Furnished', house.furnished),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _showEvaluationModal(house);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EE6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Evaluasi Keuangan',
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

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B6282),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF241442),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasItem = _currentIndex < _filteredList.length;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 16.0),
          child: Column(
            children: [
              Text(
                'RumiFinder',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF241442),
                ),
              ),
              const SizedBox(height: 12),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEAFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _filterHouses,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF241442),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari nama rumah atau daerah...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      color: const Color(0xFF7E729C),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7E729C),
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                'Swipe kanan untuk simpan, dan kiri untuk buang',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF381566),
                ),
              ),
              const SizedBox(height: 14),

              // Full Swipe-Only Card Area
              Expanded(
                child: hasItem
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (_currentIndex + 1 < _filteredList.length)
                            Positioned.fill(
                              child: Transform.scale(
                                scale:
                                    0.94 +
                                    (math.min(1.0, _dragOffset.dx.abs() / 400) *
                                        0.06),
                                child: _buildCardContent(
                                  _filteredList[_currentIndex + 1],
                                  isFront: false,
                                ),
                              ),
                            ),
                          Positioned.fill(
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                if (_animController.isAnimating) return;
                                setState(() {
                                  _dragOffset += details.delta;
                                });
                              },
                              onPanEnd: (details) {
                                if (_animController.isAnimating) return;
                                final velocityX =
                                    details.velocity.pixelsPerSecond.dx;
                                final velocityY =
                                    details.velocity.pixelsPerSecond.dy;

                                if (velocityY < -600 &&
                                    _dragOffset.dx.abs() < 90) {
                                  setState(() => _dragOffset = Offset.zero);
                                  _showPropertyDetailSheet(
                                    _filteredList[_currentIndex],
                                  );
                                  return;
                                }

                                if (_dragOffset.dx > screenWidth * 0.32 ||
                                    velocityX > 700) {
                                  _flyAnimation =
                                      Tween<Offset>(
                                        begin: _dragOffset,
                                        end: Offset(
                                          screenWidth * 1.5,
                                          _dragOffset.dy,
                                        ),
                                      ).animate(
                                        CurvedAnimation(
                                          parent: _animController,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      );
                                  _animController.forward(from: 0);
                                } else if (_dragOffset.dx <
                                        -screenWidth * 0.32 ||
                                    velocityX < -700) {
                                  _flyAnimation =
                                      Tween<Offset>(
                                        begin: _dragOffset,
                                        end: Offset(
                                          -screenWidth * 1.5,
                                          _dragOffset.dy,
                                        ),
                                      ).animate(
                                        CurvedAnimation(
                                          parent: _animController,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      );
                                  _animController.forward(from: 0);
                                } else {
                                  _flyAnimation =
                                      Tween<Offset>(
                                        begin: _dragOffset,
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: _animController,
                                          curve: Curves.elasticOut,
                                        ),
                                      );
                                  _animController.forward(from: 0);
                                }
                              },
                              child: Transform.translate(
                                offset: _dragOffset,
                                child: Transform.rotate(
                                  angle: _dragOffset.dx * 0.0008,
                                  child: Stack(
                                    children: [
                                      _buildCardContent(
                                        _filteredList[_currentIndex],
                                        isFront: true,
                                      ),
                                      if (_dragOffset.dx > 20)
                                        Positioned(
                                          top: 24,
                                          left: 24,
                                          child: Transform.rotate(
                                            angle: -0.2,
                                            child: Opacity(
                                              opacity: math.min(
                                                1.0,
                                                _dragOffset.dx / 120,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFF4CAF50,
                                                    ),
                                                    width: 3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                                child: Text(
                                                  'SUKA',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: const Color(
                                                          0xFF4CAF50,
                                                        ),
                                                        letterSpacing: 1.5,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (_dragOffset.dx < -20)
                                        Positioned(
                                          top: 24,
                                          right: 24,
                                          child: Transform.rotate(
                                            angle: 0.2,
                                            child: Opacity(
                                              opacity: math.min(
                                                1.0,
                                                _dragOffset.dx.abs() / 120,
                                              ),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 6,
                                                    ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE53935,
                                                    ),
                                                    width: 3,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                                child: Text(
                                                  'LEWAT',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: const Color(
                                                          0xFFE53935,
                                                        ),
                                                        letterSpacing: 1.5,
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
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/maskotRumi.svg',
                              height: 110,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Semua hunian telah dijelajahi!',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF241442),
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _currentIndex = 0;
                                  _dragOffset = Offset.zero;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2B124C),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Jelajahi Ulang',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(HousingModel house, {required bool isFront}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFB5A4DD), width: 2),
        image: DecorationImage(
          image: AssetImage(house.image),
          fit: BoxFit.cover,
        ),
        boxShadow: isFront
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.15),
                    const Color(0xFF381566).withOpacity(0.9),
                  ],
                  stops: const [0.45, 0.68, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 18,
            right: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B124C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    house.type,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  house.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  house.address,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_formatPrice(house.price)} / bulan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () => _showPropertyDetailSheet(house),
                    child: const Icon(
                      Icons.keyboard_double_arrow_up_rounded,
                      color: Color(0xFFC0AFF2),
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
