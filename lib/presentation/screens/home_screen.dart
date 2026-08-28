import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/profile_repository.dart';
import 'financial_profile_screen.dart';
import 'rumi_insight_screen.dart';
import 'rumi_insight_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileRepository _repo = ProfileRepository();
  String _userName = 'Sobat RUMI';
  Map<String, dynamic>? _financialData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final profile = await _repo.getProfile();
    final financial = await _repo.getFinancialProfile();

    if (mounted) {
      setState(() {
        if (profile['full_name'] != null &&
            profile['full_name'].toString().trim().isNotEmpty) {
          _userName = profile['full_name'].toString().split(' ').first;
        } else {
          final email = Supabase.instance.client.auth.currentUser?.email;
          if (email != null) {
            _userName = email.split('@').first;
          }
        }
        _financialData = financial;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final int income = _financialData?['monthly_income'] ?? 5000000;
    const int sampleHousePrice = 1500000;

    final int transport = _financialData?['transportation'] ?? 0;
    final int daily = _financialData?['daily_needs'] ?? 0;
    final int bills = _financialData?['routine_bills'] ?? 0;
    final int savings = _financialData?['savings_target'] ?? 0;
    final int other = _financialData?['other_expenses'] ?? 0;

    final int totalExpenses = transport + daily + bills + savings + other;
    final int remainingMoney = income - (sampleHousePrice + totalExpenses);

    final double housingRatio = income > 0
        ? (sampleHousePrice / income) * 100
        : 0;
    final double dsrRatio = income > 0 ? (remainingMoney / income) * 100 : 0;

    Color statusBgColor = const Color(0xFFFBE7BE);
    Color statusTextColor = const Color(0xFF9E6500);
    Color statusDotColor = const Color(0xFFE89A00);
    String statusText = 'KUNING: Perlu Perhatian';

    if (housingRatio <= 30 && dsrRatio >= 20) {
      statusBgColor = const Color(0xFFC8E6C9);
      statusTextColor = const Color(0xFF2E7D32);
      statusDotColor = const Color(0xFF4CAF50);
      statusText = 'HIJAU: Keuangan Aman';
    } else if (housingRatio > 35 || remainingMoney < 0) {
      statusBgColor = const Color(0xFFFFCDD2);
      statusTextColor = const Color(0xFFC62828);
      statusDotColor = const Color(0xFFE53935);
      statusText = 'MERAH: Beban Tinggi';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF43187A)),
              )
            : RefreshIndicator(
                onRefresh: _loadDashboardData,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  children: [
                    Text(
                      'Halo $_userName!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF241442),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Siap menjelajah rumah bersama RUMI?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3B2E58),
                      ),
                    ),
                    const SizedBox(height: 18),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECE6),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 3.5,
                                      backgroundColor: statusDotColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      statusText,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: statusTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),

                              Text(
                                'Dukungan Keuangan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF241442),
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Rp${sampleHousePrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF5A31E1),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' / bulan',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMiniStat(
                                      title: 'Housing\nRatio',
                                      value:
                                          '${housingRatio.toStringAsFixed(0)}%',
                                      valueColor: const Color(0xFF241442),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildMiniStat(
                                      title: 'Sisa Keuangan',
                                      value:
                                          'Rp${remainingMoney.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                      valueColor: const Color(0xFF241442),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _buildMiniStat(
                                      title: 'DSR',
                                      value: '${dsrRatio.toStringAsFixed(0)}%',
                                      valueColor: const Color(0xFF2E7D32),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Color(0xFF43187A),
                                          width: 1.5,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                      child: Text(
                                        'Ganti Hunian',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF43187A),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        final updated = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const FinancialProfileScreen(),
                                          ),
                                        );
                                        if (updated == true)
                                          _loadDashboardData();
                                      },
                                      child: Text(
                                        'Lihat Detail',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF43187A),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -16,
                          right: 4,
                          child: SvgPicture.asset(
                            'assets/images/rumiObservatif.svg',
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43187A),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Belum nemu yang pas?',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Yuk, cari hunian lain yang lebih cocok dengan kebutuhan dan budgetmu.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.85),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFDECE6),
                                foregroundColor: const Color(0xFF381566),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Eksplorasi Hunian',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rekomendasi Modul',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RumiInsightScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Lihat Semua',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF43187A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _buildModuleCard(
                      title: 'KPR Tanpa Bikin Pusing Keliling',
                      desc:
                          'Kenali KPR, DP, bunga, dan cicilan sebelum memutuskan membeli rumah.',
                      category: 'KPR',
                      readTime: '3 menit baca',
                      imagePath: 'assets/images/kpr1.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RumiInsightDetailScreen(
                              title: 'KPR Tanpa Bikin Pusing Keliling',
                              category: 'KPR',
                              readTime: '3 menit baca',
                              imagePath: 'assets/images/kpr1.png',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    _buildModuleCard(
                      title: 'Nabung Buat DP, Bukan Nahan Ngopi',
                      desc:
                          'Kenali KPR, DP, bunga, dan cicilan sebelum memutuskan membeli rumah.',
                      category: 'Mencari Hunian',
                      readTime: '3 menit baca',
                      imagePath: 'assets/images/kpr2.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RumiInsightDetailScreen(
                              title: 'Nabung Buat DP, Bukan Nahan Ngopi',
                              category: 'Mencari Hunian',
                              readTime: '3 menit baca',
                              imagePath: 'assets/images/kpr2.png',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMiniStat({
    required String title,
    required String value,
    required Color valueColor,
  }) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5DE).withOpacity(0.8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            maxLines: 2,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B6282),
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard({
    required String title,
    required String desc,
    required String category,
    required String readTime,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B124C),
                  foregroundColor: Colors.white,
                  elevation: 0,
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
}
