import 'dart:convert';
import 'package:http/http.dart' as http;

// Model untuk data rumah sakit
class Hospital {
  final String namaRumahSakit;
  final String tempat;
  final String namaProvinsi;
  final String namaKabkota;
  final String kelas;
  final String jenis;
  final String alamat;
  final String email;

  Hospital({
    required this.namaRumahSakit,
    required this.tempat,
    required this.namaProvinsi,
    required this.namaKabkota,
    required this.kelas,
    required this.jenis,
    required this.alamat,
    required this.email,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      namaRumahSakit: json['nama_rumah_sakit'] ?? 'Tidak ada data',
      tempat: json['tempat'] ?? 'Tidak ada data',
      namaProvinsi: json['nama_provinsi'] ?? 'Tidak ada data',
      namaKabkota: json['nama_kabkota'] ?? 'Tidak ada data',
      kelas: json['kelas'] ?? 'Tidak ada data',
      jenis: json['jenis'] ?? 'Tidak ada data',
      alamat: json['alamat'] ?? 'Tidak ada data',
      email: json['email'] ?? 'Tidak ada data',
    );
  }
}

// Model untuk response API
class HospitalResponse {
  final int draw;
  final int recordsTotal;
  final int recordsFiltered;
  final List<Hospital> data;

  HospitalResponse({
    required this.draw,
    required this.recordsTotal,
    required this.recordsFiltered,
    required this.data,
  });

  factory HospitalResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Hospital> hospitals = list.map((i) => Hospital.fromJson(i)).toList();

    return HospitalResponse(
      draw: json['draw'] ?? 0,
      recordsTotal: json['recordsTotal'] ?? 0,
      recordsFiltered: json['recordsFiltered'] ?? 0,
      data: hospitals,
    );
  }
}

class HospitalService {
  static const String baseUrl = 
      'https://sinkarkes-api.kemkes.go.id/portal/rumah_sakit/datatable';

  // Fungsi untuk mengambil data rumah sakit
  static Future<HospitalResponse> getHospitals() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return HospitalResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load hospitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hospitals: $e');
    }
  }

  // Fungsi untuk mencari rumah sakit berdasarkan nama
  static Future<HospitalResponse> searchHospitals(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?search=$query'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return HospitalResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to search hospitals: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching hospitals: $e');
    }
  }
}