import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medical_app/model/chat_model.dart';
import 'package:medical_app/services/connect.dart';
import 'package:medical_app/utils/session_manager.dart';

class ChatServices {
  static const String _errorNikNotFound = "NIK tidak ditemukan. Silakan login ulang.";

  static Future<void> initialize() async {
    await ChatUtils.initializeTimezone();
  }

  // Get messages from conversation
  static Future<List<ChatMessage>> getMessages(String conversationId) async {
    try {
      print('Fetching messages for conversation: $conversationId');

      final response = await http.get(
        Uri.parse('$apiConnect/api/chat/messages/$conversationId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> messagesData = data['data'] ?? [];
          print('Found ${messagesData.length} messages');

          List<ChatMessage> messages = [];
          for (var messageData in messagesData) {
            try {
              final message = ChatMessage.fromJson(messageData);
              messages.add(message);
            } catch (e) {
              print('Error parsing message: $e');
              print('Message data: $messageData');
              // Continue with other messages
            }
          }

          // Sort messages by timestamp untuk memastikan urutan benar
          messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

          return messages;
        } else {
          throw Exception(data['message'] ?? 'Gagal mengambil pesan');
        }
      } else {
        throw Exception('Gagal mengambil pesan (${response.statusCode})');
      }
    } catch (e) {
      print('Error in getMessages: $e');
      throw Exception('Gagal mengambil pesan: ${e.toString()}');
    }
  }

  // Get new messages only (untuk polling)
  static Future<List<ChatMessage>> getNewMessages(
      String conversationId, int lastMessageId) async {
    try {
      final allMessages = await getMessages(conversationId);

      // Filter hanya pesan yang lebih baru dari lastMessageId
      final newMessages = allMessages
          .where((message) => message.idMessage > lastMessageId)
          .toList();

      print('Found ${newMessages.length} new messages');
      return newMessages;
    } catch (e) {
      print('Error in getNewMessages: $e');
      throw Exception('Gagal mengambil pesan baru: ${e.toString()}');
    }
  }

  // Send message
  static Future<Map<String, dynamic>> sendMessage({
    required String conversationId,
    required String message,
  }) async {
    try {
      print('Sending message to conversation: $conversationId');
      print('Message: $message');

      final response = await http.post(
        Uri.parse('$apiConnect/api/chat/send-message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_conversation': conversationId,
          'sender_type': 'pengguna',
          'message': message,
        }),
      );

      print('Send message response status: ${response.statusCode}');
      print('Send message response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          try {
            final chatMessage = ChatMessage.fromJson(data['data']);
            return {
              'success': true,
              'message': chatMessage,
            };
          } catch (e) {
            print('Error parsing sent message: $e');
            print('Message data: ${data['data']}');
            throw Exception('Gagal memproses pesan yang dikirim');
          }
        } else {
          throw Exception(data['message'] ?? 'Gagal mengirim pesan');
        }
      } else {
        throw Exception('Gagal mengirim pesan (${response.statusCode})');
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      throw Exception('Gagal mengirim pesan: ${e.toString()}');
    }
  }

  // Mark message as read
  static Future<void> markAsRead(String messageId) async {
    try {
      print('Marking message as read: $messageId');

      final response = await http.post(
        Uri.parse('$apiConnect/api/chat/mark-read'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'id_message': messageId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] != true) {
          print('Failed to mark as read: ${data['message']}');
        }
      } else {
        print('Failed to mark as read (${response.statusCode})');
      }
    } catch (e) {
      // Jangan throw error untuk mark as read agar tidak mengganggu user experience
      print('Error marking message as read: $e');
    }
  }

  // Get user conversations
  static Future<List<Conversation>> getConversations() async {
    try {
      final String? nik = await SessionManager.getNik();

      if (nik == null) {
        throw Exception(_errorNikNotFound);
      }

      print('Fetching conversations for NIK: $nik');

      final response = await http.get(
        Uri.parse('$apiConnect/api/chat/conversations/$nik'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Conversations response status: ${response.statusCode}');
      print('Conversations response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true) {
          List<dynamic> conversationsData = data['data'] ?? [];
          print('Found ${conversationsData.length} conversations');

          List<Conversation> conversations = [];
          for (var convData in conversationsData) {
            try {
              final conversation = Conversation.fromJson(convData);
              conversations.add(conversation);
            } catch (e) {
              print('Error parsing conversation: $e');
              print('Conversation data: $convData');
              // Continue with other conversations
            }
          }

          return conversations;
        } else {
          throw Exception(
              data['message'] ?? 'Gagal mengambil riwayat konsultasi');
        }
      } else {
        throw Exception(
            'Gagal mengambil riwayat konsultasi (${response.statusCode})');
      }
    } catch (e) {
      print('Error in getConversations: $e');
      throw Exception('Gagal mengambil riwayat konsultasi: ${e.toString()}');
    }
  }
}
