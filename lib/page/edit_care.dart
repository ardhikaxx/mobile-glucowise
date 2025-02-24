import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class EditCareScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditCareScreen({super.key, required this.data});

  @override
  // ignore: library_private_types_in_public_api
  _EditCareScreenState createState() => _EditCareScreenState();
}

class _EditCareScreenState extends State<EditCareScreen> {
  late TextEditingController namaObatController;
  late TextEditingController dosisController;

  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTimeObat;
  TimeOfDay? selectedTimeMakan;

  @override
  void initState() {
    super.initState();
    namaObatController = TextEditingController(text: widget.data["nama"]);
    dosisController = TextEditingController(text: widget.data["dosis"]);

    // Parsing tanggal (jika dalam format String, ubah menjadi DateTime)
    selectedDate = _parseDate(widget.data["tanggal"]) ?? DateTime.now();

    // Parsing waktu
    selectedTimeObat = _parseTime(widget.data["jam_obat"]);
    selectedTimeMakan = _parseTime(widget.data["jam_makan"]);
  }

  DateTime? _parseDate(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) {
      try {
        return DateFormat("yyyy-MM-dd").parse(date);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  TimeOfDay? _parseTime(String? timeString) {
    if (timeString == null) return null;
    final timeParts = timeString.split(":");
    if (timeParts.length == 2) {
      return TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Edit Jadwal Obat",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateSelector(),
            const SizedBox(height: 16),
            _buildTextField(namaObatController, "Nama Obat", FontAwesomeIcons.pills),
            _buildTextField(dosisController, "Dosis (mg/ml)", FontAwesomeIcons.prescriptionBottle),
            _buildTimePickerField("Jam Minum Obat", selectedTimeObat, (time) {
              setState(() {
                selectedTimeObat = time;
              });
            }),
            _buildTimePickerField("Jam Minum Obat Setelah Makan", selectedTimeMakan, (time) {
              setState(() {
                selectedTimeMakan = time;
              });
            }),
            const SizedBox(height: 20),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    DateTime today = DateTime.now();
    List<DateTime> futureDates = List.generate(7, (index) => today.add(Duration(days: index)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Pilih Tanggal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: futureDates.length,
            itemBuilder: (context, index) {
              DateTime date = futureDates[index];
              bool isSelected = date.day == selectedDate.day;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF199A8E) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? const Color(0xFF199A8E) : Colors.grey),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('d').format(date),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        DateFormat('E').format(date),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF199A8E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerField(String label, TimeOfDay? selectedTime, Function(TimeOfDay) onTimePicked) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          labelText: label,
          prefixIcon: const Icon(FontAwesomeIcons.clock, color: Color(0xFF199A8E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.access_time, color: Color(0xFF199A8E)),
            onPressed: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? TimeOfDay.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.light().copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF199A8E),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                onTimePicked(pickedTime);
              }
            },
          ),
        ),
        controller: TextEditingController(
          text: selectedTime != null ? selectedTime.format(context) : "",
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context, {
            "nama": namaObatController.text,
            "dosis": dosisController.text,
            "tanggal": DateFormat("yyyy-MM-dd").format(selectedDate),
            "jam_obat": selectedTimeObat?.format(context),
            "jam_makan": selectedTimeMakan?.format(context),
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: const Text("Simpan Perubahan",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}