import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/app_page_route.dart';
import '../../data/repositories/profile_repository.dart';
import 'main_navigation_screen.dart';

class RegisterSuccessScreen extends StatefulWidget {
  const RegisterSuccessScreen({super.key});

  @override
  State<RegisterSuccessScreen> createState() => _RegisterSuccessScreenState();
}

class _RegisterSuccessScreenState extends State<RegisterSuccessScreen> {
  final ProfileRepository _repo = ProfileRepository();

  // Step 0: Start, 1: Pendapatan, 2: Pengeluaran, 3: Dana Darurat, 4: Success
  int _currentStep = 0;

  // Form State
  String _incomeRaw = '';
  final TextEditingController _transportCtrl = TextEditingController();
  final TextEditingController _dailyNeedsCtrl = TextEditingController();
  final TextEditingController _billsCtrl = TextEditingController();

  bool _hasEmergencyFund = true;
  final TextEditingController _emergencyFundCtrl = TextEditingController();

  bool _isSubmitting = false;

  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  String _formatCurrency(int value) {
    return _currencyFormatter.format(value).trim();
  }

  int _parseAmount(String text) {
    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? 0;
  }

  // --- Numeric Keypad Handlers (Step 1) ---
  void _onKeypadTap(String value) {
    if (_incomeRaw.length >= 12) return;
    setState(() {
      if (value == '000') {
        if (_incomeRaw.isNotEmpty) _incomeRaw += '000';
      } else {
        _incomeRaw += value;
      }
    });
  }

  void _onKeypadBackspace() {
    if (_incomeRaw.isNotEmpty) {
      setState(() {
        _incomeRaw = _incomeRaw.substring(0, _incomeRaw.length - 1);
      });
    }
  }

  // --- Simpan ke Database Supabase ---
  Future<void> _saveAndFinish({bool skipEmergencyFund = false}) async {
    setState(() => _isSubmitting = true);

    final income = _parseAmount(_incomeRaw);
    final transport = _parseAmount(_transportCtrl.text);
    final daily = _parseAmount(_dailyNeedsCtrl.text);
    final bills = _parseAmount(_billsCtrl.text);
    final emergency = skipEmergencyFund || !_hasEmergencyFund
        ? 0
        : _parseAmount(_emergencyFundCtrl.text);

    try {
      await _repo.saveFinancialProfile({
        'monthly_income': income,
        'transportation': transport,
        'daily_needs': daily,
        'routine_bills': bills,
        'savings_target': emergency,
        'other_expenses': 0,
      });

      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _currentStep = 4; // Beralih ke layar siap digunakan
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _currentStep = 4; // Fallback tetap lanjut ke step sukses
        });
      }
    }
  }

  void _navigateToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      SmoothPageRoute(page: const MainNavigationScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(child: _buildCurrentStepView()),
    );
  }

  Widget _buildCurrentStepView() {
    switch (_currentStep) {
      case 0:
        return _buildStep0Start();
      case 1:
        return _buildStep1Income();
      case 2:
        return _buildStep2Expenses();
      case 3:
        return _buildStep3EmergencyFund();
      case 4:
        return _buildStep4Success();
      default:
        return _buildStep0Start();
    }
  }

  // ==========================================
  // STEP 0: START (Akun kamu berhasil dibuat!)
  // ==========================================
  Widget _buildStep0Start() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          SvgPicture.asset(
            'assets/images/maskotRumi.svg',
            height: 160,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 36),
          Text(
            'Akun kamu berhasil dibuat!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF241442),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Sekarang, yuk lengkapi profil keuanganmu biar RUMI bisa mulai bantu kamu cari hunian yang beneran cocok.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
                height: 1.4,
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => setState(() => _currentStep = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B124C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Lengkapi Sekarang',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _navigateToDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDECE6),
                foregroundColor: const Color(0xFF2B124C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Lewati',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 1: PENDAPATAN BULANAN
  // ==========================================
  Widget _buildStep1Income() {
    final incomeVal = int.tryParse(_incomeRaw) ?? 0;
    final formattedIncome = incomeVal > 0 ? _formatCurrency(incomeVal) : '';

    return Column(
      children: [
        _buildTopHeader(
          title: 'Yuk, kenalan sama kondisi keuanganmu!',
          stepIndex: 1,
          stepLabel: 'LANGKAH 1 DARI 3: PENDAPATAN',
          onBack: () => setState(() => _currentStep = 0),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECE6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Masukkan pendapatan bulanan kamu',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF6B6282),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Rp ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF241442),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formattedIncome.isEmpty ? '' : formattedIncome,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 1.5,
                  color: const Color(0xFF241442).withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        _buildNumericKeypad(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: incomeVal > 0
                  ? () => setState(() => _currentStep = 2)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B124C),
                disabledBackgroundColor: const Color(
                  0xFF2B124C,
                ).withOpacity(0.35),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Selanjutnya',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumericKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildKeypadBtn('1'),
              _buildKeypadBtn('2'),
              _buildKeypadBtn('3'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildKeypadBtn('4'),
              _buildKeypadBtn('5'),
              _buildKeypadBtn('6'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildKeypadBtn('7'),
              _buildKeypadBtn('8'),
              _buildKeypadBtn('9'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildKeypadBtn('000'),
              _buildKeypadBtn('0'),
              InkWell(
                onTap: _onKeypadBackspace,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 72,
                  height: 48,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.backspace_outlined,
                    color: Color(0xFF241442),
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypadBtn(String label) {
    return InkWell(
      onTap: () => _onKeypadTap(label),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 72,
        height: 48,
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF241442),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // STEP 2: PENGELUARAN RUTIN
  // ==========================================
  Widget _buildStep2Expenses() {
    final t = _parseAmount(_transportCtrl.text);
    final d = _parseAmount(_dailyNeedsCtrl.text);
    final b = _parseAmount(_billsCtrl.text);
    final totalExpenses = t + d + b;

    return Column(
      children: [
        _buildTopHeader(
          title: 'Sekarang, biasanya uangmu pergi ke mana aja?',
          stepIndex: 2,
          stepLabel: 'LANGKAH 2 DARI 3: PENGELUARAN',
          onBack: () => setState(() => _currentStep = 1),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: [
              _buildExpenseCard(
                title: 'Transportasi',
                icon: Icons.directions_car_filled_rounded,
                controller: _transportCtrl,
              ),
              const SizedBox(height: 12),
              _buildExpenseCard(
                title: 'Kebutuhan Sehari-hari',
                icon: Icons.shopping_bag_rounded,
                controller: _dailyNeedsCtrl,
              ),
              const SizedBox(height: 12),
              _buildExpenseCard(
                title: 'Tagihan Rutin',
                subtitle: 'Listrik, air, internet, dan tagihan rutin lainnya',
                icon: Icons.receipt_long_rounded,
                controller: _billsCtrl,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pengeluaran Rutin',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF555555),
                    ),
                  ),
                  Text(
                    'Rp ${_formatCurrency(totalExpenses)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => setState(() => _currentStep = 3),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Selanjutnya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseCard({
    required String title,
    String? subtitle,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFD8CAF6),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF241442)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF241442),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF777777),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD8CAF6).withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'Rp',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6B6282),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF241442),
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: '0',
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

  // ==========================================
  // STEP 3: DANA DARURAT
  // ==========================================
  Widget _buildStep3EmergencyFund() {
    return Column(
      children: [
        _buildTopHeader(
          title: 'Punya dana darurat saat ini?',
          stepIndex: 3,
          stepLabel: 'LANGKAH 3 DARI 3: DANA DARURAT',
          onBack: () => setState(() => _currentStep = 2),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEmergencyFund = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                      border: _hasEmergencyFund
                          ? Border.all(color: const Color(0xFF5A31E1), width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Color(0xFF5A31E1),
                          size: 24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Punya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5A31E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEmergencyFund = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECE6),
                      borderRadius: BorderRadius.circular(16),
                      border: !_hasEmergencyFund
                          ? Border.all(color: const Color(0xFF5A31E1), width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.money_off_rounded,
                          color: Color(0xFF5A31E1),
                          size: 24,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Belum punya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF5A31E1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (_hasEmergencyFund)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECE6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dana Darurat Saat Ini',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF6B6282),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Rp ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _emergencyFundCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: '10.000.000',
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 1.5,
                    color: const Color(0xFF241442).withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : () => _saveAndFinish(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B124C),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Simpan & Lanjut',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => _saveAndFinish(skipEmergencyFund: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDECE6),
                    foregroundColor: const Color(0xFF2B124C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Simpan & Lewati',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // STEP 4: SUCCESS (Profil Siap Digunakan!)
  // ==========================================
  Widget _buildStep4Success() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF6C38CC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 46,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Profil keuanganmu siap\ndigunakan!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF241442),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuk, cari rumah bersama Rumi!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF555555),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _navigateToDashboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2B124C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Ke Dashboard',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ==========================================
  // TOP BAR & PROGRESS BAR
  // ==========================================
  Widget _buildTopHeader({
    required String title,
    required int stepIndex,
    required String stepLabel,
    required VoidCallback onBack,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF241442),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'Profil Finansial',
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF241442),
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildProgressBarSegment(stepIndex >= 1),
                          const SizedBox(width: 6),
                          _buildProgressBarSegment(stepIndex >= 2),
                          const SizedBox(width: 6),
                          _buildProgressBarSegment(stepIndex >= 3),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        stepLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF6B6282),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  'assets/images/rumiObservatif.svg',
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBarSegment(bool isActive) {
    return Container(
      width: 28,
      height: 4.5,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF43187A) : const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
