import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/services/check_services.dart';

class AllCheckScreen extends StatefulWidget {
  final List checkData;
  const AllCheckScreen({super.key, required this.checkData});

  @override
  State<AllCheckScreen> createState() => _AllCheckScreenState();
}

class _AllCheckScreenState extends State<AllCheckScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Semua Riwayat',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
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
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF199A8E)))
            : widget.checkData.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data riwayat kesehatan.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: widget.checkData.length,
                    itemBuilder: (context, index) {
                      final data = widget.checkData[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.2),
                          color: const Color(0xFFE8F3F1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tanggal dan Ikon Kalender
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(FontAwesomeIcons.calendarDay,
                                            color: Color(0xFF199A8E)),
                                        const SizedBox(width: 8),
                                        Text(
                                          data["tanggal_pemeriksaan"],
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
                                const Divider(
                                  color: Color(0xFF199A8E),
                                  thickness: 0.8,
                                  height: 15,
                                ),
                                const SizedBox(height: 5),

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
                                        "${data["tinggi_badan"]} cm",
                                        "Tinggi Badan"),
                                    _infoItem(
                                        FontAwesomeIcons.weightScale,
                                        "${data["berat_badan"]} kg",
                                        "Berat Badan"),
                                    _infoItem(
                                        FontAwesomeIcons.droplet,
                                        "${data["gula_darah"]} mg/dL",
                                        "Gula Darah"),
                                    _infoItem(
                                        FontAwesomeIcons.heartPulse,
                                        data["tensi_darah"].toString(),
                                        "Tensi"),
                                    _infoItem(
                                        FontAwesomeIcons.ruler,
                                        "${data["lingkar_pinggang"]} cm",
                                        "Lingkar Pinggang"),
                                    _infoItem(FontAwesomeIcons.userClock,
                                        "${data["umur"]} tahun", "Umur"),
                                    _infoItem(
                                        FontAwesomeIcons.userGroup,
                                        data["riwayat_keluarga_diabetes"],
                                        "Riwayat Keluarga"),
                                    FutureBuilder<Map<String, dynamic>?>(
                                      future: CheckServices.getStatusRisiko(
                                          context, data["id_data"]),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child: CircularProgressIndicator(
                                            color: Color(0xFF199A8E),
                                            strokeWidth: 2,
                                          ));
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                              child: Text("Error"));
                                        } else if (!snapshot.hasData) {
                                          return const Center(
                                              child: Text("No data"));
                                        }

                                        final status = snapshot.data!;
                                        final statusColor = status[
                                                    "kategori_risiko"] ==
                                                "Tinggi"
                                            ? Colors.red
                                            : (status["kategori_risiko"] ==
                                                    "Sedang"
                                                ? Colors.orange
                                                : (status["kategori_risiko"] ==
                                                        "Rendah"
                                                    ? Colors.green
                                                    : Colors.grey));

                                        return Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF9FAFB),
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                        ? FontAwesomeIcons
                                                            .faceMeh
                                                        : (status["kategori_risiko"] ==
                                                                "Rendah"
                                                            ? FontAwesomeIcons
                                                                .solidFaceSmile
                                                            : FontAwesomeIcons
                                                                .clock)),
                                                color: statusColor,
                                                size: 22,
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
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: statusColor,
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
                      );
                    },
                  ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF199A8E), size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
