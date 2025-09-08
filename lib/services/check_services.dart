import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';

class CheckServices {
  static const String _errorNikNotFound = "NIK tidak ditemukan. Silakan login ulang.";
  static const String _errorDefault = "Terjadi kesalahan. Coba lagi nanti.";
  static const String _errorAddCheck = "Gagal menambahkan data kesehatan.";
  static const String _errorGetHistory = "Gagal mengambil riwayat kesehatan.";
  static const String _errorGetStatus = "Gagal mengambil status risiko.";

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
        print("Error getRiwayatKesehatan: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error getRiwayatKesehatan: $e");
      _showErrorDialog(context, _errorDefault);
      return [];
    }
  }

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

  // Custom Success Dialog
  static void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text("Berhasil"),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // tutup dialog
                Navigator.pop(context); // kembali ke halaman sebelumnya
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Custom Error Dialog
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Row(
            children: const [
              Icon(Icons.error, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text("Gagal"),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
