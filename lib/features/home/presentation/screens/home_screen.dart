import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/categories.dart';
import 'package:millio/features/home/presentation/screens/hot_deal_today.dart';
import 'package:millio/features/home/presentation/screens/special_offers.dart';
import 'package:millio/features/home/presentation/screens/chat_box_screen.dart';
import 'package:millio/features/cart/presentation/screens/cart.dart';
import 'package:millio/features/home/presentation/screens/notification_screen.dart';
import 'package:millio/features/home/presentation/screens/product_details.dart';
import 'package:millio/features/home/presentation/screens/filter_screen.dart';
import 'package:millio/features/home/presentation/screens/search_screen.dart';
import 'package:millio/features/home/data/models/product_model.dart';
import 'package:millio/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  
  String _searchQuery = "";
  final List<String> _recentSearches = ["Buffalo Chicken", "Pasta", "Burgers"];
  
  int currentIndex = 0;

  final categories = [
    "Desserts",
    "Lunch",
    "Appetizers",
    "Main Course",
    "Drink",
    "Vegetable",
    "Fast Food",
    "Sea Food"
  ];

  final PageController _pageController = PageController(viewportFraction: 0.75);

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
    return OverlayEntry(
      builder: (context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, h * 0.075), // Dynamic offset based on search bar height
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child: Container(
              width: w * 0.92, // Matching the screen padding
              constraints: BoxConstraints(maxHeight: h * 0.4), // Prevent overlay from taking too much space
              child: StatefulBuilder(
                builder: (context, setOverlayState) {
                  if (_recentSearches.isEmpty) return const SizedBox.shrink();
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _recentSearches.map((search) => ListTile(
                        tileColor: const Color.fromARGB(255, 222, 221, 221),
                        leading: const Icon(Icons.history, color: Colors.grey, size: 20),
                        title: Text(search, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: Colors.black)),
                        trailing: IconButton(
                          icon: const Icon(Icons.close, size: 18, color: Colors.grey,),
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
                      )).toList(),
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  late double w;
  late double h;

  @override
  void dispose() {
    _hideOverlay();
    _pageController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    w = size.width;
    h = size.height;

    final homeProvider = context.watch<HomeProvider>();
    final products = homeProvider.products;
    final hotDeals = homeProvider.hotDeals;

    // Filter categories based on search query
    final filteredCategories = categories
        .where((cat) => cat.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Filter special offers based on search query
    final filteredOffers = products
        .where((offer) => offer.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: colors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [

                  Image.asset(
                    "assets/images/Logo2.png",
                    width: w * .12,
                    color: colors.textPrimary
                  ),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                    child: Icon(Icons.notifications_none, size: w * .07),
                  ),
                  SizedBox(width: w * .03),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CartScreen()),
                      );
                    },
                    child: Icon(Icons.shopping_cart_outlined, size: w * .07),
                  ),
                  SizedBox(width: w * .03),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChatBoxScreen()),
                      );
                    },
                    child: Icon(Icons.menu, size: w * .07),
                  ),
                ],
              ),

              SizedBox(height: h * .02),

              /// TEXT
              Text(
                "What you want to eat today?",
                style: TextStyle(
                  fontSize: w * .08,
                  fontWeight: FontWeight.bold,
                  fontFamily:  'Montserrat',
                  color: colors.textPrimary,
                ),
              ),

              SizedBox(height: h * .02),

              /// SEARCH BAR
              CompositedTransformTarget(
                link: _layerLink,
                child: Container(
                  decoration: BoxDecoration(
                  color: (_searchFocusNode.hasFocus || _searchQuery.isNotEmpty) 
                      ? colors.primaryLight 
                      : colors.background,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: (_searchFocusNode.hasFocus || _searchQuery.isNotEmpty) 
                        ? colors.primary 
                        : AppColors.transparent,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: colors.boxShadow,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchScreen()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "What are you craving?",
                    prefixIcon: Icon(
                      Icons.search, 
                      color: Colors.grey,
                    ),
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
            ),

              SizedBox(height: h * .025),

              /// PURPLE BANNER
              Stack(
                children: [
                  Container(
                    height: h * .18,
                    decoration: BoxDecoration(
                      color: colors.homeBanner,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),

                  Positioned(
                    right: 10,
                    bottom: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/images/Hamburger.png",
                      width: w * 0.5,
                      height: h * 0.3,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 0,
                    top: 20,
                    child: Text('Sale Off 30%',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:  'Montserrat',
                    ),)
                  ),
                  Positioned(
                    left: 20,
                    bottom: 0,
                    top: 20,
                    child: Divider(
                      height: 2,          // total space occupied vertically
                      thickness: 2,        // actual line thickness
                      color: Colors.white24,
                      indent: 20,          // left spacing
                      endIndent: 20,       // right spacing
                    ),
                  ),
                  
                  Positioned(
                    left: 20,
                    bottom: 0,
                    top: 40,
                    child: Text('Special',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:  'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),)
                  ),

                   Positioned(
                    left: 20,
                    bottom: 0,
                    top: 80,
                    child: Text('Offers',
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily:  'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                    ),)
                  ),

                  Positioned(
                    left: 20,
                    bottom: 0,
                    top: 120,
                    child: 
                  Container(
                    height: h * 0.01,
                    width: w * 0.08,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: colors.boxShadow,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )),

                ],
              ),

              SizedBox(height: h * .03),

              /// CATEGORIES HEADER
              sectionHeader("Categories", onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoriesScreen(categories: categories),
                  ),
                );
              }),

              SizedBox(height: h * .015),

              /// CATEGORY LIST
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (_, index) {
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
                  return Column(
                    children: [
                      Container(
                        width: w * .16,
                        height: w * .16,
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
                            "assets/images/${filteredCategories[index]}.png",
                            width: w * .09,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        filteredCategories[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: w * .03),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: h * .025),

              /// HOT DEAL
              sectionHeader("Hot Deal Today", onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HotDealTodayScreen(),
                  ),
                );
              }),

              SizedBox(height: h * .015),

              homeProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: h * .35,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: hotDeals.length,
                        itemBuilder: (_, index) {
                          final deal = hotDeals[index];
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
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary.withAlpha(102), // ~0.4 opacity
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
                                    if (deal.image.isNotEmpty)
                                      Image.asset(
                                        deal.image,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: colors.primaryLight.withAlpha(153),
                                          );
                                        },
                                      )
                                    else
                                      Container(color: colors.primaryLight.withAlpha(153)),
                                    Container(
                                      color: Colors.black.withAlpha(100), // Darken image slightly for text readability
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 8),
                                          Text(
                                            deal.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$ ${deal.price.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

              SizedBox(height: h * .03),

              sectionHeader("Special Offers", onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialOffersScreen(specialOffers: products),
                  ),
                );
              }),

              SizedBox(height: h * .015),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOffers.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .72,
                ),
                itemBuilder: (_, index) {
                  final offer = filteredOffers[index];
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
                        color: colors.background,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: colors.boxShadow,
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
                                    color: colors.border,
                                    child: Icon(Icons.fastfood,
                                        color: colors.textSecondary)),
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
                                style: TextStyle(color: colors.textSecondary),
                              ),
                              const Icon(Icons.star,
                                  size: 14, color: Colors.amber),
                              Text(
                                offer.rating,
                                style: TextStyle(color: colors.textSecondary),
                              ),
                              Text(
                                offer.reviewCount,
                                style: TextStyle(color: colors.textSecondary),
                              )
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "\$${offer.price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: h * .03),

              /// VIDEO AREA
              Container(
                height: h * .22,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/video.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.transparent,
                            colors.textPrimary.withAlpha(204), // ~0.8 opacity
                          ],
                        ),
                      ),
                    ),
                     Positioned(
                      left: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            size: 40,
                            color: colors.background,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Video promotion",
                            style: TextStyle(
                              color: colors.background,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: h * .03),
            ],
          ),
        ),
      ),

    );
  }

  Widget sectionHeader(String title, {VoidCallback? onSeeAllTap}) {
    final colors = context.colors;
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: onSeeAllTap ?? () {},
          style: TextButton.styleFrom(
            backgroundColor: colors.primaryLight,
            foregroundColor: colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text("See All"),
        ),
      ],
    );
  }
}