import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class ChatMessage {
  final String text;
  final String time;
  final bool isSentByMe;
  final String? date;
  final List<String> reactions;

  ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByMe,
    this.date,
    this.reactions = const [],
  });
}

class ChatBoxScreen extends StatefulWidget {
  const ChatBoxScreen({super.key});

  @override
  State<ChatBoxScreen> createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  final TextEditingController _messageController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- CUSTOM HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  // Back Button
                  Material(
                    color: Colors.grey.shade100,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  
                  // Title
                  Text(
                    "Chat Box",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Outlined Icons (No Background)
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.call_outlined, color: Colors.black, size: w * 0.06),
                    onPressed: () {},
                  ),
                  SizedBox(width: w * 0.04),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(Icons.warning_amber_rounded, color: Colors.black, size: w * 0.06),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // --- DISPLAY AREA (Chat History) ---
            Expanded(
              child: ListView.builder(
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
                                color: Colors.grey.shade400,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Write a message...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
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
                      color: Colors.grey.shade200,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                    ),

                    // Contextual Action Buttons
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _isTyping
                          ? IconButton(
                              key: const ValueKey("send"),
                              icon: const Icon(Icons.send, color: AppColors.primary),
                              onPressed: () {
                                _messageController.clear();
                              },
                            )
                          : Row(
                              key: const ValueKey("actions"),
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400, size: w * 0.055),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: Icon(Icons.grid_view_sharp, color: Colors.grey.shade400, size: w * 0.055),
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
              padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: h * 0.014),
              decoration: BoxDecoration(
                color: msg.isSentByMe ? AppColors.primary : Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(w * 0.045),
                  topRight: Radius.circular(w * 0.045),
                  bottomLeft: Radius.circular(msg.isSentByMe ? w * 0.045 : 0),
                  bottomRight: Radius.circular(msg.isSentByMe ? 0 : w * 0.045),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isSentByMe ? Colors.white : Colors.black87,
                      fontFamily: 'Montserrat',
                      fontSize: w * 0.038,
                      height: 1.45,
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  Align(
                    alignment: msg.isSentByMe ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Text(
                      msg.time,
                      style: TextStyle(
                        color: msg.isSentByMe ? Colors.white70 : Colors.grey.shade500,
                        fontSize: w * 0.025,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // --- REACTIONS OVERLAY ---
            if (msg.reactions.isNotEmpty)
              Positioned(
                bottom: h * 0.008,
                right: msg.isSentByMe ? null : -w * 0.01,
                left: msg.isSentByMe ? -w * 0.01 : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
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
