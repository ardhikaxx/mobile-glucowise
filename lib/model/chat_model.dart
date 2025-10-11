import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class ChatMessage {
  final int idMessage;
  final int idConversation;
  final String senderType;
  final String message;
  final int isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.idMessage,
    required this.idConversation,
    required this.senderType,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Helper function untuk safe integer parsing
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('Error parsing int: $value');
          return 0;
        }
      }
      return 0;
    }

    // Helper function untuk safe datetime parsing dengan konversi ke waktu lokal
    DateTime safeParseDateTime(dynamic value) {
      if (value == null) return DateTime.now().toLocal();
      if (value is DateTime) return value.toLocal();
      if (value is String) {
        try {
          final parsed = DateTime.parse(value).toLocal();
          return parsed;
        } catch (e) {
          print('Error parsing datetime: $value');
          return DateTime.now().toLocal();
        }
      }
      return DateTime.now().toLocal();
    }

    return ChatMessage(
      idMessage: safeParseInt(json['id_message']),
      idConversation: safeParseInt(json['id_conversation']),
      senderType: json['sender_type']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      isRead: safeParseInt(json['is_read']),
      createdAt: safeParseDateTime(json['created_at']),
      updatedAt: safeParseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_message': idMessage,
      'id_conversation': idConversation,
      'sender_type': senderType,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
    };
  }

  bool get isUser => senderType == 'pengguna';
  bool get isDoctor => senderType == 'dokter';
  bool get isReadStatus => isRead == 1;
}

class Conversation {
  final int idConversation;
  final String nik;
  final int idAdmin;
  final String status;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Dokter dokter;
  final ChatMessage? lastMessage;

  Conversation({
    required this.idConversation,
    required this.nik,
    required this.idAdmin,
    required this.status,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    required this.dokter,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    // Helper function untuk safe integer parsing
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('Error parsing int: $value');
          return 0;
        }
      }
      return 0;
    }

    // Helper function untuk safe datetime parsing dengan konversi ke waktu lokal
    DateTime safeParseDateTime(dynamic value) {
      if (value == null) return DateTime.now().toLocal();
      if (value is DateTime) return value.toLocal();
      if (value is String) {
        try {
          final parsed = DateTime.parse(value).toLocal();
          return parsed;
        } catch (e) {
          print('Error parsing datetime: $value');
          return DateTime.now().toLocal();
        }
      }
      return DateTime.now().toLocal();
    }

    DateTime? safeParseDateTimeNullable(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value.toLocal();
      if (value is String) {
        try {
          final parsed = DateTime.parse(value).toLocal();
          return parsed;
        } catch (e) {
          print('Error parsing datetime: $value');
          return null;
        }
      }
      return null;
    }

    return Conversation(
      idConversation: safeParseInt(json['id_conversation']),
      nik: json['nik']?.toString() ?? '',
      idAdmin: safeParseInt(json['id_admin']),
      status: json['status']?.toString() ?? 'active',
      lastMessageAt: safeParseDateTimeNullable(json['last_message_at']),
      createdAt: safeParseDateTime(json['created_at']),
      updatedAt: safeParseDateTime(json['updated_at']),
      dokter: Dokter.fromJson(json['dokter'] ?? {}),
      lastMessage: json['last_message'] != null
          ? ChatMessage.fromJson(json['last_message'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_conversation': idConversation,
      'nik': nik,
      'id_admin': idAdmin,
      'status': status,
      'last_message_at': lastMessageAt?.toUtc().toIso8601String(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'dokter': dokter.toJson(),
      'last_message': lastMessage?.toJson(),
    };
  }

  String get lastMessageText {
    if (lastMessage == null) return 'Belum ada pesan';
    return lastMessage!.message;
  }

  String get lastMessageTime {
    if (lastMessage == null) return '';
    final now = DateTime.now().toLocal();
    final messageTime = lastMessage!.createdAt;
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}j';
    if (difference.inDays < 7) return '${difference.inDays}h';

    return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
  }

  bool get hasUnreadMessage {
    return lastMessage != null &&
        lastMessage!.isRead == 0 &&
        lastMessage!.isDoctor;
  }

  bool get isActive => status == 'active';
}

class Dokter {
  final int idAdmin;
  final String namaLengkap;
  final String jenisKelamin;
  final String? nomorTelepon;
  final String? spesialisasi;

  Dokter({
    required this.idAdmin,
    required this.namaLengkap,
    required this.jenisKelamin,
    this.nomorTelepon,
    this.spesialisasi,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) {
    // Helper function untuk safe integer parsing
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          print('Error parsing int: $value');
          return 0;
        }
      }
      return 0;
    }

    // Extract spesialisasi dari nama lengkap
    String? extractSpesialisasi(String namaLengkap) {
      if (namaLengkap.contains(',')) {
        return namaLengkap.split(',')[1].trim();
      }
      return null;
    }

    return Dokter(
      idAdmin: safeParseInt(json['id_admin']),
      namaLengkap: json['nama_lengkap']?.toString() ?? 'Dokter',
      jenisKelamin: json['jenis_kelamin']?.toString() ?? 'Laki-laki',
      nomorTelepon: json['nomor_telepon']?.toString(),
      spesialisasi: extractSpesialisasi(json['nama_lengkap']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_admin': idAdmin,
      'nama_lengkap': namaLengkap,
      'jenis_kelamin': jenisKelamin,
      'nomor_telepon': nomorTelepon,
      'spesialisasi': spesialisasi,
    };
  }

  String get namaSingkat {
    final names = namaLengkap.split(',')[0];
    return names;
  }

  String get avatarText {
    final names = namaSingkat.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}';
    }
    return namaSingkat.length >= 2 ? namaSingkat.substring(0, 2) : namaSingkat;
  }

  Color get genderColor {
    return jenisKelamin == 'Perempuan'
        ? const Color(0xFFEC407A)
        : const Color(0xFF42A5F5);
  }

  String get spesialisasiDisplay {
    if (spesialisasi != null && spesialisasi!.isNotEmpty) {
      return spesialisasi!;
    }

    if (namaLengkap.contains(',')) {
      return namaLengkap.split(',')[1].trim();
    }

    return 'Dokter Umum';
  }
}

class SendMessageRequest {
  final String idConversation;
  final String senderType;
  final String message;

  SendMessageRequest({
    required this.idConversation,
    required this.senderType,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_conversation': idConversation,
      'sender_type': senderType,
      'message': message,
    };
  }
}

class SendMessageResponse {
  final bool success;
  final ChatMessage? data;
  final String? message;

  SendMessageResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      success: json['success'] ?? false,
      data: json['data'] != null ? ChatMessage.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class GetMessagesResponse {
  final bool success;
  final List<ChatMessage> data;
  final String? message;

  GetMessagesResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetMessagesResponse.fromJson(Map<String, dynamic> json) {
    return GetMessagesResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => ChatMessage.fromJson(e)).toList()
          : [],
      message: json['message'],
    );
  }
}

class GetConversationsResponse {
  final bool success;
  final List<Conversation> data;
  final String? message;

  GetConversationsResponse({
    required this.success,
    required this.data,
    this.message,
  });

  factory GetConversationsResponse.fromJson(Map<String, dynamic> json) {
    return GetConversationsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? (json['data'] as List).map((e) => Conversation.fromJson(e)).toList()
          : [],
      message: json['message'],
    );
  }
}

class MarkAsReadRequest {
  final String idMessage;

  MarkAsReadRequest({
    required this.idMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_message': idMessage,
    };
  }
}

class MarkAsReadResponse {
  final bool success;
  final String? message;

  MarkAsReadResponse({
    required this.success,
    this.message,
  });

  factory MarkAsReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkAsReadResponse(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}

// Model untuk create conversation
class CreateConversationRequest {
  final String nik;
  final String idAdmin;

  CreateConversationRequest({
    required this.nik,
    required this.idAdmin,
  });

  Map<String, dynamic> toJson() {
    return {
      'nik': nik,
      'id_admin': idAdmin,
    };
  }
}

class CreateConversationResponse {
  final bool success;
  final Map<String, dynamic>? data;
  final String? message;

  CreateConversationResponse({
    required this.success,
    this.data,
    this.message,
  });

  factory CreateConversationResponse.fromJson(Map<String, dynamic> json) {
    return CreateConversationResponse(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'],
    );
  }
}

// Utility class untuk chat operations dengan timezone support
class ChatUtils {
  static String? _currentTimeZone;

  // Initialize timezone
  static Future<void> initializeTimezone() async {
    try {
      _currentTimeZone = (await FlutterTimezone.getLocalTimezone()) as String?;
      print('Current timezone: $_currentTimeZone');
    } catch (e) {
      print('Error getting timezone: $e');
      _currentTimeZone = 'Asia/Jakarta'; // fallback
    }
  }

  static String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now().toLocal();
    final messageTime = dateTime.toLocal();
    final difference = now.difference(messageTime);

    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}j';
    if (difference.inDays < 7) return '${difference.inDays}h';

    return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
  }

  static String formatMessageTimeDetailed(DateTime dateTime) {
    final now = DateTime.now().toLocal();
    final messageTime = dateTime.toLocal();
    final difference = now.difference(messageTime);

    if (difference.inDays == 0) {
      return '${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Kemarin ${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year} ${messageTime.hour.toString().padLeft(2, '0')}:${messageTime.minute.toString().padLeft(2, '0')}';
    }
  }

  static bool shouldShowTimeSeparator(
    ChatMessage currentMessage,
    ChatMessage? previousMessage,
  ) {
    if (previousMessage == null) return true;

    final currentTime = currentMessage.createdAt.toLocal();
    final previousTime = previousMessage.createdAt.toLocal();
    final timeDifference = currentTime.difference(previousTime);

    return timeDifference.inMinutes >= 5;
  }

  static String getTimeSeparatorText(DateTime dateTime) {
    final now = DateTime.now().toLocal();
    final messageTime = dateTime.toLocal();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(messageTime.year, messageTime.month, messageTime.day);

    if (messageDate == today) {
      return 'Hari Ini';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Kemarin';
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }

  // Method untuk mendapatkan waktu Jakarta secara eksplisit
  static DateTime toJakartaTime(DateTime dateTime) {
    // Asia/Jakarta adalah UTC+7 atau UTC+8 (tidak ada DST)
    // Untuk simplicity, kita gunakan UTC+7
    return dateTime.toLocal();
  }

  // Method untuk format waktu dengan timezone info
  static String formatMessageTimeWithZone(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    final timeString = formatMessageTimeDetailed(localTime);
    return '$timeString WIB';
  }
}

// Enum untuk sender type
enum SenderType {
  pengguna('pengguna'),
  dokter('dokter');

  final String value;
  const SenderType(this.value);

  factory SenderType.fromString(String value) {
    switch (value) {
      case 'pengguna':
        return SenderType.pengguna;
      case 'dokter':
        return SenderType.dokter;
      default:
        return SenderType.pengguna;
    }
  }
}

// Enum untuk message status
enum MessageStatus {
  unread(0),
  read(1);

  final int value;
  const MessageStatus(this.value);

  factory MessageStatus.fromInt(int value) {
    switch (value) {
      case 0:
        return MessageStatus.unread;
      case 1:
        return MessageStatus.read;
      default:
        return MessageStatus.unread;
    }
  }
}

// Extension methods untuk memudahkan penggunaan
extension ChatMessageExtensions on ChatMessage {
  bool get isFromUser => senderType == 'pengguna';
  bool get isFromDoctor => senderType == 'dokter';
  MessageStatus get status => MessageStatus.fromInt(isRead);
  
  // Get waktu dalam format lokal
  DateTime get localCreatedAt => createdAt.toLocal();
  DateTime get localUpdatedAt => updatedAt.toLocal();
}

extension ConversationExtensions on Conversation {
  bool get hasRecentActivity {
    if (lastMessage == null) return false;
    final now = DateTime.now().toLocal();
    final messageTime = lastMessage!.createdAt.toLocal();
    final difference = now.difference(messageTime);
    return difference.inDays < 30; // Active dalam 30 hari terakhir
  }

  String get displayStatus {
    if (!isActive) return 'Tidak Aktif';
    if (hasUnreadMessage) return 'Pesan Baru';
    return 'Aktif';
  }
  
  // Get waktu dalam format lokal
  DateTime get localCreatedAt => createdAt.toLocal();
  DateTime get localUpdatedAt => updatedAt.toLocal();
  DateTime? get localLastMessageAt => lastMessageAt?.toLocal();
}