import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:quickalert/quickalert.dart';
import 'package:medical_app/model/user.dart';

class ApiConfig {
  static String apiUrl = "http://127.0.0.1:8000";

  void setApiUrl(String newUrl) {
    apiUrl = newUrl;
  }
}

class AuthServices {
  static String? _nik;
  String? getNik() => _nik;

  static Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final String apiUrl = "${ApiConfig.apiUrl}/api/auth/login";
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);

        if (jsonData.containsKey('message') && jsonData.containsKey('user')) {
          UserResponse userResponse = UserResponse.fromJson(jsonData);
          _nik = userResponse.nik;

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
