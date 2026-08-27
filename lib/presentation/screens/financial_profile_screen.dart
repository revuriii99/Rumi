import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinancialProfileScreen extends StatefulWidget {
  const FinancialProfileScreen({super.key});

  @override
  State<FinancialProfileScreen> createState() => _FinancialProfileScreenState();
}

class _FinancialProfileScreenState extends State<FinancialProfileScreen> {
  final _incomeController = TextEditingController(text: 'Rp 1.000');
  final _transportController = TextEditingController(text: 'Rp 1.000');
  final _dailyController = TextEditingController(text: 'Rp 1.000');
  final _billsController = TextEditingController(text: 'Rp 1.000');
  final _savingsTargetController = TextEditingController(text: 'Rp 1.000');
  final _otherExpenseController = TextEditingController(text: 'Rp 1.000');
  final _emergencyFundController = TextEditingController(text: 'Rp 1.000');

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profil Finansial',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                        ),
                      ),
                      Text(
                        'Update data keuanganmu',
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

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField(
                          label: 'Pendapatan Bulanan',
                          controller: _incomeController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Transportasi',
                          controller: _transportController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Kebutuhan Sehari-hari',
                          controller: _dailyController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Tagihan Rutin (Listrik, Air, Internet, dll)',
                          controller: _billsController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Target Tabungan',
                          controller: _savingsTargetController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Pengeluaran Lainnya',
                          controller: _otherExpenseController,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Dana Darurat (Opsional)',
                          controller: _emergencyFundController,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Lainnya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF381566),
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF9E84D0),
                                width: 1.2,
                              ),
                            ),
                            child: Text(
                              '+ Tambahkan Pengeluaran',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF7E57C2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Button Simpan
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
                    backgroundColor: const Color(0xFFB59BDD),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Simpan Perubahan',
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

  Widget _buildField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF381566),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF9E84D0), width: 1.2),
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF241442),
            ),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
