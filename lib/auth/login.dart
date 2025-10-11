import 'package:flutter/material.dart';
import 'package:medical_app/auth/forgot.dart';
import 'package:medical_app/auth/register.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _tampilkanPassword = false;
  bool _ingatSaya = false;
  late SharedPreferences _preferences;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _muatPreferensi();
  }

  Future<void> _muatPreferensi() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _ingatSaya = _preferences.getBool('ingatSaya') ?? false;
      if (_ingatSaya) {
        _emailController.text = _preferences.getString('email') ?? '';
      }
    });
  }

  Future<void> _simpanPreferensi() async {
    await _preferences.setBool('ingatSaya', _ingatSaya);
    if (_ingatSaya) {
      await _preferences.setString('email', _emailController.text);
    } else {
      await _preferences.remove('email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: _buildLingkaran(200, const Color(0xFFE8F3F1).withOpacity(0.8)),
          ),
          Positioned(
            bottom: 15,
            right: -40,
            child: _buildLingkaran(135, const Color(0xFFE8F3F1).withOpacity(0.5)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/logo.png", width: 180, height: 180),
                    const Text(
                      "Masuk Ke Akun Anda",
                      style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'DarumadropOne',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF199A8E)),
                    ),
                    Text(
                      "Untuk mengakses berbagai layanan",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 15),
                    _buildFieldInput(
                      controller: _emailController,
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _buildFieldInput(
                      controller: _passwordController,
                      labelText: "Kata Sandi",
                      prefixIcon: Icons.lock,
                      obscureText: !_tampilkanPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: const Color(0xFF199A8E),
                          _tampilkanPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _tampilkanPassword = !_tampilkanPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBarisIngatSaya(),
                    const SizedBox(height: 10),
                    _buildTombolMasuk(),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum Punya Akun?",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()));
                          },
                          child: const Text("Daftar Sekarang",
                              style: TextStyle(
                                  color: Color(0xFF199A8E),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLingkaran(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildFieldInput({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF199A8E)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF199A8E)),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: const Color(0xFFE5E7EB).withOpacity(0.5), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildBarisIngatSaya() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Checkbox(
                side: const BorderSide(color: Color(0xFF199A8E), width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0)),
                value: _ingatSaya,
                onChanged: (value) {
                  setState(() {
                    _ingatSaya = value!;
                    _simpanPreferensi();
                  });
                },
                activeColor: const Color(0xFF199A8E),
                checkColor: Colors.white,
              ),
              const Text(
                "Ingat Saya",
                style: TextStyle(
                  color: Color(0xFF199A8E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordPage(),
                ),
              );
            },
            child: const Text(
              "Lupa Kata Sandi?",
              style: TextStyle(
                color: Color(0xFF199A8E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTombolMasuk() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            String email = _emailController.text;
            String password = _passwordController.text;

            if (email.isEmpty && password.isEmpty) {
              _tampilkanPeringatanLogin(context, "Peringatan", "Email dan kata sandi tidak boleh kosong", false);
              return;
            } else if (email.isEmpty) {
              _tampilkanPeringatanLogin(context, "Peringatan", "Email tidak boleh kosong", false);
              return;
            } else if (password.isEmpty) {
              _tampilkanPeringatanLogin(context, "Peringatan", "Kata sandi tidak boleh kosong", false);
              return;
            }
            
            await AuthServices.login(context, email, password);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF199A8E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.login, size: 20, color: Colors.white),
              SizedBox(width: 6),
              Text("Masuk",style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _tampilkanPeringatanLogin(BuildContext context, String judul, String pesan, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.warning_rounded,
                  color: isSuccess ? const Color(0xFF199A8E) : Colors.amber,
                  size: 60,
                ),
                const SizedBox(height: 15),
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  pesan,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF199A8E),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      "MENGERTI",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}