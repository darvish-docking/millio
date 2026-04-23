import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/product_description_screen.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final SpecialOffer offer;

  const ProductDetailsScreen({super.key, required this.offer});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;
    final iconSize = w * 0.1;
    final offer = widget.offer;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// 🖼️ LAYER 1: Background Image (Static)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: h * 0.55, // Covers slightly more than half for consistent background
            child: Image.asset(
              offer.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: Icon(Icons.fastfood, size: w * 0.2, color: Colors.grey),
              ),
            ),
          ),

          /// 📜 LAYER 2: Scrollable Foreground Header & Details
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                /// Transparent spacer to allow the image layer to be seen
                SizedBox(height: h * 0.48),

                /// White Details Container
                Container(
                  width: w,
                  padding: EdgeInsets.fromLTRB(padding, h * 0.02, padding, padding),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Handle bar for visual cue
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: w * 0.1,
                          height: 4,
                          margin: EdgeInsets.only(bottom: h * 0.02),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      /// Category placeholder/Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.006),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Popular",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: w * 0.03,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.01),

                      /// Name
                      Text(
                        offer.title,
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: h * 0.005),

                      /// Price directly below Name
                      Text(
                        "\$${offer.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontFamily: 'Montserrat',
                        ),
                      ),

                      SizedBox(height: h * 0.01),

                      /// Metrics (Clickable for Reviews)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewsScreen(offer: offer),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: w * 0.04, color: Colors.grey),
                            SizedBox(width: w * 0.01),
                            Text(
                              offer.distance,
                              style: TextStyle(color: Colors.grey, fontSize: w * 0.035, fontFamily: 'Montserrat'),
                            ),
                            SizedBox(width: w * 0.04),
                            Icon(Icons.star, size: w * 0.04, color: Colors.amber),
                            SizedBox(width: w * 0.01),
                            Text(
                              "${offer.rating} ${offer.reviewCount}",
                              style: TextStyle(color: Colors.grey, fontSize: w * 0.035, fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: h * 0.02),

                      /// Description
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        "Experience the amazing taste of our freshly prepared ${offer.title}. Masterfully cooked with the best ingredients carefully sourced by top chefs in town. Serve hot to get the perfect joy of its blend of flavors and aroma.",
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: AppColors.textSecondary,
                          height: 1.6,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: isDescriptionExpanded ? null : 3,
                        overflow: isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDescriptionScreen(offer: offer),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: h * 0.005),
                          child: Text(
                            "Read more",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.035,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.03),

                      /// Quantity Controls & Add to Cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Add/Reduce Controls (Squared & Light Green background)
                          Container(
                            padding: const EdgeInsets.all(8), // Added padding as requested
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                /// Minus Button (Dark Green Square)
                                Material(
                                  color: const Color(0xFF388E3C), // Darker green
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                    child: SizedBox(
                                      width: w * 0.08,
                                      height: w * 0.08,
                                      child: Icon(Icons.remove, size: w * 0.05, color: Colors.white),
                                    ),
                                  ),
                                ),

                                /// Quantity Text
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: const Color(0xFF388E3C),
                                    ),
                                  ),
                                ),

                                /// Plus Button (Dark Green Square)
                                Material(
                                  color: const Color(0xFF388E3C), // Darker green
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => quantity++);
                                    },
                                    child: SizedBox(
                                      width: w * 0.08,
                                      height: w * 0.08,
                                      child: Icon(Icons.add, size: w * 0.05, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: SizedBox(
                              height: h * 0.065,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🏗️ LAYER 3: Fixed Action Buttons
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Back Button
                  Material(
                    color: Colors.grey.shade300,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: SizedBox(
                        height: iconSize,
                        width: iconSize,
                        child: Center(
                          child: Image.asset(
                            'assets/images/left-arrow.png',
                            width: iconSize * 0.45,
                            height: iconSize * 0.45,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Search & Save Buttons
                  Row(
                    children: [
                      Material(
                        color: Colors.white.withOpacity(0.9),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            height: iconSize,
                            width: iconSize,
                            child: Center(
                              child: Icon(Icons.search, size: iconSize * 0.55, color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: padding * 0.6),
                      Material(
                        color: Colors.white.withOpacity(0.9),
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: () {},
                          child: SizedBox(
                            height: iconSize,
                            width: iconSize,
                            child: Center(
                              child: Icon(Icons.favorite_border, size: iconSize * 0.55, color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
