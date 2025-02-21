import 'package:flutter/material.dart';

class DetailReminderScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailReminderScreen({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _DetailReminderScreenState createState() => _DetailReminderScreenState();
}

class _DetailReminderScreenState extends State<DetailReminderScreen> {
  late TextEditingController namaController;
  late TextEditingController jamController;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.data["nama"]);
    jamController = TextEditingController(text: widget.data["jam"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Jadwal Obat")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Obat"),
            ),
            TextField(
              controller: jamController,
              decoration: const InputDecoration(labelText: "Jam Minum Obat"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}