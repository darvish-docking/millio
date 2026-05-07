import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';

class DealItem {
  final String image;
  final String title;
  final String price;
  final String description;

  DealItem({
    required this.image,
    required this.title,
    required this.price,
    required this.description,
  });
}

class HotDealTodayScreen extends StatefulWidget {
  const HotDealTodayScreen({super.key});

  @override
  State<HotDealTodayScreen> createState() => _HotDealTodayScreenState();
}

class _HotDealTodayScreenState extends State<HotDealTodayScreen> {
  final PageController _pageController = PageController(viewportFraction: 1.0);
  int _currentIndex = 0;

  final List<DealItem> hotDeals = [
    DealItem(
      image: "assets/images/food-1.png",
      title: "Seafood Som Tum",
      price: "\$ 3.99 - \$ 2.59",
      description: "A delicious and healthy seafood salad with a perfect blend of spicy, sour, and sweet flavors to tantalize your tastebuds.",
    ),
    DealItem(
      image: "assets/images/Buffalo Chicken Dip.png",
      title: "Buffalo Chicken Dip",
      price: "\$ 12.99 - \$ 8.99",
      description: "Creamy, cheesy, and packed with zesty buffalo flavor. The perfect appetizer for any occasion.",
    ),
    DealItem(
      image: "assets/images/Baked Spaghetti.png",
      title: "Baked Spaghetti",
      price: "\$ 15.50 - \$ 10.99",
      description: "Classic Italian spaghetti baked with layers of rich marinara sauce and melted mozzarella cheese.",
    ),
    DealItem(
      image: "assets/images/Maltesers Tiramisu.png",
      title: "Maltesers Tiramisu",
      price: "\$ 24.00 - \$ 18.50",
      description: "A modern twist on a classic dessert, featuring crunchy Maltesers and creamy coffee-soaked layers.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
        title: Text(
          "Hot Deal Today",
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: hotDeals.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                final deal = hotDeals[index];
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.02),
                      
                      /// Image Carousel Unit
                      Container(
                        height: h * .35,
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColorsLegacy.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColorsLegacy.primary.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                color: colors.textField.withOpacity(0.6),
                              ),
                              Center(
                                child: Image.asset(
                                  deal.image,
                                  width: w * 0.6,
                                  height: h * 0.3,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.03),

                      /// Indicator (inside the swipable area or fixed?)
                      /// Moving it below the image
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          hotDeals.length,
                          (idx) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == idx ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentIndex == idx
                                  ? AppColorsLegacy.primary
                                  : AppColorsLegacy.primaryLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.03),

                      /// Details Unit
                      Text(
                        deal.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      
                      SizedBox(height: h * 0.01),
                      
                      Text(
                        deal.price,
                        style: TextStyle(
                          color: AppColorsLegacy.primary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      
                      SizedBox(height: h * 0.02),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.1),
                        child: Text(
                          deal.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColorsLegacy.backgroundSecondary,
                            fontSize: 14,
                            height: 1.5,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      
                      SizedBox(height: h * 0.05),
                      
                      /// Add to cart button
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                        child: SizedBox(
                          width: double.infinity,
                          height: h * 0.06,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColorsLegacy.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child:  Text(
                              "Add to cart",
                              style: TextStyle(
                                color: AppColorsLegacy.background,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.05),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
