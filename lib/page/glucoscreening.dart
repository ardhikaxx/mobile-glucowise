import 'package:flutter/material.dart';

class GlucoScreeningScreen extends StatelessWidget {
  const GlucoScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Halaman Screening Diabetes",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
