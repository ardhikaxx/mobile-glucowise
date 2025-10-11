// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      nik: json['nik'] as String,
      email: json['email'] as String,
      namaLengkap: json['nama_lengkap'] as String,
      tempatLahir: json['tempat_lahir'] as String?,
      tanggalLahir: json['tanggal_lahir'] as String?,
      jenisKelamin: json['jenis_kelamin'] as String?,
      alamatLengkap: json['alamat_lengkap'] as String?,
      nomorTelepon: json['nomor_telepon'] as String?,
      namaIbuKandung: json['nama_ibu_kandung'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'nik': instance.nik,
      'email': instance.email,
      'nama_lengkap': instance.namaLengkap,
      'tempat_lahir': instance.tempatLahir,
      'tanggal_lahir': instance.tanggalLahir,
      'jenis_kelamin': instance.jenisKelamin,
      'alamat_lengkap': instance.alamatLengkap,
      'nomor_telepon': instance.nomorTelepon,
      'nama_ibu_kandung': instance.namaIbuKandung,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      message: json['message'] as String,
      nik: json['nik'] as String,
      user: UserData.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'nik': instance.nik,
      'user': instance.user,
    };
