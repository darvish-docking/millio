import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';

class ProductDescriptionScreen extends StatelessWidget {
  final SpecialOffer offer;

  const ProductDescriptionScreen({super.key, required this.offer});

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
          "Description",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/images/shade1.png',
              width:  w ,
              fit: BoxFit.contain,
            ),
          ),

          

          // 🍳 Decorative bottom background
          Positioned(
            bottom: h * 0.001,
            left: -w * 0.2,
            child: Image.asset(
              'assets/images/bullseye.png',
              width: w * 0.8,
            ),
          ),

          // 🍳 Decorative bottom background
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Egg.png',
              width: w * 0.8,
            ),
          ),

          // 📜 Main Content
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.01),

                // 🎥 Video Preview Area
                Container(
                  height: h * 0.28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: DecorationImage(
                      image: AssetImage(offer.image),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColors.textPrimary,
                          size: 30,
                        ),
                      ),
                    ),
                ),
                SizedBox(height: h * 0.04),

                // ℹ️ Information Section
                const Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna. Etiam tempor orci eu lobortis elementum. Et tortor at risus viverra",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.backgroundSecondary6,
                    height: 1.6,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: h * 0.04),

                // 🥗 Ingredients Section
                const Text(
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.02),
                _buildIngredientRow("Beef", "500 g"),
                _buildIngredientRow("Garlic", "05 g"),
                _buildIngredientRow("Onion", "73 g"),
                _buildIngredientRow("Soy Sauce", "64 g"),
                _buildIngredientRow("Basil", "03 g"),
                
                SizedBox(height: h * 0.15), // Extra space
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientRow(String name, String weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.backgroundSecondary6,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            weight,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.backgroundSecondary5,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
