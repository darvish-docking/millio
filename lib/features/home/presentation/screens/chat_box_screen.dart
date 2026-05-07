import 'dart:io';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatMessage {
  final String? text;
  final String time;
  final bool isSentByMe;
  final String? date;
  final List<String> reactions;
  final String? imageUrl; // Added for image support

  ChatMessage({
    this.text,
    required this.time,
    required this.isSentByMe,
    this.date,
    this.reactions = const [],
    this.imageUrl,
  });
}

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

  final List<ChatMessage> messages = [
    ChatMessage(text: "Hello! How can I help you today?", time: "10:00 AM", isSentByMe: false, date: "Today"),
    ChatMessage(text: "I'd like to check the status of my order #12345.", time: "10:05 AM", isSentByMe: true, reactions: ["😊"]),
    ChatMessage(text: "Of course! Let me check that for you.", time: "10:06 AM", isSentByMe: false),
    ChatMessage(text: "Your order is currently being prepared and will be out for delivery shortly.", time: "10:10 AM", isSentByMe: false, reactions: ["👍", "🥙"]),
    ChatMessage(text: "Thank you for the quick response! Can't wait to try it.", time: "10:12 AM", isSentByMe: true),
  ];

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

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        messages.add(ChatMessage(
          text: text,
          time: DateFormat('hh:mm a').format(DateTime.now()),
          isSentByMe: true,
        ));
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  Future<void> _handleImageUpload(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        setState(() {
          messages.add(ChatMessage(
            time: DateFormat('hh:mm a').format(DateTime.now()),
            isSentByMe: true,
            imageUrl: image.path,
          ));
        });
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.04;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- CUSTOM HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
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

            // --- DISPLAY AREA (Chat History) ---
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: padding),
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  bool showDate = msg.date != null;

                  return Column(
                    children: [
                      if (showDate)
                        Padding(
                          padding: EdgeInsets.only(top: h * 0.01, bottom: h * 0.025),
                          child: Center(
                            child: Text(
                              msg.date!,
                              style: TextStyle(
                                color: AppColorsLegacy.backgroundSecondary4,
                                fontSize: w * 0.035,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      _buildMessageBubble(msg, w, h),
                    ],
                  );
                },
              ),
            ),

            // --- BOTTOM INPUT AREA ---
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
                    
                    // Vertical Separator
                    Container(
                      height: 18,
                      width: 1,
                      color: AppColorsLegacy.backgroundSecondary2,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                    ),

                    // Contextual Action Buttons
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isTyping
                          ? IconButton(
                              key: const ValueKey("send"),
                              icon:  Icon(Icons.send, color: AppColorsLegacy.primary),
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

  Widget _buildMessageBubble(ChatMessage msg, double w, double h) {
    final colors = context.colors;

    return Align(
      alignment: msg.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          setState(() {
            if (msg.reactions.contains("❤️")) {
              msg.reactions.remove("❤️");
            } else {
              msg.reactions.add("❤️");
            }
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: h * 0.022),
              constraints: BoxConstraints(maxWidth: w * 0.72),
              padding: EdgeInsets.all(msg.imageUrl != null ? 4 : w * 0.04),
              decoration: BoxDecoration(
                color: msg.isSentByMe ? AppColorsLegacy.primary : colors.textField,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.045),
                  topRight: Radius.circular(w * 0.045),
                  bottomLeft: Radius.circular(msg.isSentByMe ? w * 0.045 : 0),
                  bottomRight: Radius.circular(msg.isSentByMe ? 0 : w * 0.045),
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
                  if (msg.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(w * 0.035),
                      child: Image.file(
                        File(msg.imageUrl!),
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
                      padding: EdgeInsets.all(msg.imageUrl != null ? 8 : 0),
                      child: Text(
                        msg.text!,
                        style: TextStyle(
                          color: msg.isSentByMe ? AppColorsLegacy.background : colors.hintText,
                          fontFamily: 'Montserrat',
                          fontSize: w * 0.038,
                          height: 1.45,
                        ),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: msg.imageUrl != null ? 8 : 0, vertical: 4),
                    child: Align(
                      alignment: msg.isSentByMe ? Alignment.bottomLeft : Alignment.bottomRight,
                      child: Text(
                        msg.time,
                        style: TextStyle(
                          color: msg.isSentByMe ? AppColorsLegacy.background07 : AppColorsLegacy.backgroundSecondary5,
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
            if (msg.reactions.isNotEmpty)
              Positioned(
                bottom: h * 0.008,
                right: msg.isSentByMe ? null : -w * 0.01,
                left: msg.isSentByMe ? -w * 0.01 : null,
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: msg.reactions.map((r) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Text(r, style: const TextStyle(fontSize: 13)),
                    )).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
