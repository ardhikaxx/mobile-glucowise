import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GlucoCheckForm extends StatelessWidget {
  GlucoCheckForm({super.key});

  final _formKey = GlobalKey<FormState>();
  final _tinggiController = TextEditingController();
  final _beratController = TextEditingController();
  final _gulaDarahController = TextEditingController();
  final _umurController = TextEditingController();
  final _tensiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
                  _buildInputField(
                    controller: _tinggiController,
                    labelText: 'Tinggi Badan (cm)',
                    prefixIcon: FontAwesomeIcons.ruler,
                    hint: 'Contoh: 170',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _beratController,
                    labelText: 'Berat Badan (kg)',
                    prefixIcon: FontAwesomeIcons.weightHanging,
                    hint: 'Contoh: 65',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _gulaDarahController,
                    labelText: 'Hasil Tes Gula Darah (mg/dL)',
                    prefixIcon: FontAwesomeIcons.droplet,
                    hint: 'Contoh: 100',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _umurController,
                    labelText: 'Umur',
                    prefixIcon: FontAwesomeIcons.calendarDays,
                    hint: 'Contoh: 35',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _tensiController,
                    labelText: 'Hasil Tensi Darah (mmHg)',
                    prefixIcon: FontAwesomeIcons.heartCircleCheck,
                    hint: 'Contoh: 120/80',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  _buildProcessButton(),
                ],
              ),
            ),
          ),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap isi field ini';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildProcessButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('prosesButton'),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Proses data
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF199A8E),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 5,
        ),
        child: const Text("Proses",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
