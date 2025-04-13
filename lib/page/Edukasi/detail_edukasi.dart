import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/model/edukasi.dart';
import 'package:medical_app/services/edukasi_services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailEdukasiScreen extends StatefulWidget {
  final Edukasi edukasi;

  const DetailEdukasiScreen({super.key, required this.edukasi});

  @override
  State<DetailEdukasiScreen> createState() => _DetailEdukasiScreenState();
}

class _DetailEdukasiScreenState extends State<DetailEdukasiScreen> {
  List<Edukasi> otherEdukasi = [];
  bool isLoadingOtherEdukasi = true;

  @override
  void initState() {
    super.initState();
    _loadOtherEdukasi();
  }

  Future<void> _loadOtherEdukasi() async {
    try {
      final allEdukasi = await EdukasiServices.getEdukasi(context);
      setState(() {
        otherEdukasi = allEdukasi
            .where((e) => e.idEdukasi != widget.edukasi.idEdukasi)
            .toList();
        isLoadingOtherEdukasi = false;
      });
    } catch (e) {
      setState(() {
        isLoadingOtherEdukasi = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.edukasi.judul,
          style: const TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3F1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.edukasi.kategori,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF199A8E),
                    ),
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F3F1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    widget.edukasi.tanggalPublikasi,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF199A8E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: widget.edukasi.gambarUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.edukasi.judul,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.edukasi.deskripsi,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            const Text(
              "Edukasi Lainnya",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
            const SizedBox(height: 10),
            isLoadingOtherEdukasi
                ? const Center(child: CircularProgressIndicator())
                : otherEdukasi.isEmpty
                    ? const Text(
                        "Tidak ada edukasi lainnya",
                        style: TextStyle(color: Colors.grey),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: otherEdukasi.length,
                        itemBuilder: (context, index) {
                          final item = otherEdukasi[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailEdukasiScreen(edukasi: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              shadowColor: Colors.black.withOpacity(0.5),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: const Color(0xFFE8F3F1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Perbaikan gambar untuk edukasi lainnya
                                    SizedBox(
                                      width: 100,
                                      height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: item.gambarUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[200],
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image,
                                                size: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.judul,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF199A8E),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            item.kategori,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right,
                                        color: Color(0xFF199A8E)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}