import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/data/models/product_model.dart';

class ProductDescriptionScreen extends StatelessWidget {
  final Product offer;

  const ProductDescriptionScreen({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;



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
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColorsLegacy.textPrimary),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Description",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/shade1.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: -w * 0.15,
            child: Image.asset(
              'assets/images/bullseye.png',
              width: w * 0.65,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Egg.png',
              width: w * 0.6,
              fit: BoxFit.contain,
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: padding),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h * 0.01),

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
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.04),

                Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.015),
                Text(
                  offer.description.isNotEmpty
                      ? offer.description
                      : "No description available.",
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary.withOpacity(0.7),
                    height: 1.6,
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: h * 0.04),

                Text(
                  "Ingridients",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.02),
                if (offer.ingredients.isNotEmpty)
                  ...offer.ingredients.entries.map(
                    (e) => _buildIngredientRow(e.key, e.value),
                  )
                else
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.01),
                    child: Text(
                      "No ingredient information available.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColorsLegacy.backgroundSecondary5,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),

                SizedBox(height: h * 0.15),
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
              color: AppColorsLegacy.backgroundSecondary6,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            weight,
            style: TextStyle(
              fontSize: 15,
              color: AppColorsLegacy.backgroundSecondary5,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
