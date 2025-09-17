import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/services/check_services.dart';
import 'package:medical_app/components/alert.dart';

class GlucoCheckForm extends StatefulWidget {
  const GlucoCheckForm({super.key});

  @override
  State<GlucoCheckForm> createState() => _GlucoCheckFormState();
}

class _GlucoCheckFormState extends State<GlucoCheckForm> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalController = TextEditingController();
  final _tinggiController = TextEditingController();
  final _beratController = TextEditingController();
  final _gulaDarahController = TextEditingController();
  final _umurController = TextEditingController();
  final _lingkarPinggangController = TextEditingController();
  final _tensiController = TextEditingController();
  String? _selectedAnswer;
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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

    if (pickedDate != null) {
      setState(() {
        _tanggalController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedAnswer != null) {
      setState(() {
        isLoading = true;
      });

      try {
        await CheckServices.addCheck(
          context,
          tanggalPemeriksaan: _tanggalController.text,
          riwayatKeluargaDiabetes: _selectedAnswer!,
          umur: int.parse(_umurController.text),
          tinggiBadan: double.parse(_tinggiController.text),
          beratBadan: double.parse(_beratController.text),
          gulaDarah: double.parse(_gulaDarahController.text),
          lingkarPinggang: double.parse(_lingkarPinggangController.text),
          tensiDarah: double.parse(_tensiController.text),
        );
      } catch (e) {
        print("Error submitting form: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      CustomAlert.showMessageDialog(
        context: context,
        title: "Data Tidak Lengkap",
        message: "Harap lengkapi semua data termasuk riwayat keluarga diabetes.",
        isSuccess: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Form Gluco Check',
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
                Get.back();
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
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Fitur ini membantu mengecek risiko diabetes berdasarkan data kesehatan Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 15),
                    _buildDateInputField(),
                    const SizedBox(height: 15),
                    _buildFamilyHistoryCard(),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _umurController,
                      labelText: 'Umur',
                      prefixIcon: FontAwesomeIcons.calendarDays,
                      hint: 'Contoh: 35',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi umur';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _tinggiController,
                      labelText: 'Tinggi Badan (cm)',
                      prefixIcon: FontAwesomeIcons.ruler,
                      hint: 'Contoh: 170',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi tinggi badan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _beratController,
                      labelText: 'Berat Badan (kg)',
                      prefixIcon: FontAwesomeIcons.weightHanging,
                      hint: 'Contoh: 65',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi berat badan';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _gulaDarahController,
                      labelText: 'Hasil Tes Gula Darah (mg/dL)',
                      prefixIcon: FontAwesomeIcons.droplet,
                      hint: 'Contoh: 100',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi hasil tes gula darah';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _lingkarPinggangController,
                      labelText: 'Lingkar Pinggang (cm)',
                      prefixIcon: FontAwesomeIcons.ruler,
                      hint: 'Contoh: 100',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi lingkar pinggang';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      controller: _tensiController,
                      labelText: 'Hasil Tensi Darah (mmHg)',
                      prefixIcon: FontAwesomeIcons.heartCircleCheck,
                      hint: 'Contoh: 120/80',
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap isi hasil tensi darah';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildProcessButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateInputField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: _buildInputField(
          controller: _tanggalController,
          labelText: 'Tanggal Pemeriksaan',
          prefixIcon: FontAwesomeIcons.calendar,
          hint: 'Pilih Tanggal',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap pilih tanggal';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required String hint,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF199A8E)),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF199A8E)),
          suffixIcon: suffixIcon,
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
        validator: validator,
      ),
    );
  }

  Widget _buildFamilyHistoryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Apakah ada keluarga yang memiliki riwayat diabetes?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildAnswerCard("Ya"),
              const SizedBox(width: 20),
              _buildAnswerCard("Tidak"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(String answer) {
    bool isSelected = _selectedAnswer == answer;

    return GestureDetector(
      onTap: () => _selectAnswer(answer),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        color: isSelected ? const Color(0xFF199A8E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? Colors.white : const Color(0xFF199A8E),
                size: 30,
              ),
              const SizedBox(width: 12),
              Text(
                answer,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProcessButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Proses",
                style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
