class Edukasi {
  final int idEdukasi;
  final String kategori;
  final String judul;
  final String deskripsi;
  final String? gambar;
  final String tanggalPublikasi;
  final String gambarUrl;

  Edukasi({
    required this.idEdukasi,
    required this.kategori,
    required this.judul,
    required this.deskripsi,
    this.gambar,
    required this.tanggalPublikasi,
    required this.gambarUrl,
  });

  factory Edukasi.fromJson(Map<String, dynamic> json) {
    return Edukasi(
      idEdukasi: json['id_edukasi'] as int,
      kategori: json['kategori'] as String,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      gambar: json['gambar'] as String?,
      tanggalPublikasi: json['tanggal_publikasi'] as String,
      gambarUrl: json['gambar_url'] as String,
    );
  }
}