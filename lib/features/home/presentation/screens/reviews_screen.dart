import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/home/presentation/screens/add_review_screen.dart';
import 'package:millio/features/home/data/models/product_model.dart';

class ReviewsScreen extends StatefulWidget {
  final Product offer;

  const ReviewsScreen({super.key, required this.offer});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int? _selectedRating; // null means "Sort by" (Show All)

  final DatabaseService _dbService = DatabaseService();
  List<Map<String, dynamic>> _allReviews = [];
  bool _reviewsLoading = true;
  StreamSubscription<List<Map<String, dynamic>>>? _reviewsSub;

  @override
  void initState() {
    super.initState();
    _reviewsSub = _dbService.getProductReviews(widget.offer.id).listen(
      (reviews) {
        setState(() {
          _allReviews = reviews;
          _reviewsLoading = false;
        });
      },
      onError: (_) {
        setState(() {
          _reviewsLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    _reviewsSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;

    final filteredReviews = _selectedRating == null
        ? _allReviews
        : _allReviews
            .where((r) => (r['rating'] as num).toInt() == _selectedRating)
            .toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Material(
              color: AppColorsLegacy.backgroundSecondary1,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back_ios_new,
                      size: 18, color: AppColorsLegacy.textPrimary),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Reviews",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- RATING SUMMARY DASHBOARD ---
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.offer.id)
                  .snapshots(),
              builder: (context, snapshot) {
                double liveRating;
                int liveCount;

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data =
                      snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  liveRating = (data['aggregateRating'] as num?)?.toDouble() ??
                      (double.tryParse(widget.offer.rating) ?? 0.0);
                  // reviewCount may be stored as int (after first review) or
                  // as a String like "(230)" in legacy product docs — handle both.
                  final rawCount = data['reviewCount'];
                  if (rawCount is int) {
                    liveCount = rawCount;
                  } else if (rawCount is num) {
                    liveCount = rawCount.toInt();
                  } else {
                    liveCount = int.tryParse(
                            widget.offer.reviewCount.replaceAll(RegExp(r'[^0-9]'), '')) ??
                        0;
                  }
                } else {
                  liveRating = double.tryParse(widget.offer.rating) ?? 0.0;
                  liveCount = int.tryParse(
                          widget.offer.reviewCount.replaceAll(RegExp(r'[^0-9]'), '')) ??
                      0;
                }

                final ratingString = liveRating.toStringAsFixed(1);
                final totalReviews = _allReviews.isEmpty ? liveCount : _allReviews.length;

                // Compute progress bar values from live reviews
                double barValue(int star) {
                  if (_allReviews.isEmpty) return 0.0;
                  final count = _allReviews
                      .where((r) => (r['rating'] as num).toInt() == star)
                      .length;
                  return count / _allReviews.length;
                }

                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            ratingString,
                            style: TextStyle(
                              fontSize: w * 0.15,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                              color: colors.textPrimary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return Icon(
                                index < liveRating.floor()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: AppColorsLegacy.amber,
                                size: w * 0.05,
                              );
                            }),
                          ),
                          SizedBox(height: h * 0.01),
                          Text(
                            "$totalReviews Reviews",
                            style: TextStyle(
                              color: AppColorsLegacy.backgroundSecondary,
                              fontSize: w * 0.035,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: h * 0.12,
                      width: 1.5,
                      color: AppColorsLegacy.backgroundSecondary2,
                      margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildRatingProgressRow("5", barValue(5), w),
                          _buildRatingProgressRow("4", barValue(4), w),
                          _buildRatingProgressRow("3", barValue(3), w),
                          _buildRatingProgressRow("2", barValue(2), w),
                          _buildRatingProgressRow("1", barValue(1), w),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: h * 0.05),

            // --- FILTER CHIPS ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip("Sort by", w,
                      isSelected: _selectedRating == null,
                      onTap: () => setState(() => _selectedRating = null)),
                  _buildFilterChip("★ 5", w,
                      isSelected: _selectedRating == 5,
                      onTap: () => setState(() => _selectedRating = 5)),
                  _buildFilterChip("★ 4", w,
                      isSelected: _selectedRating == 4,
                      onTap: () => setState(() => _selectedRating = 4)),
                  _buildFilterChip("★ 3", w,
                      isSelected: _selectedRating == 3,
                      onTap: () => setState(() => _selectedRating = 3)),
                  _buildFilterChip("★ 2", w,
                      isSelected: _selectedRating == 2,
                      onTap: () => setState(() => _selectedRating = 2)),
                  _buildFilterChip("★ 1", w,
                      isSelected: _selectedRating == 1,
                      onTap: () => setState(() => _selectedRating = 1)),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            // --- REVIEWS LIST ---
            if (_reviewsLoading)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.05),
                  child: const CircularProgressIndicator(),
                ),
              )
            else if (filteredReviews.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: h * 0.1),
                  child: Text(
                    "No reviews for this rating",
                    style: TextStyle(
                      color: AppColorsLegacy.backgroundSecondary,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredReviews.length,
                itemBuilder: (context, index) {
                  final review = filteredReviews[index];
                  return Column(
                    children: [
                      _buildReviewItem(review, w, h),
                      if (index < filteredReviews.length - 1)
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: h * 0.025),
                          child: Divider(
                            color:
                                AppColorsLegacy.primary.withOpacity(0.4),
                            thickness: 1,
                          ),
                        ),
                      if (index == filteredReviews.length - 1)
                        SizedBox(height: h * 0.05),
                    ],
                  );
                },
              ),

            // --- ADD REVIEW BUTTON ---
            SizedBox(
              width: double.infinity,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddReviewScreen(offer: widget.offer),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLegacy.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.08),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Add A Review",
                  style: TextStyle(
                    color: AppColorsLegacy.background,
                    fontSize: w * 0.042,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
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

  Widget _buildRatingProgressRow(String label, double value, double w) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.008),
      child: Row(
        children: [
          SizedBox(
            width: w * 0.05,
            child: Text(
              label,
              style: TextStyle(
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: context.colors.textPrimary,
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.02),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: AppColorsLegacy.backgroundSecondary1,
                color: AppColorsLegacy.amber,
                minHeight: w * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, double w,
      {required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: w * 0.03),
        padding: EdgeInsets.symmetric(
            horizontal: w * 0.04, vertical: w * 0.015),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColorsLegacy.primary
              : AppColorsLegacy.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(w * 0.05),
          border: Border.all(
            color: isSelected
                ? AppColorsLegacy.primary
                : AppColorsLegacy.primary.withOpacity(0.1),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? AppColorsLegacy.background
                : AppColorsLegacy.primary,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: w * 0.035,
            fontFamily: 'Montserrat',
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt == null) return 'Just now';
    if (createdAt is Timestamp) {
      final dt = createdAt.toDate();
      return DateFormat('MMM d, yyyy').format(dt);
    }
    return 'Just now';
  }

  Widget _buildReviewItem(Map<String, dynamic> r, double w, double h) {
    final userName = r['userName'] as String? ?? 'Anonymous';
    final rating = (r['rating'] as num?)?.toDouble() ?? 0.0;
    final comment = r['comment'] as String? ?? '';
    final likes = (r['likes'] as num?)?.toInt() ?? 0;
    final dateStr = _formatDate(r['createdAt']);
    final profilePicture = r['profilePicture'] as String? ?? '';

    // Build avatar: use base64 image if available, else show initial letter
    Widget avatarChild;
    ImageProvider? avatarImage;
    if (profilePicture.isNotEmpty) {
      try {
        avatarImage = MemoryImage(base64Decode(profilePicture));
      } catch (_) {
        avatarImage = null;
      }
    }
    if (avatarImage == null) {
      avatarChild = Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: w * 0.05,
          color: AppColorsLegacy.textPrimary,
        ),
      );
    } else {
      avatarChild = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColorsLegacy.backgroundSecondary1, width: 2),
              ),
              child: CircleAvatar(
                radius: w * 0.06,
                backgroundColor: AppColorsLegacy.backgroundSecondary2,
                backgroundImage: avatarImage,
                child: avatarImage == null ? avatarChild : null,
              ),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.045,
                  fontFamily: 'Montserrat',
                  color: context.colors.textPrimary,
                ),
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: AppColorsLegacy.amber,
                  size: w * 0.045,
                );
              }),
            ),
          ],
        ),
        SizedBox(height: h * 0.015),
        Text(
          comment,
          style: TextStyle(
            color: AppColorsLegacy.backgroundSecondary7,
            fontSize: w * 0.036,
            height: 1.6,
            fontFamily: 'Montserrat',
          ),
        ),
        SizedBox(height: h * 0.02),
        Row(
          children: [
            Icon(Icons.favorite,
                color: AppColorsLegacy.buttonFavourites, size: w * 0.05),
            SizedBox(width: w * 0.02),
            Text(
              likes.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: w * 0.038,
                fontFamily: 'Montserrat',
                color: context.colors.textPrimary,
              ),
            ),
            Container(
              height: h * 0.02,
              width: 1.5,
              color: AppColorsLegacy.backgroundSecondary3,
              margin: EdgeInsets.symmetric(horizontal: w * 0.04),
            ),
            Text(
              dateStr,
              style: TextStyle(
                color: AppColorsLegacy.backgroundSecondary,
                fontSize: w * 0.035,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
