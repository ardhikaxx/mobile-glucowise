import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  final String conversationId;
  final String dokterName;

  const ChatPage({
    Key? key,
    required this.conversationId,
    required this.dokterName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          dokterName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF199A8E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.chat,
              size: 64,
              color: Color(0xFF199A8E),
            ),
            const SizedBox(height: 16),
            Text(
              'Chat dengan $dokterName',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conversation ID: $conversationId',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF199A8E),
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}