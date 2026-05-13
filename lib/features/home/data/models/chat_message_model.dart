import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String id;
  final String? text;
  final String senderId;
  final String senderName;
  final DateTime timestamp;
  final String? imageBase64;
  final List<String> reactions;

  ChatMessageModel({
    required this.id,
    this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
    this.imageBase64,
    this.reactions = const [],
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatMessageModel(
      id: id,
      text: map['text'] as String?,
      senderId: map['senderId'] as String? ?? '',
      senderName: map['senderName'] as String? ?? '',
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageBase64: map['imageBase64'] as String?,
      reactions: (map['reactions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (text != null) 'text': text,
      'senderId': senderId,
      'senderName': senderName,
      'timestamp': FieldValue.serverTimestamp(),
      if (imageBase64 != null) 'imageBase64': imageBase64,
      'reactions': reactions,
    };
  }
}
