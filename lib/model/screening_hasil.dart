class ScreeningHasil {
  final int idScreening;
  final String nik;
  final DateTime tanggalScreening;
  final int skorRisiko;
  final List<ScreeningAnswer> hasilScreening;

  ScreeningHasil({
    required this.idScreening,
    required this.nik,
    required this.tanggalScreening,
    required this.skorRisiko,
    required this.hasilScreening,
  });

  String get formattedDate {
    return '${tanggalScreening.day}/${tanggalScreening.month}/${tanggalScreening.year}';
  }

  factory ScreeningHasil.fromJson(Map<String, dynamic> json) {
    final hasilScreening = (json['hasil_screening'] as List)
        .map((e) => ScreeningAnswer.fromJson(e))
        .toList();

    return ScreeningHasil(
      idScreening: json['id_screening'],
      nik: json['nik'],
      tanggalScreening: DateTime.parse(json['tanggal_screening']),
      skorRisiko: json['skor_risiko'],
      hasilScreening: hasilScreening,
    );
  }
}

class ScreeningAnswer {
  final String pertanyaan;
  final String jawaban;

  ScreeningAnswer({
    required this.pertanyaan,
    required this.jawaban,
  });

  factory ScreeningAnswer.fromJson(Map<String, dynamic> json) {
    return ScreeningAnswer(
      pertanyaan: json['pertanyaan_screening']['pertanyaan'],
      jawaban: json['jawaban_screening']['jawaban'],
    );
  }
}