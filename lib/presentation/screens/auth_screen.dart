import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';
import 'register_success_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool isRegisterInitial;

  const AuthScreen({super.key, this.isRegisterInitial = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late bool isRegister;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final AuthRepository _authRepository = AuthRepository();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Color _activeCardColor = const Color(0xFFEFEAFF);
  final Color _inactiveCardColor = const Color(0xFFC0AFF2);

  @override
  void initState() {
    super.initState();
    isRegister = widget.isRegisterInitial;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final fullName = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email dan kata sandi wajib diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (isRegister && fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap wajib diisi!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (isRegister) {
        await _authRepository.register(
          email: email,
          password: password,
          fullName: fullName,
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RegisterSuccessScreen(),
          ),
        );
      } else {
        await _authRepository.login(email: email, password: password);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil masuk!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.redAccent),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = isRegister
        ? const Color(0xFF1E1E1E)
        : const Color(0xFF18103A);
    final Color labelColor = isRegister
        ? const Color(0xFF555555)
        : const Color(0xFF382D5C);
    final Color iconColor = isRegister
        ? const Color(0xFF6B4EE6)
        : const Color(0xFF5535C8);
    final Color dividerColor = isRegister
        ? const Color(0xFF5A5A5A)
        : const Color(0xFF3E3068);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF6A4CE5),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Rumi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Pahami Perjalanannya, Temukan Tempat Tinggalmu',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.95),
                            height: 1.35,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 380,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: TweenAnimationBuilder<Color?>(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    tween: ColorTween(
                                      begin: isRegister
                                          ? _inactiveCardColor
                                          : _activeCardColor,
                                      end: isRegister
                                          ? _inactiveCardColor
                                          : _activeCardColor,
                                    ),
                                    builder: (context, color, child) {
                                      return ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          color ?? _inactiveCardColor,
                                          BlendMode.srcIn,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/masuk.svg',
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: 380,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Positioned.fill(
                                  child: TweenAnimationBuilder<Color?>(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    tween: ColorTween(
                                      begin: isRegister
                                          ? _activeCardColor
                                          : _inactiveCardColor,
                                      end: isRegister
                                          ? _activeCardColor
                                          : _inactiveCardColor,
                                    ),
                                    builder: (context, color, child) {
                                      return ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          color ?? _activeCardColor,
                                          BlendMode.srcIn,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/images/daftar.svg',
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: 380,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    28,
                                    24,
                                    28,
                                    20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildTabHeader(
                                            'Daftar',
                                            isRegister,
                                            () {
                                              setState(() => isRegister = true);
                                            },
                                          ),
                                          _buildTabHeader(
                                            'Masuk',
                                            !isRegister,
                                            () {
                                              setState(
                                                () => isRegister = false,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      AnimatedSize(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: isRegister
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 12.0,
                                                ),
                                                child: _buildInputField(
                                                  controller: _nameController,
                                                  label: 'Nama Lengkap',
                                                  hint: 'Adit Putra',
                                                  icon: Icons.person_rounded,
                                                  labelColor: labelColor,
                                                  textColor: textColor,
                                                  iconColor: iconColor,
                                                  dividerColor: dividerColor,
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                      _buildInputField(
                                        controller: _emailController,
                                        label: 'Email',
                                        hint: 'aditp@gmail.com',
                                        icon: Icons.mail_rounded,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        labelColor: labelColor,
                                        textColor: textColor,
                                        iconColor: iconColor,
                                        dividerColor: dividerColor,
                                      ),
                                      const SizedBox(height: 12),
                                      _buildInputField(
                                        controller: _passwordController,
                                        label: 'Kata Sandi',
                                        hint: '••••••••••••',
                                        icon: Icons.lock_rounded,
                                        isPassword: true,
                                        obscureText: _obscurePassword,
                                        labelColor: labelColor,
                                        textColor: textColor,
                                        iconColor: iconColor,
                                        dividerColor: dividerColor,
                                        onToggleVisibility: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                        },
                                      ),
                                      const Spacer(),
                                      Center(
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: Row(
                                            key: ValueKey<bool>(isRegister),
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                isRegister
                                                    ? 'Sudah Punya akun? '
                                                    : 'Belum Punya akun? ',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                        0xFF282828,
                                                      ),
                                                    ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () => isRegister =
                                                        !isRegister,
                                                  );
                                                },
                                                child: Text(
                                                  isRegister
                                                      ? 'Masuk di Sini'
                                                      : 'Daftar di Sini',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color(
                                                          0xFF1976D2,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -22,
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleAuth,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF241442),
                                  foregroundColor: Colors.white,
                                  elevation: 6,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 70,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Text(
                                          isRegister ? 'Daftar' : 'Masuk',
                                          key: ValueKey<bool>(isRegister),
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 3),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: 3,
            width: isActive ? 46 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFF5B3DE2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color labelColor,
    required Color textColor,
    required Color iconColor,
    required Color dividerColor,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: textColor.withOpacity(0.4),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isPassword)
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: textColor.withOpacity(0.8),
                ),
              ),
          ],
        ),
        Divider(color: dividerColor, thickness: 1.2, height: 4),
      ],
    );
  }
}
