import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/product_details.dart';
import 'package:millio/features/home/presentation/screens/filter_screen.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';
import 'package:millio/features/home/presentation/screens/categories.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  String _searchQuery = "";
  final List<String> _recentSearches = ["Buffalo Chicken", "Pasta", "Burgers"];

  final List<String> categories = [
    "Desserts", "Lunch", "Appetizers", "Main Course",
    "Drink", "Vegetable", "Fast Food", "Sea Food"
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
      if (mounted) setState(() {});
    });
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final colors = context.colors;
    final w = MediaQuery.of(context).size.width;
    
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () => _searchFocusNode.unfocus(),
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            width: w * 0.9,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 60),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(20),
                color: colors.surface,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.border.withOpacity(0.1)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Searches",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: colors.textPrimary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _recentSearches.clear();
                                });
                                _hideOverlay();
                              },
                              child: Text(
                                "Clear all",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.primary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ..._recentSearches.map((search) => ListTile(
                        leading: Icon(Icons.history, color: colors.textSecondary, size: 20),
                        title: Text(
                          search,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            color: colors.textPrimary,
                          ),
                        ),
                        onTap: () {
                          _searchController.text = search;
                          setState(() {
                            _searchQuery = search;
                          });
                          _searchFocusNode.unfocus();
                        },
                      )).toList(),
                      if (_recentSearches.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "No recent searches",
                            style: TextStyle(color: colors.textSecondary, fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    // Filter categories based on search query
    final filteredCategories = categories
        .where((cat) => cat.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Filter offers for search results
    final filteredOffers = specialOffers
        .where((offer) => offer.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: h * 0.02),

              /// HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
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
                      child: Icon(Icons.close, color: colors.textPrimary, size: 20),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    "Search",
                    style: TextStyle(
                      fontSize: w * 0.06,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.03),

              /// SEARCH BAR
              CompositedTransformTarget(
                link: _layerLink,
                child: Container(
                  decoration: BoxDecoration(
                    color: _searchFocusNode.hasFocus ? colors.primaryLight : colors.surface,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: _searchFocusNode.hasFocus ? colors.primary : Colors.transparent,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 12,
                        color: colors.boxShadow,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "What are you craving?",
                      hintStyle: TextStyle(
                        color: colors.textSecondary.withOpacity(0.6),
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: colors.textSecondary, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.tune, color: colors.textSecondary, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const FilterScreen()),
                          );
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: h * 0.02),
                    ),
                  ),
                ),
              ),

              if (_searchQuery.isEmpty) ...[
                SizedBox(height: h * 0.04),

                /// CATEGORIES SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: colors.textPrimary,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoriesScreen(categories: categories),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsLegacy.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "See all",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.02),
                
                /// 4x2 GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categories.length > 8 ? 8 : categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return _buildCategoryIcon(categories[index], index, w, colors);
                  },
                ),

                SizedBox(height: h * 0.04),

                /// YOU MAY ALSO LIKE
                Text(
                  "You May Also Like",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.02),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: specialOffers.length > 4 ? 4 : specialOffers.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final item = specialOffers[index];
                    return _buildProductCard(item, w, colors);
                  },
                ),
              ] else ...[
                /// SEARCH RESULTS
                SizedBox(height: h * 0.04),
                Text(
                  "Search Results",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: h * 0.02),
                filteredOffers.isEmpty 
                  ? _buildNoResults(w, h, colors)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredOffers.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemBuilder: (context, index) {
                        final item = filteredOffers[index];
                        return _buildProductCard(item, w, colors);
                      },
                    ),
              ],
              SizedBox(height: h * 0.05),
            ],
          ),
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

  Widget _buildCategoryIcon(String name, int index, double w, dynamic colors) {
    final bgColors = [
      AppColors.category1, AppColors.category2, AppColors.category3, AppColors.category4,
      AppColors.category5, AppColors.category6, AppColors.category7, AppColors.category8,
    ];
    
    return Column(
      children: [
        Container(
          width: w * 0.16,
          height: w * 0.16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgColors[index % bgColors.length],
                colors.background,
              ],
            ),
          ),
          child: Center(
            child: Image.asset(
              "assets/images/$name.png",
              width: w * 0.08,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildProductCard(SpecialOffer item, double w, dynamic colors) {
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
          borderRadius: BorderRadius.circular(24),
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: colors.boxShadow,
              offset: const Offset(0, 4),
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
                  item.image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colors.border,
                    child: Icon(Icons.fastfood, color: colors.textSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: colors.textPrimary,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "1km | ",
                  style: TextStyle(color: colors.textSecondary, fontSize: 11, fontFamily: 'Montserrat'),
                ),
                const Icon(Icons.star, size: 12, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "${item.rating} (1.3k)",
                  style: TextStyle(color: colors.textSecondary, fontSize: 11, fontFamily: 'Montserrat'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "\$ ${item.price.toStringAsFixed(2)}",
              style: TextStyle(
                color: AppColorsLegacy.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults(double w, double h, dynamic colors) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: h * 0.1),
          Icon(Icons.search_off, size: 64, color: colors.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            "No results found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'Montserrat',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try searching for something else",
            style: TextStyle(
              color: colors.textSecondary,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}
