import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medical_app/auth/change_password.dart';
import 'package:medical_app/auth/login.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/utils/session_manager.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/services/connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  static String? _nik;
  String? getNik() => _nik;

  static Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final String apiUrl = "$apiConnect/api/auth/login";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey('message') && jsonData.containsKey('user')) {
          UserResponse userResponse = UserResponse.fromJson(jsonData);

          await SessionManager.setNik(userResponse.nik);

          _showMessageDialog(context, userResponse.message, userResponse.user);
        } else {
          _showLoginErrorDialog(context);
        }
      } else {
        _showLoginErrorDialog(context);
      }
    } catch (e) {
      print("Terjadi error: $e");
      _showLoginErrorDialog(context);
    }
  }

  Future<void> logout(BuildContext context) async {
    _nik = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  static Future<void> register(BuildContext context,
      {required String nik,
      required String namaLengkap,
      required String email,
      required String password}) async {
    try {
      final String apiUrl = "$apiConnect/api/auth/register";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'nama_lengkap': namaLengkap,
          'email': email,
          'password': password
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showCustomAlert(context, jsonData['message'], "success");
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        if (jsonData.containsKey('errors')) {
          String errorMessage =
              jsonData['errors'].values.map((e) => e.join("\n")).join("\n");
          _showCustomAlert(context, errorMessage, "error");
        } else {
          _showCustomAlert(
              context, jsonData['message'] ?? 'Registrasi gagal.', "error");
        }
      }
    } catch (e) {
      print("Terjadi error: $e");
      _showCustomAlert(context, "Terjadi kesalahan, coba lagi nanti.", "error");
    }
  }

  static Future<void> checkEmail(BuildContext context, String email) async {
    try {
      final String apiUrl = "$apiConnect/api/auth/check-email";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordPage(nik: jsonData['nik']),
          ),
        );
      } else {
        _showCustomAlert(context, jsonData['message'], "error");
      }
    } catch (e) {
      print('Error: $e');
      _showCustomAlert(context, "Terjadi kesalahan, coba lagi nanti.", "error");
    }
  }

  static Future<void> updatePassword(BuildContext context, String nik,
      String newPassword, String confirmPassword) async {
    try {
      final String apiUrl = "$apiConnect/api/auth/update-password";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'password': newPassword,
          'password_confirmation': confirmPassword,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showCustomAlert(context, jsonData['message'], "success");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        _showCustomAlert(
            context, jsonData['message'] ?? 'Terjadi kesalahan.', "error");
      }
    } catch (e) {
      print('Error: $e');
      _showCustomAlert(context, "Terjadi kesalahan, coba lagi nanti.", "error");
    }
  }

  Future<UserData?> getProfile() async {
    try {
      String? nik = await SessionManager.getNik();

      if (nik == null) {
        print("NIK tidak ditemukan. Silakan login ulang.");
        return null;
      }

      final String apiUrl = "$apiConnect/api/profile";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'nik': nik},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('data')) {
          return UserData.fromJson(jsonData['data']);
        } else {
          print("Data profil tidak ditemukan.");
          return null;
        }
      } else {
        print("Gagal mengambil profil: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil profil: $e");
      return null;
    }
  }

  static Future<bool> editProfile(
      BuildContext context, Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nik = prefs.getString('nik');

      if (nik == null) {
        _showCustomAlert(context, "NIK tidak ditemukan. Silakan login ulang.", "error");
        return false;
      }

      final String apiUrl = "$apiConnect/api/auth/edit-profile";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Nik': nik,
        },
        body: jsonEncode(profileData),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showCustomAlert(context, jsonData['message'], "success");
        return true;
      } else {
        _showCustomAlert(
            context, jsonData['message'] ?? 'Gagal memperbarui profil.', "error");
        return false;
      }
    } catch (e) {
      print("Terjadi error: $e");
      _showCustomAlert(context, "Terjadi kesalahan, coba lagi nanti.", "error");
      return false;
    }
  }
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
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
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

/// 🔔 Untuk login sukses (auto redirect)
void _showMessageDialog(
    BuildContext context, String message, UserData userData) {
  _showCustomAlert(context, '$message\nSelamat Datang, ${userData.namaLengkap}!', "success");

  Future.delayed(const Duration(seconds: 2), () {
    Get.off(() => NavBottom(userData: userData));
  });
}

void _showLoginErrorDialog(BuildContext context) {
  _showCustomAlert(context, 'Email atau password salah. Silakan coba lagi.', "error");
}
