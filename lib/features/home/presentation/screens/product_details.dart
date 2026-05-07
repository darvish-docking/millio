import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/product_description_screen.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/reviews_screen.dart';
import 'package:millio/features/cart/presentation/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final SpecialOffer offer;

  const ProductDetailsScreen({super.key, required this.offer});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;
  bool isDescriptionExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  
  String _searchQuery = "";
  final List<String> _recentSearches = ["Buffalo Chicken", "Pasta", "Burgers"];
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _hideOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Semi-transparent background to help visibility and handle clicks outside
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _searchFocusNode.unfocus();
                setState(() {
                  _isSearchActive = false;
                });
              },
              child: Container(color: Colors.transparent),
            ),
          ),
          UnconstrainedBox(
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 45), // Fixed offset below the search bar
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                child: Container(
                  width: w * 0.85,
                  constraints: BoxConstraints(maxHeight: h * 0.4),
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      if (_recentSearches.isEmpty) return const SizedBox.shrink();
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Recent Searches", 
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _recentSearches.clear();
                                      });
                                      setOverlayState(() {});
                                      _hideOverlay();
                                    },
                                    child: const Text("Clear All", style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                            ..._recentSearches.map((search) => ListTile(
                              leading: const Icon(Icons.history, color: Colors.grey, size: 20),
                              title: Text(search, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.black)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () {
                                  setState(() {
                                    _recentSearches.remove(search);
                                  });
                                  setOverlayState(() {});
                                  if (_recentSearches.isEmpty) _hideOverlay();
                                },
                              ),
                              onTap: () {
                                _searchController.text = search;
                                setState(() {
                                  _searchQuery = search;
                                });
                                _searchFocusNode.unfocus();
                              },
                            )),
                          ],
                        ),
                      );
                    }
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;
    final iconSize = w * 0.1;
    final offer = widget.offer;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          /// 🖼️ LAYER 1: Background Image (Static)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: h * 0.55,
            child: Image.asset(
              offer.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColorsLegacy.backgroundSecondary2,
                child: Icon(Icons.fastfood, size: w * 0.2, color: AppColorsLegacy.backgroundSecondary),
              ),
            ),
          ),

          /// 📜 LAYER 2: Scrollable Foreground Header & Details
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: h * 0.48),
                Container(
                  width: w,
                  padding: EdgeInsets.fromLTRB(padding, h * 0.02, padding, padding),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorsLegacy.textPrimarylight12,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: w * 0.1,
                          height: 4,
                          margin: EdgeInsets.only(bottom: h * 0.02),
                          decoration: BoxDecoration(
                            color: AppColorsLegacy.backgroundSecondary3,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.006),
                        decoration: BoxDecoration(
                          color: AppColorsLegacy.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Popular",
                          style: TextStyle(
                            color: AppColorsLegacy.primary,
                            fontSize: w * 0.03,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        offer.title,
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: h * 0.005),
                      Text(
                        "\$${offer.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: w * 0.06,
                          fontWeight: FontWeight.bold,
                          color: AppColorsLegacy.primary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewsScreen(offer: offer),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: w * 0.04, color: Colors.grey),
                            SizedBox(width: w * 0.01),
                            Text(
                              offer.distance,
                              style: TextStyle(color: AppColorsLegacy.backgroundSecondary, fontSize: w * 0.035, fontFamily: 'Montserrat'),
                            ),
                            SizedBox(width: w * 0.04),
                            Icon(Icons.star, size: w * 0.04, color: AppColorsLegacy.amber),
                            SizedBox(width: w * 0.01),
                            Text(
                              "${offer.rating} ${offer.reviewCount}",
                              style: TextStyle(color: AppColorsLegacy.backgroundSecondary, fontSize: w * 0.035, fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        "Experience the amazing taste of our freshly prepared ${offer.title}. Masterfully cooked with the best ingredients carefully sourced by top chefs in town. Serve hot to get the perfect joy of its blend of flavors and aroma.",
                        style: TextStyle(
                          fontSize: w * 0.035,
                          color: AppColorsLegacy.textSecondary,
                          height: 1.6,
                          fontFamily: 'Montserrat',
                        ),
                        maxLines: isDescriptionExpanded ? null : 3,
                        overflow: isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDescriptionScreen(offer: offer),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: h * 0.005),
                          child: Text(
                            "Read more",
                            style: TextStyle(
                              color: AppColorsLegacy.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.035,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: h * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColorsLegacy.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Material(
                                  color: AppColorsLegacy.primaryDark,
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: () {
                                      if (quantity > 1) {
                                        setState(() => quantity--);
                                      }
                                    },
                                    child: SizedBox(
                                      width: w * 0.08,
                                      height: w * 0.08,
                                      child: Icon(Icons.remove, size: w * 0.05, color: AppColorsLegacy.background),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: w * 0.045,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                      color: AppColorsLegacy.primaryDark,
                                    ),
                                  ),
                                ),
                                Material(
                                  color: AppColorsLegacy.primaryDark,
                                  borderRadius: BorderRadius.circular(8),
                                  clipBehavior: Clip.hardEdge,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => quantity++);
                                    },
                                    child: SizedBox(
                                      width: w * 0.08,
                                      height: w * 0.08,
                                      child: Icon(Icons.add, size: w * 0.05, color: AppColorsLegacy.background),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: padding),
                          Expanded(
                            child: SizedBox(
                              height: h * 0.065,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<CartProvider>().addItem(offer, quantity);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("${offer.title} added to cart"),
                                      backgroundColor: AppColorsLegacy.primary,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColorsLegacy.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Add to cart",
                                  style: TextStyle(
                                    color: AppColorsLegacy.background,
                                    fontSize: w * 0.045,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: h * 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🏗️ LAYER 3: Fixed Action Buttons (with Search functionality)
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Back Button
                  if (!_isSearchActive)
                    Material(
                      color: AppColorsLegacy.backgroundSecondary3,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: SizedBox(
                          height: iconSize,
                          width: iconSize,
                          child: Center(
                            child: Image.asset(
                              'assets/images/left-arrow.png',
                              width: iconSize * 0.45,
                              height: iconSize * 0.45,
                            ),
                          ),
                        ),
                      ),
                    ),

                  /// Search Field / Buttons
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (_isSearchActive)
                          Expanded(
                            child: CompositedTransformTarget(
                              link: _layerLink,
                              child: Container(
                                height: iconSize,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  autofocus: true,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                  onSubmitted: (value) {
                                    if (value.isNotEmpty && !_recentSearches.contains(value)) {
                                      setState(() {
                                        _recentSearches.insert(0, value);
                                      });
                                    }
                                    setState(() {
                                      _isSearchActive = false;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily: 'Montserrat',
                                    ),
                                    border: InputBorder.none,
                                    prefixIcon: const Icon(Icons.search, size: 20),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      onPressed: () {
                                        setState(() {
                                          _isSearchActive = false;
                                          _searchQuery = "";
                                          _searchController.clear();
                                        });
                                      },
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (!_isSearchActive)
                          Material(
                            color: Colors.white.withOpacity(0.9),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _isSearchActive = true;
                                });
                              },
                              child: SizedBox(
                                height: iconSize,
                                width: iconSize,
                                child: Center(
                                  child: Icon(Icons.search, size: iconSize * 0.55, color: AppColorsLegacy.textPrimarylight87),
                                ),
                              ),
                            ),
                          ),
                        if (!_isSearchActive) ...[
                          SizedBox(width: padding * 0.6),
                          Material(
                            color: AppColorsLegacy.background.withOpacity(0.9),
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox(
                                height: iconSize,
                                width: iconSize,
                                child: Center(
                                  child: Icon(Icons.favorite_border, size: iconSize * 0.55, color: AppColorsLegacy.textPrimarylight87),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
