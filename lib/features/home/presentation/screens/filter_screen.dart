import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final List<String> _categories = [
    "Desserts", "Lunch", "Appetizers", "Main Course", 
    "Drink", "Vegetable", "Fast Food", "Sea Food"
  ];
  
  final Set<String> _selectedCategories = {};
  RangeValues _distanceRange = const RangeValues(0, 10);
  RangeValues _priceRange = const RangeValues(0, 60);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/filter-Bg.png',
              fit: BoxFit.cover,
              width: w,
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.015),
                  child: Row(
                    children: [
                      // Close Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary2,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: w * 0.045, color: AppColors.textPrimary),
                        ),
                      ),
                      SizedBox(width: w * 0.04),
                      // Title
                      Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Column(
                      children: [
                        // Card 1: Categories
                        _buildFilterCard(
                          title: "Categories",
                          content: GridView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _categories.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 4.2, // Adjusted for new spacing
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              final category = _categories[index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category, 
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: w * 0.03,
                                    )
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_selectedCategories.contains(category)) {
                                          _selectedCategories.remove(category);
                                        } else {
                                          _selectedCategories.add(category);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: w * 0.05,
                                      height: w * 0.05,
                                      padding: const EdgeInsets.all(2), // Gap between border and fill
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.backgroundSecondary3, 
                                          width: 1.5
                                        ),
                                      ),
                                      child: _selectedCategories.contains(category) 
                                          ? Container(
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primary,
                                              ),
                                              child: Icon(
                                                Icons.check, 
                                                size: w * 0.025, 
                                                color: AppColors.background
                                              ),
                                            )
                                          : null,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        SizedBox(height: h * 0.015),

                        // Card 2: Location
                        _buildFilterCard(
                          title: "Location",
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.primary,
                                  thumbColor: AppColors.primary,
                                  overlayColor: AppColors.primary.withAlpha(32),
                                  trackHeight: 1.5, // Even thinner track
                                  rangeThumbShape: const RoundRangeSliderThumbShapeWithInnerCircle(enabledThumbRadius: 8.0, innerRadius: 3.0),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 8.0),
                                ),
                                child: RangeSlider(
                                  values: _distanceRange,
                                  min: 0,
                                  max: 10,
                                  onChanged: (val) {
                                    setState(() {
                                      _distanceRange = val;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: AppColors.backgroundSecondary6,
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                    ),
                                    children: [
                                      const TextSpan(text: "Distance: "),
                                      TextSpan(
                                        text: "${_distanceRange.start.toInt()}km - ${_distanceRange.end.toInt()}km",
                                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: h * 0.015),

                        // Card 3: Price
                        _buildFilterCard(
                          title: "Price",
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.primary,
                                  inactiveTrackColor: AppColors.backgroundSecondary2,
                                  thumbColor: AppColors.primary,
                                  trackHeight: 1.5, // Even thinner track
                                  rangeThumbShape: const RoundRangeSliderThumbShapeWithInnerCircle(enabledThumbRadius: 8.0, innerRadius: 3.0),
                                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 8.0),
                                ),
                                child: RangeSlider(
                                  values: _priceRange,
                                  min: 0,
                                  max: 60,
                                  onChanged: (values) {
                                    setState(() {
                                      _priceRange = values;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: AppColors.backgroundSecondary6,
                                      fontFamily: 'Montserrat',
                                      fontSize: 11,
                                    ),
                                    children: [
                                      const TextSpan(text: "Price: "),
                                      TextSpan(
                                        text: "\$${_priceRange.start.toInt()} - \$${_priceRange.end.toInt()}",
                                        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: h * 0.05), 
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterCard({required String title, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    );
  }
}

class RoundRangeSliderThumbShapeWithInnerCircle extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double innerRadius;

  const RoundRangeSliderThumbShapeWithInnerCircle({
    this.enabledThumbRadius = 10.0,
    this.innerRadius = 4.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Paint outerPaint = Paint()
      ..color = sliderTheme.thumbColor ?? AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, enabledThumbRadius, outerPaint);

    final Paint innerPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, innerRadius, innerPaint);
  }
}
