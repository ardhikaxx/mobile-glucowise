import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:medical_app/model/edukasi.dart';
import 'package:medical_app/services/connect.dart';

class EdukasiServices {
  static const String _errorGetEdukasi = 'Gagal mengambil data edukasi';
  static const String _errorDefault = 'Terjadi kesalahan';

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
              Text("Oops..."),
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

  static Future<List<Edukasi>> getEdukasi(BuildContext context) async {
    try {
      final url = "$apiConnect/api/edukasi";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == true) {
          if (jsonData['data'] != null && jsonData['data'] is List) {
            return (jsonData['data'] as List)
                .map((item) => Edukasi.fromJson(item))
                .toList();
          } else {
            return [];
          }
        } else {
          _showErrorDialog(context, jsonData['message'] ?? _errorGetEdukasi);
          return [];
        }
      } else {
        _showErrorDialog(context, _errorGetEdukasi);
        return [];
      }
    } catch (e) {
      print("Error getEdukasi: $e");
      _showErrorDialog(context, _errorDefault);
      return [];
    }
  }
}