import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/detail_check.dart';
import 'package:medical_app/page/form_check.dart';

class GlucoCheckScreen extends StatelessWidget {
  GlucoCheckScreen({super.key});

  final List<Map<String, dynamic>> checkData = [
    {
      "tanggal": "09 Feb 2025",
      "tinggi": 170,
      "berat": 65,
      "gulaDarah": 110,
      "umur": 22,
      "tensi": "120/80"
    },
    {
      "tanggal": "07 Feb 2025",
      "tinggi": 165,
      "berat": 70,
      "gulaDarah": 130,
      "umur": 22,
      "tensi": "130/85"
    },
    {
      "tanggal": "05 Feb 2025",
      "tinggi": 175,
      "berat": 80,
      "gulaDarah": 145,
      "umur": 22,
      "tensi": "140/90"
    },
    {
      "tanggal": "03 Feb 2025",
      "tinggi": 180,
      "berat": 75,
      "gulaDarah": 120,
      "umur": 22,
      "tensi": "150/95"
    },
    {
      "tanggal": "01 Feb 2025",
      "tinggi": 185,
      "berat": 85,
      "gulaDarah": 135,
      "umur": 22,
      "tensi": "160/100"
    },
  ];

  double hitungIMT(double berat, double tinggi) {
    double tinggiMeter = tinggi / 100;
    return berat / (tinggiMeter * tinggiMeter);
  }

  @override
  Widget build(BuildContext context) {
    final dataTerbaru = checkData.first;
    final double imt = hitungIMT(
        dataTerbaru["berat"].toDouble(), dataTerbaru["tinggi"].toDouble());

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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NavBottom()));
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GlucoCheckForm()),
                );
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
      body: Padding(
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
                              dataTerbaru["tanggal"],
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
                        _infoItem(FontAwesomeIcons.rulerVertical,
                            "${dataTerbaru["tinggi"]} cm", "Tinggi"),
                        // ignore: deprecated_member_use
                        _infoItem(FontAwesomeIcons.weight,
                            "${dataTerbaru["berat"]} kg", "Berat"),
                        _infoItem(FontAwesomeIcons.chartPie,
                            imt.toStringAsFixed(2), "IMT"),
                        _infoItem(FontAwesomeIcons.droplet,
                            "${dataTerbaru["gulaDarah"]} mg/dL", "Gula Darah"),
                        _infoItem(FontAwesomeIcons.user,
                            "${dataTerbaru["umur"]} tahun", "Umur"),
                        _infoItem(FontAwesomeIcons.heartPulse,
                            dataTerbaru["tensi"], "Tensi"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Semua Riwayat",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: checkData.length,
                itemBuilder: (context, index) {
                  final data = checkData[index];
                  IconData icon;
                  Color iconColor;
                  String status;

                  if (data["gulaDarah"] < 100) {
                    icon = FontAwesomeIcons.solidFaceSmile;
                    iconColor = Colors.green;
                    status = "Normal";
                  } else if (data["gulaDarah"] < 140) {
                    icon = FontAwesomeIcons.faceMeh;
                    iconColor = Colors.orange;
                    status = "Sedang";
                  } else {
                    icon = FontAwesomeIcons.solidFaceFrown;
                    iconColor = Colors.red;
                    status = "Tinggi";
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
                        vertical: 3,
                      ),
                      title: Text(
                        data["tanggal"],
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
                            "${data["gulaDarah"]} mg/dL - $status",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Detail",
                            style: TextStyle(
                                color: Color(0xFF199A8E),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            color: Color(0xFF199A8E)
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailCheckScreen(data: data),
                          ),
                        );
                      },
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