import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/repositories/profile_repository.dart';

class FinancialProfileScreen extends StatefulWidget {
  const FinancialProfileScreen({super.key});

  @override
  State<FinancialProfileScreen> createState() => _FinancialProfileScreenState();
}

class _FinancialProfileScreenState extends State<FinancialProfileScreen> {
  final ProfileRepository _repo = ProfileRepository();

  final _incomeCtrl = TextEditingController();
  final _transportCtrl = TextEditingController();
  final _dailyCtrl = TextEditingController();
  final _billsCtrl = TextEditingController();
  final _savingsCtrl = TextEditingController();
  final _otherCtrl = TextEditingController();
  final _emergencyCtrl = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  @override
  void dispose() {
    _incomeCtrl.dispose();
    _transportCtrl.dispose();
    _dailyCtrl.dispose();
    _billsCtrl.dispose();
    _savingsCtrl.dispose();
    _otherCtrl.dispose();
    _emergencyCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFinancialData() async {
    final data = await _repo.getFinancialProfile();
    if (data != null && mounted) {
      setState(() {
        _incomeCtrl.text = (data['monthly_income'] ?? 0).toString();
        _transportCtrl.text = (data['transportation'] ?? 0).toString();
        _dailyCtrl.text = (data['daily_needs'] ?? 0).toString();
        _billsCtrl.text = (data['routine_bills'] ?? 0).toString();
        _savingsCtrl.text = (data['savings_target'] ?? 0).toString();
        _otherCtrl.text = (data['other_expenses'] ?? 0).toString();
        _emergencyCtrl.text = (data['emergency_fund'] ?? 0).toString();
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  int _parse(TextEditingController ctrl) {
    return int.tryParse(ctrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  }

  Future<void> _saveFinancialData() async {
    setState(() => _isSaving = true);
    try {
      await _repo.updateFinancialProfile({
        'monthly_income': _parse(_incomeCtrl),
        'transportation': _parse(_transportCtrl),
        'daily_needs': _parse(_dailyCtrl),
        'routine_bills': _parse(_billsCtrl),
        'savings_target': _parse(_savingsCtrl),
        'other_expenses': _parse(_otherCtrl),
        'emergency_fund': _parse(_emergencyCtrl),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil Finansial berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFD8CAF6),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF43187A)),
        ),
      );
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
                          label: 'Pendapatan Bulanan (Rp)',
                          controller: _incomeCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Transportasi (Rp)',
                          controller: _transportCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Kebutuhan Sehari-hari (Rp)',
                          controller: _dailyCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Tagihan Rutin (Listrik, Air, dll) (Rp)',
                          controller: _billsCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Target Tabungan (Rp)',
                          controller: _savingsCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Pengeluaran Lainnya (Rp)',
                          controller: _otherCtrl,
                        ),
                        const SizedBox(height: 12),
                        _buildField(
                          label: 'Dana Darurat (Opsional) (Rp)',
                          controller: _emergencyCtrl,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  onPressed: _isSaving ? null : _saveFinancialData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF43187A),
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
            keyboardType: TextInputType.number,
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
