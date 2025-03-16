import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medical_app/auth/change_password.dart';
import 'package:medical_app/auth/login.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:quickalert/quickalert.dart';
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

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('nik', userResponse.nik);

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
        _showSuccessDialog(context, jsonData['message']);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        if (jsonData.containsKey('errors')) {
          String errorMessage =
              jsonData['errors'].values.map((e) => e.join("\n")).join("\n");
          _showErrorDialog(context, errorMessage);
        } else {
          _showErrorDialog(context, jsonData['message'] ?? 'Registrasi gagal.');
        }
      }
    } catch (e) {
      print("Terjadi error: $e");
      _showErrorDialog(context, "Terjadi kesalahan, coba lagi nanti.");
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
        _showErrorDialog(context, jsonData['message']);
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(context, "Terjadi kesalahan, coba lagi nanti.");
    }
  }

  static Future<void> changePassword(BuildContext context, String nik,
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: jsonData['message'],
          confirmBtnText: 'OK',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal',
          text: jsonData['message'] ?? 'Terjadi kesalahan, coba lagi nanti.',
          confirmBtnText: 'OK',
        );
      }
    } catch (e) {
      print('Error: $e');
      QuickAlert.show(
        // ignore: use_build_context_synchronously
        context: context,
        type: QuickAlertType.error,
        title: 'Gagal',
        text: 'Terjadi kesalahan, coba lagi nanti.',
        confirmBtnText: 'OK',
      );
    }
  }

  Future<UserData?> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? nik = prefs.getString('nik');

      if (nik == null) {
        print("NIK tidak ditemukan. Silakan login ulang.");
        return null;
      }

      final String apiUrl = "$apiConnect/api/auth/profile";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'nik': nik},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return UserData.fromJson(jsonData['data']);
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
        _showErrorDialog(context, "NIK tidak ditemukan. Silakan login ulang.");
        return false; // Return false jika NIK tidak ditemukan
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Berhasil',
          text: jsonData['message'],
          confirmBtnText: 'OK',
          onConfirmBtnTap: () => Navigator.pop(context),
        );
        return true;
      } else {
        _showErrorDialog(
            context, jsonData['message'] ?? 'Gagal memperbarui profil.');
        return false; // Return false jika gagal
      }
    } catch (e) {
      print("Terjadi error: $e");
      _showErrorDialog(context, "Terjadi kesalahan, coba lagi nanti.");
      return false; // Return false jika terjadi error
    }
  }
}

void _showSuccessDialog(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: 'Berhasil',
    text: message,
    confirmBtnText: 'OK',
  );
}

void _showErrorDialog(BuildContext context, String message) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: 'Gagal',
    text: message,
    confirmBtnText: 'OK',
  );
}

void _showMessageDialog(
    BuildContext context, String message, UserData userData) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: 'Login Berhasil',
    text: '$message\nSelamat Datang, ${userData.namaLengkap}!',
    confirmBtnText: 'OK',
    onConfirmBtnTap: () {
      Get.off(() => NavBottom(userData: userData));
    },
  );
}

void _showLoginErrorDialog(BuildContext context) {
  QuickAlert.show(
    context: context,
    type: QuickAlertType.error,
    title: 'Login Gagal',
    text: 'Email atau password salah. Silakan coba lagi.',
    confirmBtnText: 'OK',
  );
}
