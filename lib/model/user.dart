import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserData {
  final String nik;
  final String email;
  @JsonKey(name: 'nama_lengkap')
  final String namaLengkap;
  @JsonKey(name: 'tempat_lahir')
  final String? tempatLahir;
  @JsonKey(name: 'tanggal_lahir')
  final String? tanggalLahir;
  @JsonKey(name: 'jenis_kelamin')
  final String? jenisKelamin;
  @JsonKey(name: 'alamat_lengkap')
  final String? alamatLengkap;
  @JsonKey(name: 'nomor_telepon')
  final String? nomorTelepon;
  @JsonKey(name: 'nama_ibu_kandung')
  final String? namaIbuKandung;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  UserData({
    required this.nik,
    required this.email,
    required this.namaLengkap,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.alamatLengkap,
    this.nomorTelepon,
    this.namaIbuKandung,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class UserResponse {
  final String message;
  final String nik;
  final UserData user;

  UserResponse({
    required this.message,
    required this.nik,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
