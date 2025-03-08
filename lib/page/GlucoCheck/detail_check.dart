import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailCheckScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailCheckScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> risiko = _getRiskStatus(data["gulaDarah"]);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail Gluco Check',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 30,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      // Tanggal Pemeriksaan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(FontAwesomeIcons.calendarDay,
                                  color: Color(0xFF199A8E)),
                              const SizedBox(width: 8),
                              Text(
                                data["tanggal"],
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

                      // GridView Data Pemeriksaan + Risiko Diabetes
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.5,
                        children: [
                          _infoItem(FontAwesomeIcons.ruler,
                              "${data["tinggi"]} cm", "Tinggi Badan"),
                          _infoItem(FontAwesomeIcons.weightScale,
                              "${data["berat"]} kg", "Berat Badan"),
                          _infoItem(FontAwesomeIcons.droplet,
                              "${data["gulaDarah"]} mg/dL", "Gula Darah"),
                          _infoItem(FontAwesomeIcons.heartPulse,
                              data["tensi"], "Tensi"),
                          _infoItem(FontAwesomeIcons.ruler,
                              "${data["lingkarPinggang"]} cm", "Lingkar Pinggang"),
                          _infoItem(FontAwesomeIcons.userClock,
                              "${data["umur"]} tahun", "Umur"),
                          _infoItem(FontAwesomeIcons.userGroup,
                              data["faktorKeluargaDiabetes"], "Riwayat Keluarga"),
                          _riskItem(risiko["icon"], risiko["status"], risiko["color"]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  Widget _riskItem(IconData icon, String status, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                status,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: color),
              ),
              const Text(
                "Risiko Diabetes",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getRiskStatus(int gulaDarah) {
    if (gulaDarah < 100) {
      return {
        "status": "Rendah",
        "icon": FontAwesomeIcons.solidFaceSmile,
        "color": Colors.green,
      };
    } else if (gulaDarah < 140) {
      return {
        "status": "Sedang",
        "icon": FontAwesomeIcons.faceMeh,
        "color": Colors.orange,
      };
    } else {
      return {
        "status": "Tinggi",
        "icon": FontAwesomeIcons.solidFaceFrown,
        "color": Colors.red,
      };
    }
  }
}