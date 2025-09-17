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
import 'package:iconsax/iconsax.dart';

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

          _showLoginAlert(
            context, 
            "Login Berhasil", 
            "Selamat Datang, ${userResponse.user.namaLengkap}!", 
            true,
            onConfirm: () {
              Get.offAll(() => NavBottom(userData: userResponse.user));
            }
          );
        } else {
          _showLoginAlert(context, "Login Gagal", "Terjadi kesalahan pada server. Silakan coba lagi.", false);
        }
      } else {
        final jsonData = jsonDecode(response.body);
        String errorMessage = jsonData['message'] ?? 'Email atau password salah. Silakan coba lagi.';
        _showLoginAlert(context, "Login Gagal", errorMessage, false);
      }
    } catch (e) {
      debugPrint("Terjadi error: $e");
      _showLoginAlert(context, "Error", "Terjadi kesalahan koneksi. Silakan coba lagi.", false);
    }
  }

  Future<void> logout(BuildContext context) async {
    _nik = null;
    Get.offAll(() => const LoginScreen());
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
        _showLoginAlert(context, "Registrasi Berhasil", jsonData['message'], true,
            onConfirm: () {
          Get.offAll(() => LoginScreen());
        });
      } else {
        if (jsonData.containsKey('errors')) {
          String errorMessage =
              jsonData['errors'].values.map((e) => e.join("\n")).join("\n");
          _showLoginAlert(context, "Registrasi Gagal", errorMessage, false);
        } else {
          _showLoginAlert(
              context, "Registrasi Gagal", jsonData['message'] ?? 'Registrasi gagal.', false);
        }
      }
    } catch (e) {
      debugPrint("Terjadi error: $e");
      _showLoginAlert(context, "Error", "Terjadi kesalahan, coba lagi nanti.", false);
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
        // Menggunakan Get.to untuk navigasi ke ChangePasswordPage
        Get.to(() => ChangePasswordPage(nik: jsonData['nik']));
      } else {
        _showLoginAlert(context, "Error", jsonData['message'], false);
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showLoginAlert(context, "Error", "Terjadi kesalahan, coba lagi nanti.", false);
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
        _showLoginAlert(context, "Sukses", jsonData['message'], true,
            onConfirm: () {
          // Menggunakan Get.offAll untuk navigasi ke LoginScreen
          Get.offAll(() => LoginScreen());
        });
      } else {
        _showLoginAlert(
            context, "Error", jsonData['message'] ?? 'Terjadi kesalahan.', false);
      }
    } catch (e) {
      debugPrint('Error: $e');
      _showLoginAlert(context, "Error", "Terjadi kesalahan, coba lagi nanti.", false);
    }
  }

  Future<UserData?> getProfile() async {
    try {
      String? nik = await SessionManager.getNik();

      if (nik == null) {
        debugPrint("NIK tidak ditemukan. Silakan login ulang.");
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
          debugPrint("Data profil tidak ditemukan.");
          return null;
        }
      } else {
        debugPrint("Gagal mengambil profil: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Terjadi kesalahan saat mengambil profil: $e");
      return null;
    }
  }

  static Future<bool> editProfile(
      BuildContext context, Map<String, dynamic> profileData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nik = prefs.getString('nik');

      if (nik == null) {
        _showLoginAlert(context, "Error", "NIK tidak ditemukan. Silakan login ulang.", false);
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
        _showLoginAlert(context, "Sukses", jsonData['message'], true);
        return true;
      } else {
        _showLoginAlert(
            context, "Error", jsonData['message'] ?? 'Gagal memperbarui profil.', false);
        return false;
      }
    } catch (e) {
      debugPrint("Terjadi error: $e");
      _showLoginAlert(context, "Error", "Terjadi kesalahan, coba lagi nanti.", false);
      return false;
    }
  }

  static void _showLoginAlert(BuildContext context, String title, String message, bool isSuccess, {VoidCallback? onConfirm}) {
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
                  isSuccess ? Iconsax.tick_circle : Iconsax.warning_2,
                  color: isSuccess ? const Color(0xFF199A8E) : Colors.amber,
                  size: 60,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF199A8E),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}