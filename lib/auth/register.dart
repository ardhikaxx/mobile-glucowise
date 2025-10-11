import 'package:flutter/material.dart';
import 'package:medical_app/auth/login.dart';
import 'package:medical_app/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void registerButtonPressed(BuildContext context) async {
    if (_nikController.text.isEmpty ||
        _namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showCustomAlert(context, "Harap isi semua field!", "error");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showCustomAlert(
          context, "Password dan konfirmasi password tidak sama!", "error");
      return;
    }

    await AuthServices.register(
      context,
      nik: _nikController.text,
      namaLengkap: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/logo.png",
                width: 180,
                height: 180,
              ),
              const Text(
                "Buat Akun Anda",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'DarumadropOne',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                ),
              ),
              Text(
                "Lengkapi data berikut untuk membuat akun",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: _nikController,
                labelText: "NIK",
                prefixIcon: Icons.badge,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: _namaController,
                labelText: "Nama Lengkap",
                prefixIcon: Icons.person,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: _emailController,
                labelText: "Email",
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: _passwordController,
                labelText: "Kata Sandi",
                prefixIcon: Icons.lock,
                obscureText: !_showPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: const Color(0xFF199A8E),
                    _showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              _buildInputField(
                controller: _confirmPasswordController,
                labelText: "Ulangi Kata Sandi",
                prefixIcon: Icons.lock,
                obscureText: !_showConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: const Color(0xFF199A8E),
                    _showConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showConfirmPassword = !_showConfirmPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildRegisterButton(),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sudah memiliki akun? ",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Masuk Sekarang",
                      style: TextStyle(
                          color: Color(0xFF199A8E),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelText: labelText,
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
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

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          registerButtonPressed(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.white, size: 26),
            SizedBox(width: 3),
            Text(
              "Daftar Akun",
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomAlert(BuildContext context, String message, String type) {
    Color backgroundColor;
    IconData iconData;
    Color iconColor;

    switch (type) {
      case "error":
        backgroundColor = Colors.red.shade50;
        iconData = Icons.error_outline;
        iconColor = Colors.red;
        break;
      case "success":
        backgroundColor = Colors.green.shade50;
        iconData = Icons.check_circle_outline;
        iconColor = Colors.green;
        break;
      case "warning":
        backgroundColor = Colors.orange.shade50;
        iconData = Icons.warning_amber_outlined;
        iconColor = Colors.orange;
        break;
      default:
        backgroundColor = Colors.blue.shade50;
        iconData = Icons.info_outline;
        iconColor = Colors.blue;
    }

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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 60, color: iconColor),
                const SizedBox(height: 15),
                Text(
                  "Pesan",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF199A8E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
