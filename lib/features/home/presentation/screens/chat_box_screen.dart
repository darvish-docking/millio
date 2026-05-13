import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:millio/features/home/data/models/chat_message_model.dart';
import 'package:millio/features/home/presentation/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({super.key});

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        _isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    await context.read<ChatProvider>().sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
  }

  Future<void> _handleImageUpload(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );
      if (image != null) {
        await context.read<ChatProvider>().sendImage(File(image.path));
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _handleImageUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _handleImageUpload(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleReaction(String messageId) {
    context.read<ChatProvider>().toggleReaction(messageId, '❤️');
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(msgDate).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.04;
    final chat = context.watch<ChatProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          context.read<TabProvider>().goHome();
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColorsLegacy.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Text(
                    "Chat Box",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.call_outlined, color: colors.textPrimary, size: w * 0.06),
                    onPressed: () {},
                  ),
                  SizedBox(width: w * 0.04),
                  IconButton(
                    icon: Icon(Icons.warning_amber_rounded, color: colors.textPrimary, size: w * 0.06),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child: chat.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : chat.messages.isEmpty
                      ? Center(
                          child: Text(
                            "No messages yet. Start a conversation!",
                            style: TextStyle(
                              color: AppColorsLegacy.backgroundSecondary4,
                              fontSize: w * 0.04,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          physics: const BouncingScrollPhysics(),
                          itemCount: chat.messages.length,
                          itemBuilder: (context, index) {
                            final msg = chat.messages[index];
                            final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                            final isSentByMe = msg.senderId == currentUserId;
                            final showDate = index == 0 ||
                                chat.messages[index].timestamp.day != chat.messages[index - 1].timestamp.day ||
                                chat.messages[index].timestamp.month != chat.messages[index - 1].timestamp.month ||
                                chat.messages[index].timestamp.year != chat.messages[index - 1].timestamp.year;

                            return Column(
                              children: [
                                if (showDate)
                                  Padding(
                                    padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.025),
                                    child: Center(
                                      child: Text(
                                        _formatDate(msg.timestamp),
                                        style: TextStyle(
                                          color: AppColorsLegacy.backgroundSecondary4,
                                          fontSize: w * 0.035,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ),
                                  ),
                                _buildMessageBubble(msg, isSentByMe, w, h),
                              ],
                            );
                          },
                        ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(padding, 0, padding, padding * 0.5),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.045, vertical: h * 0.002),
                decoration: BoxDecoration(
                  color: colors.textField,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: colors.textField),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Write a message...",
                          hintStyle: TextStyle(
                            color: AppColorsLegacy.backgroundSecondary4,
                            fontFamily: 'Montserrat',
                            fontSize: w * 0.038,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: w * 0.04),
                      ),
                    ),
                    Container(
                      height: 18,
                      width: 1,
                      color: AppColorsLegacy.backgroundSecondary2,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: chat.isSending
                          ? Padding(
                              key: const ValueKey("sending"),
                              padding: EdgeInsets.all(w * 0.025),
                              child: SizedBox(
                                width: w * 0.05,
                                height: w * 0.05,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : _isTyping
                              ? IconButton(
                                  key: const ValueKey("send"),
                                  icon: Icon(Icons.send, color: AppColorsLegacy.primary),
                                  onPressed: _sendMessage,
                                )
                              : Row(
                                  key: const ValueKey("actions"),
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.camera_alt_outlined, color: AppColorsLegacy.backgroundSecondary4, size: w * 0.055),
                                      onPressed: _showImageSourceDialog,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.grid_view_sharp, color: AppColorsLegacy.backgroundSecondary4, size: w * 0.055),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessageModel msg, bool isSentByMe, double w, double h) {
    final colors = context.colors;
    final isHearted = msg.reactions.contains('❤️');

    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _toggleReaction(msg.id),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: h * 0.022),
              constraints: BoxConstraints(maxWidth: w * 0.72),
              padding: EdgeInsets.all(msg.imageBase64 != null ? 4 : w * 0.04),
              decoration: BoxDecoration(
                color: isSentByMe ? AppColorsLegacy.primary : colors.textField,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.045),
                  topRight: Radius.circular(w * 0.045),
                  bottomLeft: Radius.circular(isSentByMe ? w * 0.045 : 0),
                  bottomRight: Radius.circular(isSentByMe ? 0 : w * 0.045),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColorsLegacy.textPrimary.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.imageBase64 != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(w * 0.035),
                      child: Image.memory(
                        base64Decode(msg.imageBase64!),
                        width: w * 0.7,
                        height: h * 0.25,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: w * 0.7,
                          height: h * 0.25,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    ),
                  if (msg.text != null)
                    Padding(
                      padding: EdgeInsets.all(msg.imageBase64 != null ? 8 : 0),
                      child: Text(
                        msg.text!,
                        style: TextStyle(
                          color: isSentByMe ? AppColorsLegacy.background : colors.hintText,
                          fontFamily: 'Montserrat',
                          fontSize: w * 0.038,
                          height: 1.45,
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: msg.imageBase64 != null ? 8 : 0, vertical: 4),
                    child: Align(
                      alignment: isSentByMe ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: Text(
                        DateFormat('hh:mm a').format(msg.timestamp),
                        style: TextStyle(
                          color: isSentByMe ? AppColorsLegacy.background07 : AppColorsLegacy.backgroundSecondary5,
                          fontSize: w * 0.025,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isHearted)
              Positioned(
                bottom: h * 0.008,
                right: isSentByMe ? null : -w * 0.01,
                left: isSentByMe ? -w * 0.01 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColorsLegacy.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorsLegacy.textPrimary.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: AppColorsLegacy.backgroundSecondary1),
                  ),
                  child: const Text("❤️", style: TextStyle(fontSize: 13)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
