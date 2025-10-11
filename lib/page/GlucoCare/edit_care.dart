import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/services/care_services.dart';
import 'package:medical_app/components/alert.dart'; // Import komponen alert

class EditCareScreen extends StatefulWidget {
  final Map<String, dynamic> alarm;

  const EditCareScreen({super.key, required this.alarm});

  @override
  State<EditCareScreen> createState() => _EditCareScreenState();
}

class _EditCareScreenState extends State<EditCareScreen> {
  late TextEditingController namaObatController;
  late TextEditingController dosisController;
  late TextEditingController timeController;

  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTimeObat;
  bool isLoading = false;
  String? originalTime;

  @override
  void initState() {
    super.initState();
    namaObatController = TextEditingController(text: widget.alarm["nama_obat"]);
    dosisController = TextEditingController(text: widget.alarm["dosis"]);
    selectedDate = _parseDate(widget.alarm["tanggal"]) ?? DateTime.now();
    originalTime = widget.alarm["jam_minum"];
    
    if (originalTime != null) {
      final timeParts = originalTime!.split(':');
      if (timeParts.length >= 2) {
        selectedTimeObat = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
        timeController = TextEditingController(
          text: "${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}",
        );
      }
    } else {
      timeController = TextEditingController();
    }
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

  @override
  void dispose() {
    namaObatController.dispose();
    dosisController.dispose();
    timeController.dispose();
    super.dispose();
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
              onPressed: () => Get.back(),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (originalTime != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF199A8E)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Waktu sebelumnya: ${_formatOriginalTime(originalTime!)}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF199A8E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              _buildDateSelector(),
              const SizedBox(height: 16),
              _buildTextField(
                  namaObatController, "Nama Obat", FontAwesomeIcons.pills),
              _buildTextField(dosisController, "Dosis (mg/ml)",
                  FontAwesomeIcons.prescriptionBottle),
              _buildTimePickerField(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatOriginalTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return "${parts[0]}:${parts[1]}";
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  Widget _buildDateSelector() {
    DateTime today = DateTime.now();
    List<DateTime> futureDates = List.generate(
      14, 
      (index) => today.add(Duration(days: index)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Tanggal",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: futureDates.length,
            itemBuilder: (context, index) {
              DateTime date = futureDates[index];
              bool isSelected = date.day == selectedDate.day &&
                  date.month == selectedDate.month &&
                  date.year == selectedDate.year;

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
                    color: isSelected
                        ? const Color(0xFF199A8E)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF199A8E) : Colors.grey,
                    ),
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

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFFE5E7EB).withOpacity(0.5), width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: timeController,
        readOnly: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          labelText: "Jam Minum Obat",
          prefixIcon:
              const Icon(FontAwesomeIcons.clock, color: Color(0xFF199A8E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFFE5E7EB).withOpacity(0.5), width: 1.5),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.access_time, color: Color(0xFF199A8E)),
            onPressed: _selectTime,
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    FocusScope.of(context).requestFocus(FocusNode());
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTimeObat ?? TimeOfDay.now(),
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
      setState(() {
        selectedTimeObat = pickedTime;
        timeController.text = 
          "${pickedTime.hour.toString().padLeft(2, '0')}:"
          "${pickedTime.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _saveCare,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Simpan Perubahan",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }

  Future<void> _saveCare() async {
    final namaObat = namaObatController.text.trim();
    final dosis = dosisController.text.trim();
    final jamMinum = timeController.text.trim();

    if (namaObat.isEmpty || dosis.isEmpty || jamMinum.isEmpty) {
      CustomAlert.showMessageDialog(
        context: context,
        title: "Peringatan",
        message: "Harap lengkapi semua data.",
        isSuccess: false,
      );
      return;
    }

    if (!_isValidTimeFormat(jamMinum)) {
      CustomAlert.showMessageDialog(
        context: context,
        title: "Format Salah",
        message: "Format waktu tidak valid. Gunakan format HH:mm",
        isSuccess: false,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final tanggalFormatted = DateFormat('yyyy-MM-dd').format(selectedDate);
      final jamMinumFormatted = "$jamMinum:00"; // Tambahkan detik
      
      await CareServices.editCare(
        context,
        widget.alarm["id_care"],
        tanggal: tanggalFormatted,
        namaObat: namaObat,
        dosis: dosis,
        jamMinum: jamMinumFormatted,
      );
      
    } catch (e) {
      print("Error saat menyimpan data: $e");
      CustomAlert.showMessageDialog(
        context: context,
        title: "Error",
        message: "Terjadi kesalahan. Coba lagi nanti.",
        isSuccess: false,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }
}