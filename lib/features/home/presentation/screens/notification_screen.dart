import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/services/database_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DatabaseService _db = DatabaseService();
  late final String _uid;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  String _formatTime(dynamic createdAt) {
    if (createdAt == null) return 'Just now';
    try {
      DateTime dt;
      if (createdAt is Timestamp) {
        dt = createdAt.toDate();
      } else {
        return 'Just now';
      }
      return DateFormat('MMM d, yyyy').format(dt);
    } catch (_) {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: w * 0.05, vertical: h * 0.015),
              child: Row(
                children: [
                  // Back Button
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new,
                            size: w * 0.045,
                            color: AppColorsLegacy.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  // Title
                  Text(
                    "Notifications",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // More Menu
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.more_horiz,
                            color: AppColorsLegacy.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),

            // --- NOTIFICATION LIST ---
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _db.getNotifications(_uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Could not load notifications',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                    );
                  }

                  final notifications = snapshot.data ?? [];

                  if (notifications.isEmpty) {
                    return const Center(
                      child: Text(
                        'No notifications yet',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: notifications.length,
                    padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05, vertical: h * 0.01),
                    separatorBuilder: (context, index) => Divider(
                      color: AppColorsLegacy.primary,
                      thickness: 0.5,
                      height: 30,
                    ),
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final bool isRead = item['isRead'] ?? false;
                      final String title = item['title'] ?? '';
                      final String body = item['body'] ?? '';
                      final String timeText = _formatTime(item['createdAt']);
                      // Use imagePath from Firestore if present, fall back to default asset
                      final String imagePath = (item['imagePath'] as String?)?.isNotEmpty == true
                          ? item['imagePath'] as String
                          : 'assets/images/cart-icon.png';

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Custom Checkbox
                          Padding(
                            padding: EdgeInsets.only(top: h * 0.01),
                            child: GestureDetector(
                              onTap: () async {
                                try {
                                  await _db.toggleNotificationRead(
                                      _uid, item['id'], isRead);
                                } catch (_) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Failed to update notification'),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: w * 0.04,
                                height: w * 0.04,
                                decoration: BoxDecoration(
                                  color: isRead
                                      ? AppColorsLegacy.primary
                                      : AppColors.transparent,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isRead
                                        ? AppColorsLegacy.primary
                                        : AppColorsLegacy
                                            .backgroundSecondary4,
                                    width: 1.5,
                                  ),
                                ),
                                child: isRead
                                    ? Icon(Icons.check,
                                        size: 12,
                                        color: AppColorsLegacy.background)
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: w * 0.04),

                          // Icon with asset image and Unread Dot
                          Stack(
                            children: [
                              Container(
                                width: w * 0.13,
                                height: w * 0.13,
                                decoration: BoxDecoration(
                                  color: colors.textField,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Image.asset(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  color: AppColorsLegacy.textSecondary,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.notifications,
                                          color: AppColorsLegacy.textSecondary),
                                ),
                              ),
                              // Unread Red Dot
                              if (!isRead)
                                Positioned(
                                  right: 2,
                                  top: 2,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: AppColorsLegacy.error,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColorsLegacy.background,
                                          width: 1.5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(width: w * 0.04),

                          // Notification Text and Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                    color: colors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                if (body.isNotEmpty) ...[
                                  SizedBox(height: h * 0.004),
                                  Text(
                                    body,
                                    style: TextStyle(
                                      fontSize: w * 0.028,
                                      color: AppColorsLegacy.textSecondary,
                                      fontFamily: 'Montserrat',
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                                SizedBox(height: h * 0.008),
                                Text(
                                  timeText,
                                  style: TextStyle(
                                    fontSize: w * 0.03,
                                    color: AppColorsLegacy.textSecondary,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            const Spacer(),

            SizedBox(
              width: w * 0.8,
              height: h * 0.06,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await _db.markAllNotificationsRead(_uid);
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Failed to mark notifications as read'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLegacy.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Mark As Read",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.02),
          ],
        ),
      ),
    );
  }
}
