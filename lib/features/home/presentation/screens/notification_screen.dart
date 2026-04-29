import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class NotificationModel {
  final String title;
  final String time;
  final String imagePath;
  final bool isRead;
  bool isChecked;

  NotificationModel({
    required this.title,
    required this.time,
    required this.imagePath,
    this.isRead = false,
    this.isChecked = false,
  });
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      title: "Your order has been picked up by the delivery partner.",
      time: "2 hours ago",
      imagePath: "assets/images/cart-icon.png",
      isRead: false,
      isChecked: true,
    ),
    NotificationModel(
      title: "New voucher available! Get 20% off on your next order.",
      time: "15 minutes ago",
      imagePath: "assets/images/Discount.png",
      isRead: false,
    ),
    NotificationModel(
      title: "Your account security has been updated successfully.",
      time: "Last week",
      imagePath: "assets/images/username.png",
      isRead: true,
    ),
    NotificationModel(
      title: "Rate your last order from Backyard Burgers.",
      time: "2 days ago",
      imagePath: "assets/images/cart-icon.png",
      isRead: true,
    ),
    NotificationModel(
      title: "Flash Sale is live! Check out top deals today.",
      time: "5 hours ago",
      imagePath: "assets/images/Discount.png",
      isRead: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
              child: Row(
                children: [
                  // Back Button
                  Material(
                    color: AppColors.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColors.textPrimary),
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // More Menu
                   Material(
                    color: AppColors.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child:  Icon(Icons.more_horiz, color: AppColors.textPrimary),
                      ))
                  ),

                  SizedBox(height: h * 0.1,)
                ],
              ),
            ),

            // --- NOTIFICATION LIST ---
            Expanded(
              child: ListView.separated(
                itemCount: _notifications.length,
                padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
                separatorBuilder: (context, index) => const Divider(
                  color: AppColors.primary,
                  thickness: 0.5,
                  height: 30,
                ),
                itemBuilder: (context, index) {
                  final item = _notifications[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Custom Checkbox
                      Padding(
                        padding: EdgeInsets.only(top: h * 0.01),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              item.isChecked = !item.isChecked;
                            });
                          },
                          child: Container(
                            width: w * 0.04,
                            height: w * 0.04,
                            decoration: BoxDecoration(
                              color: item.isChecked ? AppColors.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: item.isChecked ? AppColors.primary : AppColors.backgroundSecondary4,
                                width: 1.5,
                              ),
                            ),
                            child: item.isChecked
                                ? const Icon(Icons.check, size: 12, color: Colors.white)
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(width: w * 0.04),

                      // Icon with Light Green Circle Background and Unread Dot
                      Stack(
                        children: [
                          Container(
                            width: w * 0.13,
                            height: w * 0.13,
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(15),
                            child: Image.asset(
                              item.imagePath,
                              fit: BoxFit.contain,
                              color: AppColors.textSecondary,
                              errorBuilder: (context, error, stackTrace) => 
                                  const Icon(Icons.notifications, color: AppColors.textSecondary),
                            ),
                          ),
                          // Unread Red Dot
                          if (!item.isRead)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1.5),
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
                              item.title,
                              style: TextStyle(
                                fontSize: w * 0.03,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                                color: AppColors.textPrimarylight87,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: h * 0.008),
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: w * 0.03,
                                color: AppColors.textSecondary,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
