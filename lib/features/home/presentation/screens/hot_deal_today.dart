import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/constants/app_colors.dart';

class HotDealTodayScreen extends StatefulWidget {
  const HotDealTodayScreen({super.key});

  @override
  State<HotDealTodayScreen> createState() => _HotDealTodayScreenState();
}

class _HotDealTodayScreenState extends State<HotDealTodayScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.75);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

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
          "Hot Deal Today",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.02),
            SizedBox(
              height: h * .35,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: 5,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (_, index) {
                      return AnimatedBuilder(
                        animation: _pageController,
                        builder: (context, child) {
                          double value = 1.0;
                          if (_pageController.position.haveDimensions) {
                            value = _pageController.page! - index;
                            value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0);
                          } else {
                            value = index == 0 ? 1.0 : 0.85;
                          }
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.green.withOpacity(0.4),
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
                                  color: const Color.fromARGB(255, 201, 241, 203).withOpacity(0.6),
                                ),
                                Center(
                                  child: Image.asset(
                                    "assets/images/food-1.png",
                                    width: w * 0.5,
                                    height: h * 0.25,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 25,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? AppColors.primary
                                : const Color.fromARGB(255, 189, 236, 213),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: h * 0.03),
            SizedBox(height: h * 0.02),
            // Text Details Section outside the carousel
            const Text(
              'Seafood Som Tum',
              maxLines: 2,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.01),
            const Text(
              '\$ 3.99 - \$ 2.59',
              maxLines: 2,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: h * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.1),
              child: const Text(
                'A delicious and healthy seafood salad with a perfect blend of spicy, sour, and sweet flavors to tantalize your tastebuds.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            
            SizedBox(height: h * 0.05),
            
            // Add to cart button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.05),
              child: SizedBox(
                width: double.infinity,
                height: h * 0.06,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // The standard green
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(
                      color: AppColors.background, // Should be white based on AppColors
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
      ),
      // bottomNavigationBar: CustomBottomNav(
      //   index: 0,
      //   onTap: (value) {
      //     if (value == 0) {
      //       Navigator.popUntil(context, (route) => route.isFirst);
      //     }
      //   },
      // ),
    );
  }
}
