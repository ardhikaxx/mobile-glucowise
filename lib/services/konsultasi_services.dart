import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_app/model/dokter_model.dart';
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';

class KonsultasiServices {
  static const String _errorNikNotFound =
      "NIK tidak ditemukan. Silakan login ulang.";
  static const String _errorGetDokter = "Gagal mengambil data dokter";

  // Get list dokter
  static Future<List<Dokter>> getDokters() async {
    try {
      final String? nik = await SessionManager.getNik();
      
      if (nik == null) {
        throw Exception(_errorNikNotFound);
      }

      final response = await http.get(
        Uri.parse('$apiConnect/api/chat/dokters'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          List<dynamic> doktersData = data['data'];
          return doktersData.map((dokter) => Dokter.fromJson(dokter)).toList();
        } else {
          throw Exception(data['message'] ?? _errorGetDokter);
        }
      } else {
        throw Exception('${_errorGetDokter} (${response.statusCode})');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Create conversation dengan dokter
  static Future<Map<String, dynamic>> createConversation(String idAdmin) async {
    try {
      final String? nik = await SessionManager.getNik();
      
      if (nik == null) {
        throw Exception(_errorNikNotFound);
      }

      final response = await http.post(
        Uri.parse('$apiConnect/api/chat/conversation'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nik': nik,
          'id_admin': idAdmin,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true) {
          return {
            'success': true,
            'conversation': data['data'],
          };
        } else {
          throw Exception(data['message'] ?? 'Gagal membuat percakapan');
        }
      } else {
        throw Exception('Gagal membuat percakapan (${response.statusCode})');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}