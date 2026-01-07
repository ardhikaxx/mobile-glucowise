import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/model/chat_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/services/chat_services.dart';
import 'dart:async';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String dokterName;
  final String? dokterSpesialisasi;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.dokterName,
    this.dokterSpesialisasi,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String _errorMessage = '';

  Timer? _pollingTimer;
  int _lastMessageId = 0;
  bool _isPolling = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _startPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isPolling && !_isLoading) {
        _checkForNewMessages();
      }
    });
  }

  Future<void> _checkForNewMessages() async {
    if (_isPolling || _isLoading) return;

    setState(() {
      _isPolling = true;
    });

    try {
      final messages = await ChatServices.getMessages(widget.conversationId);

      if (messages.isNotEmpty) {
        final latestMessage = messages.last;

        if (latestMessage.idMessage > _lastMessageId) {
          setState(() {
            _messages = messages;
            _lastMessageId = latestMessage.idMessage;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });

          _markUnreadMessagesAsRead();
        }
      }
    } catch (e) {
      print('Error checking new messages: $e');
    } finally {
      setState(() {
        _isPolling = false;
      });
    }
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final messages = await ChatServices.getMessages(widget.conversationId);

      setState(() {
        _messages = messages;
        _isLoading = false;
        if (messages.isNotEmpty) {
          _lastMessageId = messages.last.idMessage;
        }
      });
      _markUnreadMessagesAsRead();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });

      Get.snackbar(
        'Error',
        _errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _markUnreadMessagesAsRead() async {
    try {
      for (final message in _messages) {
        if (message.isDoctor && message.isRead == 0) {
          await ChatServices.markAsRead(message.idMessage.toString());
        }
      }
    } catch (e) {
      print('Error marking messages as read: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    setState(() {
      _isSending = true;
    });

    try {
      final result = await ChatServices.sendMessage(
        conversationId: widget.conversationId,
        message: messageText,
      );

      if (result['success'] == true) {
        final newMessage = result['message'] as ChatMessage;

        setState(() {
          _messages.add(newMessage);
          _lastMessageId = newMessage.idMessage;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });

        // Refresh untuk mendapatkan data terbaru
        _loadMessages();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      _messageController.text = messageText;
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  Future<void> _refreshMessages() async {
    await _loadMessages();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // if (!isUser) ...[
          //   Container(
          //     width: 28,
          //     height: 28,
          //     decoration: BoxDecoration(
          //       color: const Color(0xFF199A8E),
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Center(
          //       child: Icon(
          //         FontAwesomeIcons.userDoctor,
          //         color: Colors.white,
          //         size: 16,
          //       ),
          //     ),
          //   ),
          //   const SizedBox(width: 8),
          // ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF199A8E) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.createdAt),
                    style: TextStyle(
                      color: isUser ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (isUser) ...[
          //   const SizedBox(width: 8),
          //   Container(
          //     width: 28,
          //     height: 28,
          //     decoration: BoxDecoration(
          //       color: Colors.grey[300],
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Center(
          //       child: Icon(
          //         Icons.person,
          //         color: Colors.white,
          //         size: 16,
          //       ),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return ChatUtils.formatMessageTimeDetailed(dateTime);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Memuat pesan...',
            style: TextStyle(
              color: Color(0xFF199A8E),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              color: Colors.red[400],
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Gagal Memuat Pesan',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadMessages,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: const Color(0xFF199A8E),
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum Ada Pesan',
            style: TextStyle(
              color: Color(0xFF199A8E),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai percakapan ${widget.dokterName}',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_messages.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshMessages,
      backgroundColor: Colors.white,
      color: const Color(0xFF199A8E),
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          return _buildMessageBubble(_messages[index]);
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ketik pesan...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add attachment functionality here
                    },
                    icon: Icon(
                      Icons.attach_file_rounded,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF199A8E),
                  Color(0xFF34B3A0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF199A8E).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: _isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dokterName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF199A8E),
                fontFamily: 'DarumadropOne',
              ),
            ),
            if (widget.dokterSpesialisasi != null) ...[
              const SizedBox(height: 2),
              Text(
                widget.dokterSpesialisasi!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF199A8E),
                  fontFamily: 'DarumadropOne',
                ),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
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
        actions: [
          Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _refreshMessages,
              icon: const Icon(
                FontAwesomeIcons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }
}