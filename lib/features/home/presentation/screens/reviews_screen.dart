import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/add_review_screen.dart';

class ReviewData {
  final String userName;
  final String userImage;
  final double rating;
  final String comment;
  final int likes;
  final String date;

  ReviewData({
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.likes,
    required this.date,
  });
}

class ReviewsScreen extends StatelessWidget {
  final SpecialOffer offer;

  ReviewsScreen({super.key, required this.offer});

  final List<ReviewData> reviews = [
    ReviewData(
      userName: "Alexander Hipwell",
      userImage: "assets/images/username.png",
      rating: 5.0,
      comment: "This food is absolutely amazing! The flavors are rich and well-balanced. I highly recommend it to anyone looking for a premium dining experience.",
      likes: 24,
      date: "3 days ago",
    ),
    ReviewData(
      userName: "Sophia Martinez",
      userImage: "assets/images/username.png",
      rating: 4.0,
      comment: "Very delicious and fresh. The portion size was perfect. Only giving 4 stars because the delivery took slightly longer than expected, but the taste made up for it.",
      likes: 12,
      date: "1 week ago",
    ),
    ReviewData(
      userName: "James Wilson",
      userImage: "assets/images/username.png",
      rating: 5.0,
      comment: "Best meal I've had in a long time. The presentation was beautiful and the quality of ingredients was top-notch. Will order again definitely!",
      likes: 8,
      date: "1 month ago",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Material(
              color: AppColors.backgroundSecondary1,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Reviews",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
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
            Row(
              children: [
                // Left Column: Bold Rating & Stars
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        offer.rating,
                        style: TextStyle(
                          fontSize: w * 0.15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          double r = double.tryParse(offer.rating) ?? 0.0;
                          return Icon(
                            index < r.floor() ? Icons.star : Icons.star_border,
                            color: AppColors.amber,
                            size: w * 0.05,
                          );
                        }),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        "${offer.reviewCount} Reviews",
                        style: TextStyle(
                          color: AppColors.backgroundSecondary,
                          fontSize: w * 0.035,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Separator
                Container(
                  height: h * 0.12,
                  width: 1.5,
                  color: AppColors.backgroundSecondary2,
                  margin: EdgeInsets.symmetric(horizontal: w * 0.04),
                ),

                // Right Column: Progress Indicators
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRatingProgressRow("5", 0.9, w),
                      _buildRatingProgressRow("4", 0.15, w),
                      _buildRatingProgressRow("3", 0.05, w),
                      _buildRatingProgressRow("2", 0.02, w),
                      _buildRatingProgressRow("1", 0.01, w),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: h * 0.05),

            // --- FILTER CHIPS ---
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip("Sort by", w, isSelected: true),
                  _buildFilterChip("★ 5", w),
                  _buildFilterChip("★ 4", w),
                  _buildFilterChip("★ 3", w),
                  _buildFilterChip("★ 2", w),
                  _buildFilterChip("★ 1", w),
                ],
              ),
            ),

            SizedBox(height: h * 0.04),

            // --- REVIEWS LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Column(
                  children: [
                    _buildReviewItem(review, w, h),
                    // Green horizontal separator
                    if (index < reviews.length - 1)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: h * 0.025),
                        child: Divider(
                          color: AppColors.primary.withOpacity(0.4),
                          thickness: 1,
                        ),
                      ),
                    if (index == reviews.length - 1)
                       SizedBox(height: h * 0.05),
                  ],
                );
              },),
            // --- ADD REVIEW BUTTON ---
            SizedBox(
              width: double.infinity,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddReviewScreen(offer: offer),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.08),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Add A Review",
                  style: TextStyle(
                    color: AppColors.background,
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
                fontFamily: 'Montserrat'
              ),
            ),
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.02),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.backgroundSecondary1,
                color: AppColors.amber,
                minHeight: w * 0.015,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, double w, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.only(right: w * 0.03),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.015),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(w * 0.05),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.primary.withOpacity(0.1)
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: w * 0.035,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }

  Widget _buildReviewItem(ReviewData review, double w, double h) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: User Image, Name, Stars
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundSecondary1, width: 2),
              ),
              child: CircleAvatar(
                radius: w * 0.06,
                backgroundImage: AssetImage(review.userImage),
                backgroundColor: AppColors.backgroundSecondary2,
              ),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Text(
                review.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: w * 0.045, 
                  fontFamily: 'Montserrat'
                ),
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.rating.floor() ? Icons.star : Icons.star_border,
                  color: AppColors.amber,
                  size: w * 0.045,
                );
              }),
            ),
          ],
        ),
        
        SizedBox(height: h * 0.015),

        // Review Text
        Text(
          review.comment,
          style: TextStyle(
            color: AppColors.backgroundSecondary7,
            fontSize: w * 0.036,
            height: 1.6,
            fontFamily: 'Montserrat',
          ),
        ),

        SizedBox(height: h * 0.02),

        // Footer Row: Heart icon | Timestamp
        Row(
          children: [
            Icon(Icons.favorite, color: AppColors.buttonFavourites, size: w * 0.05),
            SizedBox(width: w * 0.02),
            Text(
              review.likes.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: w * 0.038, 
                fontFamily: 'Montserrat'
              ),
            ),
            Container(
              height: h * 0.02,
              width: 1.5,
              color: AppColors.backgroundSecondary3,
              margin: EdgeInsets.symmetric(horizontal: w * 0.04),
            ),
            Text(
              review.date,
              style: TextStyle(
                color: AppColors.backgroundSecondary, 
                fontSize: w * 0.035, 
                fontFamily: 'Montserrat'
              ),
            ),
          ],
        ),
      ],
    );
  }
}
