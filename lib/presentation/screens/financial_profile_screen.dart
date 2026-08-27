import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FinancialProfileScreen extends StatefulWidget {
  const FinancialProfileScreen({super.key});

  @override
  State<FinancialProfileScreen> createState() => _FinancialProfileScreenState();
}

class _FinancialProfileScreenState extends State<FinancialProfileScreen> {
  int _currentStep = 1;

  String _incomeAmount = '';

  final TextEditingController _transportController = TextEditingController();
  final TextEditingController _dailyNeedsController = TextEditingController();
  final TextEditingController _billsController = TextEditingController();

  int _transportValue = 0;
  int _dailyNeedsValue = 0;
  int _billsValue = 0;

  @override
  void dispose() {
    _transportController.dispose();
    _dailyNeedsController.dispose();
    _billsController.dispose();
    super.dispose();
  }

  void _onKeyPress(String value) {
    if (_incomeAmount.length >= 12) return;
    if (_incomeAmount.isEmpty && (value == '0' || value == '000')) return;
    setState(() {
      _incomeAmount += value;
    });
  }

  void _onBackspace() {
    if (_incomeAmount.isNotEmpty) {
      setState(() {
        _incomeAmount = _incomeAmount.substring(0, _incomeAmount.length - 1);
      });
    }
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'id',
      symbol: '',
      decimalDigits: 0,
    ).format(amount).trim();
  }

  void _parseExpense(String text, Function(int) onParsed) {
    final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
    final val = int.tryParse(clean) ?? 0;
    setState(() {
      onParsed(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int totalExpenses = _transportValue + _dailyNeedsValue + _billsValue;

    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_currentStep > 1) {
                        setState(() => _currentStep--);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF241442),
                      size: 26,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 26.0),
                        child: Text(
                          'Profil Finansial',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF241442),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentStep == 1
                              ? 'Yuk, kenalan sama\nkondisi keuanganmu!'
                              : 'Sekarang, biasanya\nuangmu pergi ke mana\naja?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E1E1E),
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStepPill(isActive: _currentStep >= 1),
                            const SizedBox(width: 6),
                            _buildStepPill(isActive: _currentStep >= 2),
                            const SizedBox(width: 6),
                            _buildStepPill(isActive: _currentStep >= 3),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentStep == 1
                              ? 'LANGKAH 1 DARI 3: PENDAPATAN'
                              : 'LANGKAH 2 DARI 3: PENGELUARAN',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF6B6282),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/rumiObervatif.svg',
                    height: 92,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: _currentStep == 1
                  ? _buildStepOneContent()
                  : _buildStepTwoContent(totalExpenses),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepOneContent() {
    final bool isEnabled =
        _incomeAmount.isNotEmpty && (int.tryParse(_incomeAmount) ?? 0) > 0;
    final String formattedText = _incomeAmount.isEmpty
        ? ''
        : _formatCurrency(int.parse(_incomeAmount));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(
            'Masukkan pendapatan bulanan kamu',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2E2E2E),
            ),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECE6),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  'Rp',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7A6F90),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        formattedText.isEmpty ? ' ' : formattedText,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF381566),
                        ),
                      ),
                      Container(
                        height: 2,
                        width: 170,
                        color: const Color(0xFFC0AEE8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          _buildKeypad(),
          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      setState(() => _currentStep = 2);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnabled
                    ? const Color(0xFF241442)
                    : const Color(0xFF241442).withOpacity(0.35),
                disabledBackgroundColor: const Color(
                  0xFF241442,
                ).withOpacity(0.35),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(0.7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: Text(
                'Selanjutnya',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStepTwoContent(int totalExpenses) {
    final bool isEnabled = totalExpenses > 0;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            children: [
              _buildExpenseCard(
                icon: Icons.directions_car_rounded,
                title: 'Transportasi',
                controller: _transportController,
                onChanged: (val) =>
                    _parseExpense(val, (num) => _transportValue = num),
              ),
              const SizedBox(height: 14),
              _buildExpenseCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Kebutuhan Sehari-hari',
                controller: _dailyNeedsController,
                onChanged: (val) =>
                    _parseExpense(val, (num) => _dailyNeedsValue = num),
              ),
              const SizedBox(height: 14),
              _buildExpenseCard(
                icon: Icons.receipt_long_rounded,
                title: 'Tagihan Rutin',
                subtitle: 'Listrik, air, internet, dan tagihan rutin lainnya',
                controller: _billsController,
                onChanged: (val) =>
                    _parseExpense(val, (num) => _billsValue = num),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
          decoration: const BoxDecoration(color: Color(0xFFD8CAF6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Pengeluaran Rutin',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2E2E2E),
                    ),
                  ),
                  Text(
                    'Rp ${totalExpenses == 0 ? '0' : _formatCurrency(totalExpenses)}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF241442),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isEnabled ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEnabled
                        ? const Color(0xFF241442)
                        : const Color(0xFF241442).withOpacity(0.35),
                    disabledBackgroundColor: const Color(
                      0xFF241442,
                    ).withOpacity(0.35),
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white.withOpacity(0.7),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    'Selanjutnya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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
    required IconData icon,
    required String title,
    String? subtitle,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9DAF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF43187A), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1E1E1E),
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF6B6282),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF7DECE).withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  'Rp',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B6282),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: onChanged,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF241442),
                    ),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black26,
                      ),
                      isDense: true,
                      border: InputBorder.none,
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

  Widget _buildStepPill({required bool isActive}) {
    return Container(
      width: 28,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF43187A) : const Color(0xFFB5A4DD),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        _buildKeypadRow(['1', '2', '3']),
        const SizedBox(height: 18),
        _buildKeypadRow(['4', '5', '6']),
        const SizedBox(height: 18),
        _buildKeypadRow(['7', '8', '9']),
        const SizedBox(height: 18),
        _buildKeypadRow(['000', '0', 'backspace']),
      ],
    );
  }

  Widget _buildKeypadRow(List<String> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: values.map((val) {
        if (val == 'backspace') {
          return InkWell(
            onTap: _onBackspace,
            borderRadius: BorderRadius.circular(30),
            child: const SizedBox(
              width: 70,
              height: 40,
              child: Center(
                child: Icon(
                  Icons.backspace_outlined,
                  color: Color(0xFF241442),
                  size: 22,
                ),
              ),
            ),
          );
        }

        return InkWell(
          onTap: () => _onKeyPress(val),
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            width: 70,
            height: 40,
            child: Center(
              child: Text(
                val,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: val == '000' ? 20 : 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF241442),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
