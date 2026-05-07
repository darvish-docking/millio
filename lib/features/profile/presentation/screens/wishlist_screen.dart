import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/product_details.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  // Mock wishlist data based on SpecialOffer model
  final List<SpecialOffer> wishlistItems = [
    SpecialOffer(
      image: "assets/images/Buffalo Chicken Dip.png",
      title: "Buffalo Chicken Dip",
      distance: "1.2 km",
      rating: "4.8",
      reviewCount: "(230)",
      price: 12.99,
    ),
    SpecialOffer(
      image: "assets/images/Maltesers Tiramisu.png",
      title: "Maltesers Tiramisu",
      distance: "0.8 km",
      rating: "4.9",
      reviewCount: "(540)",
      price: 24.00,
    ),
    SpecialOffer(
      image: "assets/images/Sirloin steak.png",
      title: "Sirloin steak",
      distance: "1.5 km",
      rating: "4.6",
      reviewCount: "(122)",
      price: 4.50,
    ),
  ];

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
            /// HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
              child: Row(
                children: [
                  Container(
                    height: w * 0.09,
                    width: w * 0.09,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.boxShadow,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.chevron_left,
                        color: colors.textPrimary,
                        size: w * 0.06,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    "My Wishlist",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            /// WISHLIST GRID
            Expanded(
              child: wishlistItems.isEmpty
                  ? _buildEmptyState(w, h, colors)
                  : GridView.builder(
                      padding: EdgeInsets.all(w * 0.05),
                      itemCount: wishlistItems.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final item = wishlistItems[index];
                        return _buildWishlistItem(item, w, colors);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistItem(SpecialOffer item, double w, dynamic colors) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(offer: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: colors.boxShadow,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      item.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: colors.border,
                        child: Icon(Icons.fastfood, color: colors.textSecondary),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColorsLegacy.primary.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: colors.textPrimary,
                fontSize: w * 0.035,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  item.rating,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: w * 0.03,
                    fontFamily: 'Montserrat',
                  ),
                ),
                Text(
                  " ${item.reviewCount}",
                  style: TextStyle(
                    color: colors.textSecondary.withOpacity(0.6),
                    fontSize: w * 0.025,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${item.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: AppColorsLegacy.primary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: w * 0.04,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColorsLegacy.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.add_shopping_cart,
                    color: AppColorsLegacy.primary,
                    size: 18,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(double w, double h, dynamic colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: w * 0.2,
            color: colors.textSecondary.withOpacity(0.2),
          ),
          SizedBox(height: h * 0.02),
          Text(
            "Your wishlist is empty",
            style: TextStyle(
              fontSize: w * 0.045,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: colors.textPrimary,
            ),
          ),
          SizedBox(height: h * 0.01),
          Text(
            "Tap the heart icon on any product to add it here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: w * 0.035,
              fontFamily: 'Montserrat',
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
