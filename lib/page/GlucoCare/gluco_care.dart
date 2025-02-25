import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/GlucoCare/edit_care.dart';
import 'package:medical_app/page/GlucoCare/riwayat_care.dart';
import 'package:medical_app/page/GlucoCare/form_care.dart';

class GlucoCareScreen extends StatefulWidget {
  const GlucoCareScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GlucoCareScreenState createState() => _GlucoCareScreenState();
}

class _GlucoCareScreenState extends State<GlucoCareScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> jadwalObat = [
      {
        "nama": "Metformin",
        "jam": "08:00",
        "tanggal": "2025-02-20",
        "status": "Belum"
      },
      {
        "nama": "Insulin",
        "jam": "12:00",
        "tanggal": "2025-02-20",
        "status": "Belum"
      },
      {
        "nama": "Glimepiride",
        "jam": "18:00",
        "tanggal": "2025-02-20",
        "status": "Belum"
      },
      {
        "nama": "Acarbose",
        "jam": "22:00",
        "tanggal": "2025-02-20",
        "status": "Belum"
      },
    ];

    List<Map<String, dynamic>> riwayatObat = [
      {
        "nama": "Metformin",
        "jam": "08:00",
        "tanggal": "2025-02-19",
        "status": "Sudah"
      },
      {
        "nama": "Insulin",
        "jam": "12:00",
        "tanggal": "2025-02-19",
        "status": "Sudah"
      },
      {
        "nama": "Glimepiride",
        "jam": "18:00",
        "tanggal": "2025-02-19",
        "status": "Sudah"
      },
      {
        "nama": "Acarbose",
        "jam": "22:00",
        "tanggal": "2025-02-19",
        "status": "Sudah"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Gluco Care",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: _buildIconButton(
            icon: FontAwesomeIcons.chevronLeft,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NavBottom())),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _buildIconButton(
              icon: FontAwesomeIcons.plus,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormCareScreen())),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 12),
            _buildSectionTitle("Jadwal Minum Obat"),
            _buildScrollableCardList(context, jadwalObat, riwayatObat),
            const SizedBox(height: 12),
            _buildSectionTitle("Riwayat Minum Obat"),
            _buildScrollableCardList(context, riwayatObat, riwayatObat),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    DateTime today = DateTime.now();
    List<DateTime> upcomingDays =
        List.generate(7, (index) => today.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Tanggal Hari Ini",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: upcomingDays.length,
            itemBuilder: (context, index) {
              DateTime date = upcomingDays[index];
              bool isToday = date.day == today.day &&
                  date.month == today.month &&
                  date.year == today.year;

              return Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: isToday ? const Color(0xFFE8F3F1) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: isToday ? const Color(0xFF199A8E) : Colors.grey,
                      ),
                    ),
                    Text(
                      DateFormat('E').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isToday ? const Color(0xFF199A8E) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildScrollableCardList(BuildContext context,
      List<Map<String, dynamic>> data, List<Map<String, dynamic>> riwayatObat) {
    double cardHeight = 70.0;
    bool isScrollable = data.length > 3;

    return SizedBox(
      height: isScrollable ? cardHeight * 3.5 : null,
      child: isScrollable
          ? ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) =>
                  _buildCard(context, data[index], riwayatObat),
            )
          : Column(
              children: data
                  .map((item) => _buildCard(context, item, riwayatObat))
                  .toList(),
            ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> data,
      List<Map<String, dynamic>> riwayatObat) {
    Color statusColor = data["status"] == "Sudah" ? Colors.green : Colors.red;
    IconData statusIcon = data["status"] == "Sudah"
        // ignore: deprecated_member_use
        ? FontAwesomeIcons.checkCircle
        // ignore: deprecated_member_use
        : FontAwesomeIcons.exclamationCircle;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3F1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor, size: 28),
        title: Text(
          data["nama"],
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Row(children: [
          Text(
            '${data["tanggal"]}',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(width: 10),
          Text(
            "Jam: ${data["jam"]}",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ]),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            data["status"],
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: statusColor),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => data["status"] == "Sudah"
                  ? RiwayatCareScreen(riwayatObat: riwayatObat)
                  : EditCareScreen(data: data),
            ),
          );
        },
      ),
    );
  }
}
