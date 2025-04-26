import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';

class ScreeningServices {
  static const String _errorNikNotFound = "NIK tidak ditemukan. Silakan login ulang.";

  static Future<Map<String, dynamic>?> getQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('$apiConnect/api/screening/questions'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error getting questions: $e');
      return null;
    }
  }

  static Future<bool> submitAnswers({
    required String nik,
    required List<Map<String, dynamic>> answers,
    required int totalScore,
    required BuildContext context,
  }) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$apiConnect/api/screening/results'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nik': nik,
          'answers': answers,
          'skor_risiko': totalScore,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Gagal',
          text: 'Gagal menyimpan hasil screening',
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error submitting answers: $e');
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Terjadi kesalahan saat mengirim data',
      );
      return false;
    }
  }

  static Future<List<dynamic>?> getScreeningHistory(String nik, BuildContext context) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return [];
    }
    try {
      final response = await http.get(
        Uri.parse('$apiConnect/api/screening/history/$nik'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      debugPrint('Error getting history: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getScreeningDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$apiConnect/api/screening/results/$id'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting detail: $e');
      return null;
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Gagal',
      text: message,
      confirmBtnText: 'OK',
    );
  }
}