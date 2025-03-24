import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/GlucoCheck/all_check.dart';
import 'package:medical_app/page/GlucoCheck/form_check.dart';
import 'package:medical_app/services/check_services.dart';

class GlucoCheckScreen extends StatefulWidget {
  final UserData userData;
  const GlucoCheckScreen({super.key, required this.userData});

  @override
  _GlucoCheckScreenState createState() => _GlucoCheckScreenState();
}

class _GlucoCheckScreenState extends State<GlucoCheckScreen> {
  List<dynamic> checkData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        checkData = data;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading data: $e");
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataTerbaru = checkData.isNotEmpty ? checkData.first : null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Gluco Check",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GlucoCheckForm()),
                );

                _loadData();
              },
              icon: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF199A8E),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Color(0xFF199A8E),
                size: 50,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Data Terbaru",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF199A8E),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  if (dataTerbaru != null)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.black.withOpacity(0.5),
                      elevation: 4,
                      color: const Color(0xFFE8F3F1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.calendarDay,
                                        color: Color(0xFF199A8E)),
                                    const SizedBox(width: 10),
                                    Text(
                                      dataTerbaru["tanggal_pemeriksaan"],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Icon(FontAwesomeIcons.fileMedical,
                                    color: Color(0xFF199A8E)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(
                              color: Color(0xFF199A8E),
                              thickness: 0.8,
                            ),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.5,
                              children: [
                                _infoItem(
                                    FontAwesomeIcons.ruler,
                                    "${dataTerbaru["tinggi_badan"]} cm",
                                    "Tinggi Badan"),
                                _infoItem(
                                    FontAwesomeIcons.weightScale,
                                    "${dataTerbaru["berat_badan"]} kg",
                                    "Berat Badan"),
                                _infoItem(
                                    FontAwesomeIcons.droplet,
                                    "${dataTerbaru["gula_darah"]} mg/dL",
                                    "Gula Darah"),
                                _infoItem(
                                    FontAwesomeIcons.heartPulse,
                                    dataTerbaru["tensi_darah"].toString(),
                                    "Tensi"),
                                _infoItem(
                                    FontAwesomeIcons.ruler,
                                    "${dataTerbaru["lingkar_pinggang"]} cm",
                                    "Lingkar Pinggang"),
                                _infoItem(FontAwesomeIcons.userClock,
                                    "${dataTerbaru["umur"]} tahun", "Umur"),
                                _infoItem(
                                    FontAwesomeIcons.userGroup,
                                    dataTerbaru["riwayat_keluarga_diabetes"],
                                    "Riwayat Keluarga"),
                                FutureBuilder<Map<String, dynamic>?>(
                                  future: CheckServices.getStatusRisiko(
                                      context, dataTerbaru["id_data"]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Color(0xFF199A8E),
                                      ));
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                          child: Text(
                                              "Gagal memuat status risiko"));
                                    } else if (!snapshot.hasData) {
                                      return const Center(
                                          child: Text("Tidak ada data"));
                                    }

                                    final status = snapshot.data!;
                                    return Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF9FAFB),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            status[
                                                        "kategori_risiko"] ==
                                                    "Tinggi"
                                                ? FontAwesomeIcons
                                                    .solidFaceFrown
                                                : (status["kategori_risiko"] ==
                                                        "Sedang"
                                                    ? FontAwesomeIcons.faceMeh
                                                    : FontAwesomeIcons
                                                        .solidFaceSmile),
                                            color: status["kategori_risiko"] ==
                                                    "Tinggi"
                                                ? Colors.red
                                                : (status["kategori_risiko"] ==
                                                        "Sedang"
                                                    ? Colors.orange
                                                    : Colors.green),
                                            size: 24,
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                "Status Risiko",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87),
                                              ),
                                              Text(
                                                status["kategori_risiko"],
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: status[
                                                              "kategori_risiko"] ==
                                                          "Tinggi"
                                                      ? Colors.red
                                                      : (status["kategori_risiko"] ==
                                                              "Sedang"
                                                          ? Colors.orange
                                                          : Colors.green),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Semua Riwayat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF199A8E),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AllCheckScreen(checkData: checkData),
                            ),
                          );
                        },
                        child: const Text(
                          "Lihat Semua",
                          style: TextStyle(
                            color: Color(0xFF199A8E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: checkData.length,
                      itemBuilder: (context, index) {
                        final data = checkData[index];
                        IconData icon;
                        Color iconColor;

                        if (data["gula_darah"] < 100) {
                          icon = FontAwesomeIcons.solidFaceSmile;
                          iconColor = Colors.green;
                        } else if (data["gula_darah"] < 140) {
                          icon = FontAwesomeIcons.faceMeh;
                          iconColor = Colors.orange;
                        } else {
                          icon = FontAwesomeIcons.solidFaceFrown;
                          iconColor = Colors.red;
                        }

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: const Color(0xFFE8F3F1),
                          shadowColor: Colors.black.withOpacity(0.5),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            title: Text(
                              data["tanggal_pemeriksaan"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Icon(icon, color: iconColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  "${data["gula_darah"]} mg/dL",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: iconColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                            trailing: FutureBuilder<Map<String, dynamic>?>(
                              future: CheckServices.getStatusRisiko(
                                  context, data["id_data"]),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator(
                                    color: Color(0xFF199A8E),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text("Error");
                                } else if (!snapshot.hasData) {
                                  return const Text("Tidak ada data");
                                }

                                final status = snapshot.data!;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9FAFB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    status["kategori_risiko"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          status["kategori_risiko"] == "Tinggi"
                                              ? Colors.red
                                              : (status["kategori_risiko"] ==
                                                      "Sedang"
                                                  ? Colors.orange
                                                  : Colors.green),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF199A8E), size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
