import 'package:flutter/material.dart';

class GlucoCheckScreen extends StatelessWidget {
  const GlucoCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Halaman GlucoCheck",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
