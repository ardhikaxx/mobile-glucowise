import 'package:flutter/material.dart';

class Dokter {
  final int idAdmin;
  final String namaLengkap;
  final String jenisKelamin;
  final String? nomorTelepon;
  final String? spesialisasi;

  Dokter({
    required this.idAdmin,
    required this.namaLengkap,
    required this.jenisKelamin,
    this.nomorTelepon,
    this.spesialisasi,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    // Extract spesialisasi dari nama lengkap
    String? extractSpesialisasi(String namaLengkap) {
      if (namaLengkap.contains(',')) {
        return namaLengkap.split(',')[1].trim();
      }
      return null;
    }

    return Dokter(
      idAdmin: json['id_admin'] is int
          ? json['id_admin']
          : int.parse(json['id_admin'].toString()),
      namaLengkap: json['nama_lengkap'] ?? 'Dokter',
      jenisKelamin: json['jenis_kelamin'] ?? 'Laki-laki',
      nomorTelepon: json['nomor_telepon'],
      spesialisasi: extractSpesialisasi(json['nama_lengkap'] ?? ''),
    );
  }

  String get namaSingkat {
    final names = namaLengkap.split(',')[0];
    return names;
  }

  String get avatarText {
    final names = namaSingkat.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}';
    }
    return namaSingkat.length >= 2 ? namaSingkat.substring(0, 2) : namaSingkat;
  }

  Color get genderColor {
    return jenisKelamin == 'Perempuan'
        ? const Color(0xFFEC407A)
        : const Color(0xFF42A5F5);
  }

  String get spesialisasiDisplay {
    if (spesialisasi != null) {
      return spesialisasi!;
    }
    return 'Dokter Umum';
  }
}
