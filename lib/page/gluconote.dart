import 'package:flutter/material.dart';

class GlucoNoteScreen extends StatelessWidget {
  const GlucoNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Halaman GlucoNote",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
