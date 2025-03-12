import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/GlucoCheck/all_check.dart';
import 'package:medical_app/page/GlucoCheck/detail_check.dart';
import 'package:medical_app/page/GlucoCheck/form_check.dart';

class GlucoCheckScreen extends StatelessWidget {
  GlucoCheckScreen({super.key});

  final List<Map<String, dynamic>> checkData = [
    {
      "tanggal": "01 Feb 2025",
      "tinggi": 170,
      "berat": 65,
      "gulaDarah": 110,
      "umur": 22,
      "tensi": "120/80",
      "lingkarPinggang": 78,
      "faktorKeluargaDiabetes": "Iya",
      "statusRisiko": "Sedang"
    },
    {
      "tanggal": "01 Jan 2025",
      "tinggi": 170,
      "berat": 66,
      "gulaDarah": 115,
      "umur": 22,
      "tensi": "122/82",
      "lingkarPinggang": 79,
      "faktorKeluargaDiabetes": "Iya",
      "statusRisiko": "Sedang"
    },
    {
      "tanggal": "01 Des 2024",
      "tinggi": 170,
      "berat": 67,
      "gulaDarah": 120,
      "umur": 21,
      "tensi": "125/85",
      "lingkarPinggang": 80,
      "faktorKeluargaDiabetes": "Tidak",
      "statusRisiko": "Sedang"
    },
    {
      "tanggal": "01 Nov 2024",
      "tinggi": 170,
      "berat": 70,
      "gulaDarah": 140,
      "umur": 21,
      "tensi": "135/88",
      "lingkarPinggang": 82,
      "faktorKeluargaDiabetes": "Tidak",
      "statusRisiko": "Tinggi"
    }
  ];

  @override
  Widget build(BuildContext context) {
    final dataTerbaru = checkData.first;

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
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const NavBottom()));
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
                  MaterialPageRoute(
                      builder: (context) => const GlucoCheckForm()),
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
                        _infoItem(FontAwesomeIcons.ruler,
                            "${dataTerbaru["tinggi"]} cm", "Tinggi Badan"),
                        _infoItem(FontAwesomeIcons.weightScale,
                            "${dataTerbaru["berat"]} kg", "Berat Badan"),
                        _infoItem(FontAwesomeIcons.droplet,
                            "${dataTerbaru["gulaDarah"]} mg/dL", "Gula Darah"),
                        _infoItem(FontAwesomeIcons.heartPulse,
                            dataTerbaru["tensi"], "Tensi"),
                        _infoItem(
                            FontAwesomeIcons.ruler,
                            "${dataTerbaru["lingkarPinggang"]} cm",
                            "Lingkar Pinggang"),
                        _infoItem(FontAwesomeIcons.userClock,
                            "${dataTerbaru["umur"]} tahun", "Umur"),
                        _infoItem(
                            FontAwesomeIcons.userGroup,
                            dataTerbaru["faktorKeluargaDiabetes"],
                            "Riwayat Keluarga"),
                        Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                dataTerbaru["statusRisiko"] == "Tinggi"
                                    ? FontAwesomeIcons.solidFaceFrown
                                    : (dataTerbaru["statusRisiko"] == "Sedang"
                                        ? FontAwesomeIcons.faceMeh
                                        : FontAwesomeIcons.solidFaceSmile),
                                color: dataTerbaru["statusRisiko"] == "Tinggi"
                                    ? Colors.red
                                    : (dataTerbaru["statusRisiko"] == "Sedang"
                                        ? Colors.orange
                                        : Colors.green),
                                size: 24,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Status Risiko",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                  Text(
                                    dataTerbaru["statusRisiko"],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: dataTerbaru["statusRisiko"] ==
                                              "Tinggi"
                                          ? Colors.red
                                          : (dataTerbaru["statusRisiko"] ==
                                                  "Sedang"
                                              ? Colors.orange
                                              : Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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

                  if (data["gulaDarah"] < 100) {
                    icon = FontAwesomeIcons.solidFaceSmile;
                    iconColor = Colors.green;
                  } else if (data["gulaDarah"] < 140) {
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
                            "${data["gulaDarah"]} mg/dL",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: iconColor,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              data["statusRisiko"],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: data["statusRisiko"] == "Tinggi"
                                    ? Colors.red
                                    : (data["statusRisiko"] == "Sedang"
                                        ? Colors.orange
                                        : Colors.green),
                              ),
                            ),
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
                          Icon(Icons.chevron_right, color: Color(0xFF199A8E)),
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
