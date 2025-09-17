import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';
import 'package:medical_app/components/alert.dart'; // Import komponen alert

class CareServices {
  static const String _errorNikNotFound = "NIK tidak ditemukan. Silakan login ulang.";
  static const String _errorDefault = "Terjadi kesalahan. Coba lagi nanti.";
  static const String _errorAddCare = "Gagal menambahkan jadwal.";
  static const String _errorEditCare = "Gagal mengedit jadwal.";
  static const String _errorGetHistory = "Gagal mengambil riwayat.";
  static const String _errorGetActive = "Gagal mengambil jadwal.";

  // Method untuk menambahkan jadwal
  static Future<void> addCare(
    BuildContext context, {
    required String tanggal,
    required String namaObat,
    required String dosis,
    required String jamMinum,
  }) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return;
    }

    try {
      final url = "$apiConnect/api/gluco-care/add";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'tanggal': tanggal,
          'nama_obat': namaObat,
          'dosis': dosis,
          'jam_minum': jamMinum,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        showMessageDialog(context, jsonData['message']);
      } else {
        _showErrorDialog(context, jsonData['message'] ?? _errorAddCare);
      }
    } catch (e) {
      print("Error addCare: $e");
      _showErrorDialog(context, _errorDefault);
    }
  }

  // Method untuk mengedit jadwal
  static Future<void> editCare(
    BuildContext context,
    int idCare, {
    required String tanggal,
    required String namaObat,
    required String dosis,
    required String jamMinum,
  }) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return;
    }

    try {
      final url = "$apiConnect/api/gluco-care/edit/$idCare";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nik': nik,
          'tanggal': tanggal,
          'nama_obat': namaObat,
          'dosis': dosis,
          'jam_minum': jamMinum,
        }),
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        showMessageDialog(context, jsonData['message']);
      } else {
        _showErrorDialog(context, jsonData['message'] ?? _errorEditCare);
      }
    } catch (e) {
      print("Error editCare: $e");
      _showErrorDialog(context, _errorDefault);
    }
  }

  // Method untuk mengambil riwayat
  static Future<List<dynamic>> getRiwayatCare(BuildContext context) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return [];
    }

    try {
      final url = "$apiConnect/api/gluco-care/history/$nik";
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
      print("Error getRiwayatCare: $e");
      _showErrorDialog(context, _errorDefault);
      return [];
    }
  }

  // Method untuk mengambil jadwal aktif
  static Future<List<dynamic>> getActiveCare(BuildContext context) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      _showErrorDialog(context, _errorNikNotFound);
      return [];
    }

    try {
      final url = "$apiConnect/api/gluco-care/active/$nik";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          return jsonData['data'];
        } else {
          _showErrorDialog(context, jsonData['message'] ?? _errorGetActive);
          return [];
        }
      } else {
        _showErrorDialog(context, _errorGetActive);
        return [];
      }
    } catch (e) {
      print("Error getActiveCare: $e");
      _showErrorDialog(context, _errorDefault);
      return [];
    }
  }

  static void showMessageDialog(BuildContext context, String message) {
    CustomAlert.showMessageDialog(
      context: context,
      title: "Berhasil",
      message: message,
      isSuccess: true,
      buttonText: "OK",
      onPressed: () {
        Get.back();
      },
    );
  }

  static void _showErrorDialog(BuildContext context, String message) {
    CustomAlert.showMessageDialog(
      context: context,
      title: "Gagal",
      message: message,
      isSuccess: false,
      buttonText: "OK",
    );
  }
}