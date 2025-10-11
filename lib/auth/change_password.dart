import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/services/auth_services.dart';

class ChangePasswordPage extends StatefulWidget {
  final String nik;

  const ChangePasswordPage({super.key, required this.nik});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
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
          'Ubah Kata Sandi',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),
                      _buildImageWithBackground(),
                      const SizedBox(height: 20),
                      const Text(
                        "Ubah Kata Sandi Anda",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF199A8E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Masukkan kata sandi baru anda dibawah.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: newPasswordController,
                        labelText: "Kata Sandi Baru",
                        prefixIcon: Icons.lock,
                        obscureText: !_showNewPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            color: const Color(0xFF199A8E),
                            _showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                        labelText: "Ulangi Kata Sandi Baru",
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
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          String newPassword = newPasswordController.text;
          String confirmPassword = repeatPasswordController.text;

          if (newPassword.isEmpty || confirmPassword.isEmpty) {
            _showCustomAlert(context, "Harap isi semua field!", "error");
          } else if (newPassword != confirmPassword) {
            _showCustomAlert(
                context, "Konfirmasi password tidak sesuai!", "error");
          } else {
            AuthServices.updatePassword(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, size: 26, color: Colors.white),
            SizedBox(width: 3),
            Text(
              "Ubah Kata Sandi",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
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
                Icon(
                  iconData,
                  size: 60,
                  color: iconColor,
                ),
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
                  style: const TextStyle(
                    fontSize: 16,
                  ),
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
