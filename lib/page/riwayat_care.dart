import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/components/navbottom.dart';

class RiwayatCareScreen extends StatelessWidget {
  final List<Map<String, dynamic>> riwayatObat;

  const RiwayatCareScreen({super.key, required this.riwayatObat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Riwayat Care',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBottom()),
                );
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: riwayatObat.isNotEmpty
            ? ListView.builder(
                itemCount: riwayatObat.length,
                itemBuilder: (context, index) {
                  return _buildRiwayatCard(riwayatObat[index]);
                },
              )
            : const Center(
                child: Text(
                  "Tidak ada riwayat minum obat.",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
      ),
    );
  }

  Widget _buildRiwayatCard(Map<String, dynamic> data) {
    Color statusColor = data["status"] == "Sudah" ? Colors.green : Colors.red;
    IconData statusIcon = data["status"] == "Sudah"
        // ignore: deprecated_member_use
        ? FontAwesomeIcons.checkCircle
        // ignore: deprecated_member_use
        : FontAwesomeIcons.exclamationCircle;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            "Tanggal: ${data["tanggal"]}",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(width: 8),
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
      ),
    );
  }
}
