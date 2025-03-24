import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';

class CheckServices {
  // Konstanta untuk pesan
  static const String _errorNikNotFound = "NIK tidak ditemukan. Silakan login ulang.";
  static const String _errorDefault = "Terjadi kesalahan. Coba lagi nanti.";
  static const String _errorAddCheck = "Gagal menambahkan data kesehatan.";
  static const String _errorGetHistory = "Gagal mengambil riwayat kesehatan.";
  static const String _errorGetStatus = "Gagal mengambil status risiko.";

  // Method untuk menambahkan data kesehatan
  static Future<void> addCheck(
    BuildContext context, {
    required String tanggalPemeriksaan,
    required String riwayatKeluargaDiabetes,
    required int umur,
    required double tinggiBadan,
    required double beratBadan,
    required double gulaDarah,
    required double lingkarPinggang,
    required double tensiDarah,
  }) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return;
    }

    try {
      final url = "$apiConnect/api/gluco-check/add";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'tanggal_pemeriksaan': tanggalPemeriksaan,
          'riwayat_keluarga_diabetes': riwayatKeluargaDiabetes,
          'umur': umur,
          'tinggi_badan': tinggiBadan,
          'berat_badan': beratBadan,
          'gula_darah': gulaDarah,
          'lingkar_pinggang': lingkarPinggang,
          'tensi_darah': tensiDarah,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        _showSuccessDialog(context, "Data kesehatan berhasil ditambahkan.");
      } else {
        _showErrorDialog(context, jsonData['message'] ?? _errorAddCheck);
      }
    } catch (e) {
      print("Error addCheck: $e");
      _showErrorDialog(context, _errorDefault);
    }
  }

  // Method untuk mengambil riwayat kesehatan
  static Future<List<dynamic>> getRiwayatKesehatan(BuildContext context) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return [];
    }

    try {
      final url = "$apiConnect/api/gluco-check/history/$nik";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          return jsonData['data'];
        } else {
          _showErrorDialog(context, jsonData['message'] ?? _errorGetHistory);
          return [];
        }
      } else {
        _showErrorDialog(context, _errorGetHistory);
        return [];
      }
    } catch (e) {
      print("Error getRiwayatKesehatan: $e");
      _showErrorDialog(context, _errorDefault);
      return [];
    }
  }

  // Method untuk mengambil status risiko
  static Future<Map<String, dynamic>?> getStatusRisiko(
      BuildContext context, int idData) async {
    try {
      final url = "$apiConnect/api/gluco-check/status/$idData";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          return jsonData['data'];
        } else {
          _showErrorDialog(context, jsonData['message'] ?? _errorGetStatus);
          return null;
        }
      } else {
        _showErrorDialog(context, _errorGetStatus);
        return null;
      }
    } catch (e) {
      print("Error getStatusRisiko: $e");
      _showErrorDialog(context, _errorDefault);
      return null;
    }
  }

  // Method untuk menampilkan dialog sukses
  static void _showSuccessDialog(BuildContext context, String message) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Berhasil',
      text: message,
      confirmBtnText: 'OK',
      onConfirmBtnTap: () {
        Navigator.pop(context);
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      },
    );
  }

  // Method untuk menampilkan dialog error
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