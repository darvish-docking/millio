import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';
import 'package:millio/features/home/data/models/product_model.dart'; 
import 'package:millio/features/home/presentation/screens/product_details.dart';
import 'package:millio/features/home/presentation/screens/filter_screen.dart';

class SpecialOffersScreen extends StatelessWidget {
  final List<Product> specialOffers;

  const SpecialOffersScreen({super.key, required this.specialOffers});

  @override
  Widget build(BuildContext context) {
                final colors = context.colors;

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
        title:  Text(
          "Special Offers",
          style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold),
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
                      color: colors.textField,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow:  [
                        BoxShadow(
                          blurRadius: 10,
                          color: AppColorsLegacy.textPrimarylight12,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "What are you craving?",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            'assets/images/Filter.png',
                            height: 24,
                            width: 24,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FilterScreen()),
                            );
                          },
                        ),
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
                        color: colors.textField,
                        boxShadow:  [
                          BoxShadow(
                            blurRadius: 8,
                            color: AppColorsLegacy.textPrimarylight12,
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
                                color: AppColorsLegacy.backgroundSecondary2,
                                child:  Icon(Icons.fastfood, color: AppColorsLegacy.backgroundSecondary),
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
                              style:  TextStyle(color: AppColorsLegacy.textSecondary),
                            ),
                             Icon(Icons.star, size: 14, color: AppColorsLegacy.amber),
                            Text(
                              offer.rating,
                              style:  TextStyle(color: AppColorsLegacy.textSecondary),
                            ),
                            Text(
                              offer.reviewCount,
                              style:  TextStyle(color: AppColorsLegacy.textSecondary),
                            )
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "\$${offer.price.toStringAsFixed(2)}",
                          style:  TextStyle(
                            color: AppColorsLegacy.primary,
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
        index: context.watch<TabProvider>().currentIndex,
        onTap: (value) {
          context.read<TabProvider>().setIndex(value);
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      ),
    );
  }
}
