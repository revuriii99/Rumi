import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/mock/housing_data.dart';

class RumiFinderScreen extends StatefulWidget {
  const RumiFinderScreen({super.key});

  @override
  State<RumiFinderScreen> createState() => _RumiFinderScreenState();
}

class _RumiFinderScreenState extends State<RumiFinderScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  List<HousingModel> _deck = [];
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _deck = List.from(HousingDataStore.sampleHousings);
  }

  void _onSwipe(bool isRight) {
    if (_deck.isEmpty) return;
    final swipedHousing = _deck.removeLast();

    if (isRight) {
      HousingDataStore.saveHousing(swipedHousing);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Yay! Kamu menyimpan ${swipedHousing.title} 🎉',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF2B124C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(milliseconds: 1400),
        ),
      );
    }

    setState(() {
      _dragOffset = Offset.zero;
      _isDragging = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD8CAF6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Text(
              'RumiFinder',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF241442),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDECE6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF241442),
                  ),
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF6B6282),
                      size: 22,
                    ),
                    hintText: 'Cari nama rumah atau daerah...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF8E82A8),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Swipe kanan untuk simpan, dan kiri untuk buang',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF43187A),
              ),
            ),
            const SizedBox(height: 14),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: _deck.isEmpty
                    ? _buildEmptyDeckState()
                    : Stack(
                        alignment: Alignment.center,
                        children: List.generate(_deck.length, (index) {
                          final isTopCard = index == _deck.length - 1;
                          final housing = _deck[index];

                          if (isTopCard) {
                            return _buildTopDraggableCard(housing);
                          }
                          return _buildBackgroundCard(housing);
                        }),
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDraggableCard(HousingModel housing) {
    final screenWidth = MediaQuery.of(context).size.width;
    final rotationAngle = (_dragOffset.dx / screenWidth) * 0.25;

    return GestureDetector(
      onPanStart: (_) => setState(() => _isDragging = true),
      onPanUpdate: (details) {
        setState(() {
          _dragOffset += details.delta;
        });
      },
      onPanEnd: (details) {
        if (_dragOffset.dx > 120) {
          _onSwipe(true);
        } else if (_dragOffset.dx < -120) {
          _onSwipe(false);
        } else {
          setState(() {
            _dragOffset = Offset.zero;
            _isDragging = false;
          });
        }
      },
      child: Transform.translate(
        offset: _dragOffset,
        child: Transform.rotate(
          angle: rotationAngle,
          child: _buildCardContent(housing, showSwipeIndicators: true),
        ),
      ),
    );
  }

  Widget _buildBackgroundCard(HousingModel housing) {
    return Transform.scale(
      scale: 0.95,
      child: _buildCardContent(housing, showSwipeIndicators: false),
    );
  }

  Widget _buildCardContent(
    HousingModel housing, {
    required bool showSwipeIndicators,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF241442).withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(housing.image, fit: BoxFit.cover),

            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      const Color(0xFF241442).withOpacity(0.6),
                      const Color(0xFF241442).withOpacity(0.92),
                    ],
                    stops: const [0.0, 0.45, 0.72, 1.0],
                  ),
                ),
              ),
            ),

            if (showSwipeIndicators && _isDragging) ...[
              if (_dragOffset.dx > 40)
                Positioned(
                  top: 24,
                  left: 20,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        'SIMPAN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              if (_dragOffset.dx < -40)
                Positioned(
                  top: 24,
                  right: 20,
                  child: Transform.rotate(
                    angle: 0.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Text(
                        'LEWATI',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],

            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF43187A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      housing.type,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    housing.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),

                  Text(
                    housing.address,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'Rp ${housing.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')} / bulan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: Icon(
                      Icons.keyboard_double_arrow_up_rounded,
                      color: Colors.white.withOpacity(0.6),
                      size: 26,
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

  Widget _buildEmptyDeckState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/rumiMikir.png', height: 130),
          const SizedBox(height: 16),
          Text(
            'Hunian Habis!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF241442),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kamu sudah mengeksplorasi semua hunian sampel.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B6282),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _deck = List.from(HousingDataStore.sampleHousings);
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: Text(
              'Muat Ulang Kartu',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF43187A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
