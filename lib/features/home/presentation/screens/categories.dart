import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/constants/app_colors.dart';

class CategoriesScreen extends StatelessWidget {
  final List<String> categories;

  const CategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    
    
    // Using the same pastel background colors as home screen, but in a square container
    final bgColors = [
      Colors.orange.shade50,
      Colors.blue.shade50,
      Colors.pink.shade50,
      Colors.green.shade50,
      Colors.purple.shade50,
      Colors.red.shade50,
      Colors.teal.shade50,
      Colors.amber.shade50,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,

        leadingWidth: 48,
        leading: Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.grey.shade300,
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
        title: const Text(
          "Categories",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCategoryItem(index, bgColors, w),
                  );
                }),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: List.generate((categories.length / 2).floor(), (i) {
                  final index = i * 2 + 1;
                  if (index >= categories.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCategoryItem(index, bgColors, w),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        index: 0,
        onTap: (value) {
          if (value == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _buildCategoryItem(int index, List<Color> bgColors, double w) {
    bool isLarge = false;
    // Creates a staggered height pattern
    if (index % 2 == 0) {
      isLarge = (index % 4 == 0);
    } else {
      isLarge = (index % 4 == 3);
    }
    
    // Assign varying heights based on the layout pattern
    final height = isLarge ? w * 0.55 : w * 0.40;

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
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Image.asset(
              "assets/images/${categories[index]}.png",
              width: w * 0.2,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          categories[index],
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
