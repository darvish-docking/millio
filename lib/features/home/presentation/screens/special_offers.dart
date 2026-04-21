import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart'; 
import 'package:millio/features/home/presentation/screens/product_details.dart';

class SpecialOffersScreen extends StatelessWidget {
  final List<SpecialOffer> specialOffers;

  const SpecialOffersScreen({super.key, required this.specialOffers});

  @override
  Widget build(BuildContext context) {
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
          "Special Offers",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  /// SEARCH BAR
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "What are you craving?",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: const Icon(Icons.filter_list),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: h * .02,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: .72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final offer = specialOffers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(offer: offer),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black12,
                          )
                        ],
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset(
                              offer.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.fastfood, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "${offer.distance} |",
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                            const Icon(Icons.star, size: 14, color: Colors.amber),
                            Text(
                              offer.rating,
                              style: const TextStyle(color: AppColors.textSecondary),
                            ),
                            Text(
                              offer.reviewCount,
                              style: const TextStyle(color: AppColors.textSecondary),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "\$${offer.price.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ));
                },
                childCount: specialOffers.length,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
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
}
