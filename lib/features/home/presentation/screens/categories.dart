import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  final List<String> categories;

  const CategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
        final colors = context.colors;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    
    
    // Using the same pastel background colors as home screen, but in a square container
    final bgColors = [
      AppColors.category1,
AppColors.category2,
AppColors.category3,
AppColors.category4,      
AppColors.category5,
      AppColors.category6,
      AppColors.category7,
      AppColors.category8,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,

        leadingWidth: 48,
        leading: Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: AppColorsLegacy.backgroundSecondary3,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                height: 32,
                width: 32,
                child: Center(
                  child: Image.asset(
                    'assets/images/left-arrow.png',
                    width: 18,
                    height: 18,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        title:  Text(
          "Categories",
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: List.generate((categories.length / 2).ceil(), (i) {
                  final index = i * 2;
                  if (index >= categories.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _buildCategoryItem(index, bgColors, w, context),
                  );
                }),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: w * 0.18), // Added top offset for second column
                  ...List.generate((categories.length / 2).floor(), (i) {
                    final index = i * 2 + 1;
                    if (index >= categories.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildCategoryItem(index, bgColors, w, context),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        index: context.watch<TabProvider>().currentIndex,
        onTap: (value) {
          context.read<TabProvider>().setIndex(value);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index, List<Color> bgColors, double w, BuildContext context) {
    // Uniform height as seen in the design image
    final height = w * 0.52;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgColors[index % bgColors.length],
                context.colors.background,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.colors.boxShadow,
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/${categories[index]}.png",
                width: w * 0.22,
                height: w * 0.22,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 12),
              Text(
                categories[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: w * 0.038,
                  color: context.colors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
