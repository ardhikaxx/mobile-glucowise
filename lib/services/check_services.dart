import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';
import 'package:medical_app/components/alert.dart'; // Import komponen alert

class CheckServices {
  static const String _errorNikNotFound =
      "NIK tidak ditemukan. Silakan login ulang.";
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
      CustomAlert.showMessageDialog(
        context: context,
        title: "Gagal",
        message: _errorNikNotFound,
        isSuccess: false,
      );
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
        CustomAlert.showMessageDialog(
          context: context,
          title: "Berhasil",
          message: "Data kesehatan berhasil ditambahkan.",
          isSuccess: true,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
      } else {
        CustomAlert.showMessageDialog(
          context: context,
          title: "Gagal",
          message: jsonData['message'] ?? _errorAddCheck,
          isSuccess: false,
        );
      }
    } catch (e) {
      print("Error addCheck: $e");
      CustomAlert.showMessageDialog(
        context: context,
        title: "Gagal",
        message: _errorDefault,
        isSuccess: false,
      );
    }
  }

  static Future<List<dynamic>> getRiwayatKesehatan(BuildContext context) async {
    String? nik = await SessionManager.getNik();

    if (nik == null) {
      CustomAlert.showMessageDialog(
        context: context,
        title: "Gagal",
        message: _errorNikNotFound,
        isSuccess: false,
      );
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
          CustomAlert.showMessageDialog(
            context: context,
            title: "Gagal",
            message: jsonData['message'] ?? _errorGetHistory,
            isSuccess: false,
          );
          return [];
        }
      } else {
        print("Error getRiwayatKesehatan: ${response.body}");
        CustomAlert.showMessageDialog(
          context: context,
          title: "Gagal",
          message: _errorGetHistory,
          isSuccess: false,
        );
        return [];
      }
    } catch (e) {
      print("Error getRiwayatKesehatan: $e");
      CustomAlert.showMessageDialog(
        context: context,
        title: "Gagal",
        message: _errorDefault,
        isSuccess: false,
      );
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
          CustomAlert.showMessageDialog(
            context: context,
            title: "Gagal",
            message: jsonData['message'],
            isSuccess: false,
          );
          return null;
        }
      } else {
        CustomAlert.showMessageDialog(
          context: context,
          title: "Gagal",
          message: _errorGetStatus,
          isSuccess: false,
        );
        return null;
      }
    } catch (e) {
      print("Error getStatusRisiko: $e");
      CustomAlert.showMessageDialog(
        context: context,
        title: "Gagal",
        message: _errorDefault,
        isSuccess: false,
      );
      return null;
    }
  }
}
