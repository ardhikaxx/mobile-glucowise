import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:quickalert/quickalert.dart';

class ChangePasswordPage extends StatefulWidget {
  final String nik;

  const ChangePasswordPage({super.key, required this.nik});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _showNewPassword = false;
  bool _showRepeatPassword = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildImageWithBackground(),
              const SizedBox(height: 20),
              const Text(
                "Ubah Password Anda",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Masukkan password baru Anda di bawah.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: newPasswordController,
                labelText: "Password Baru",
                prefixIcon: Icons.lock,
                obscureText: !_showNewPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: const Color(0xFF199A8E),
                    _showNewPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showNewPassword = !_showNewPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: repeatPasswordController,
                labelText: "Ulangi Password Baru",
                prefixIcon: Icons.lock,
                obscureText: !_showRepeatPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: const Color(0xFF199A8E),
                    _showRepeatPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _showRepeatPassword = !_showRepeatPassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              _buildChangePasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWithBackground() {
    return Container(
      width: 180,
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFFE8F3F1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          'assets/Key.png',
          width: 120,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
    required IconButton suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
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
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF199A8E)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF199A8E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF199A8E), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFFE5E7EB).withOpacity(0.5),
              width: 1.5,
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            String newPassword = newPasswordController.text;
            String confirmPassword = repeatPasswordController.text;

            if (newPassword.isEmpty || confirmPassword.isEmpty) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Harap isi semua field!",
              );
            } else if (newPassword != confirmPassword) {
              QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: "Password tidak cocok!",
              );
            } else {
              AuthServices.changePassword(
                  context, widget.nik, newPassword, confirmPassword);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF199A8E),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
          ),
          child: const Text(
            "Ubah",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}