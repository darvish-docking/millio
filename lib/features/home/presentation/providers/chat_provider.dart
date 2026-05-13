import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/home/data/models/chat_message_model.dart';

class ChatProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ChatMessageModel> _messages = [];
  bool _isLoading = false;
  String? _error;
  bool _isSending = false;
  StreamSubscription? _subscription;

  List<ChatMessageModel> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isSending => _isSending;

  ChatProvider() {
    _init();
  }

  void _init() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      _auth.authStateChanges().listen((user) {
        if (user != null) _startListening(user.uid);
      });
      return;
    }
    _startListening(uid);
  }

  void _startListening(String uid) {
    _isLoading = true;
    notifyListeners();
    _subscription?.cancel();
    _subscription = _db.getChatMessages(uid).listen(
      (messages) {
        _messages = messages;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (e) {
        _error = 'Failed to load messages';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> sendMessage(String text) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || text.trim().isEmpty || _isSending) return;
    _isSending = true;
    notifyListeners();
    try {
      final displayName = _auth.currentUser?.displayName ?? 'User';
      await _db.sendMessage(
        uid: uid,
        senderName: displayName,
        text: text.trim(),
      );
    } catch (e) {
      _error = 'Failed to send message';
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> sendImage(File image) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _isSending) return;
    _isSending = true;
    notifyListeners();
    try {
      final bytes = await image.readAsBytes();
      final base64Str = base64Encode(bytes);
      final displayName = _auth.currentUser?.displayName ?? 'User';
      await _db.sendMessage(
        uid: uid,
        senderName: displayName,
        imageBase64: base64Str,
      );
    } catch (e) {
      _error = 'Failed to send image';
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  Future<void> toggleReaction(String messageId, String reaction) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final msg = _messages.firstWhere((m) => m.id == messageId);
    final isAdding = !msg.reactions.contains(reaction);
    try {
      await _db.toggleReaction(
        chatId: uid,
        messageId: messageId,
        reaction: reaction,
        isAdding: isAdding,
      );
    } catch (e) {
      debugPrint('Error toggling reaction: $e');
    }
  }
}
