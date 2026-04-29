import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/categories.dart';
import 'package:millio/features/home/presentation/screens/hot_deal_today.dart';
import 'package:millio/features/home/presentation/screens/special_offers.dart';
import 'package:millio/features/home/presentation/screens/chat_box_screen.dart';
import 'package:millio/features/cart/presentation/screens/cart.dart';
import 'package:millio/features/home/presentation/screens/notification_screen.dart';

class SpecialOffer {
  final String image;
  final String title;
  final String distance;
  final String rating;
  final String reviewCount;
  final double price;

  SpecialOffer({
    required this.image,
    required this.title,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'distance': distance,
      'rating': rating,
      'reviewCount': reviewCount,
      'price': price,
    };
  }

  factory SpecialOffer.fromMap(Map<String, dynamic> map) {
    return SpecialOffer(
      image: map['image'] ?? '',
      title: map['title'] ?? '',
      distance: map['distance'] ?? '',
      rating: map['rating'] ?? '',
      reviewCount: map['reviewCount'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }
}

final List<SpecialOffer> specialOffers = [
  SpecialOffer(
    image: "assets/images/Buffalo Chicken Dip.png",
    title: "Buffalo Chicken Dip",
    distance: "1.2 km",
    rating: "4.8",
    reviewCount: "(230)",
    price: 12.99,
  ),
  SpecialOffer(
    image: "assets/images/Baked Spaghetti.png",
    title: "Baked Spaghetti",
    distance: "2.1 km",
    rating: "4.5",
    reviewCount: "(115)",
    price: 15.50,
  ),
  SpecialOffer(
    image: "assets/images/Maltesers Tiramisu.png",
    title: "Maltesers Tiramisu",
    distance: "0.8 km",
    rating: "4.9",
    reviewCount: "(540)",
    price: 24.00,
  ),
  SpecialOffer(
    image: "assets/images/Backyard Burgers.png",
    title: "Backyard Burgers",
    distance: "3.5 km",
    rating: "4.7",
    reviewCount: "(88)",
    price: 6.99,
  ),
  SpecialOffer(
    image: "assets/images/Sirloin steak.png",
    title: "Sirloin steak",
    distance: "1.5 km",
    rating: "4.6",
    reviewCount: "(122)",
    price: 4.50,
  ),
  SpecialOffer(
    image: "assets/images/Canadian Lobster.png",
    title: "Canadian Lobster",
    distance: "4.2 km",
    rating: "4.2",
    reviewCount: "(319)",
    price: 5.99,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,

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
                ),
              ),

              SizedBox(height: h * .02),

              /// SEARCH BAR
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      color: AppColors.textPrimarylight12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "What are you craving?",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.filter_list),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: h * .02,
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
                      color: AppColors.home,
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
                      color: AppColors.background,
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
                      color: AppColors.backgroundSecondary,
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
                      color: AppColors.background,
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
                      color: AppColors.background,
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
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textPrimarylight12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.chevron_right,
                        color: AppColors.background,
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
                itemCount: categories.length,
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
                              AppColors.background,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/images/${categories[index]}.png",
                            width: w * .09,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categories[index],
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

              SizedBox(
                height: h * .35,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 5,
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
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
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
                              // Image.asset(
                              //   "assets/deal${index + 1}.png",
                              //   fit: BoxFit.cover,
                              //   errorBuilder: (context, error, stackTrace) {
                              //     return const Center(
                              //       child: Icon(Icons.local_offer, color: Colors.white54, size: 50),
                              //     );
                              //   },
                              // ),
                              Container(
                                // width: w * 0.05,
                                // height: h * 0.05,
                                color: AppColors.primaryLight.withOpacity(0.6)),
                              Center(
                                child:Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                  Image.asset(
                                  "assets/images/food-1.png",
                                  width: w * 0.2,
                                  height: h * 0.2,
                                  
                                ),
                                Text('Seafood Som Tum',
                                maxLines: 2,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                
                                  Text('\$ 3.99 - \$ 2.59',
                                maxLines: 2,
                                style: const TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                  ]
                                )
                                 
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

              /// SPECIAL OFFER
              sectionHeader("Special Offers", onSeeAllTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialOffersScreen(specialOffers: specialOffers),
                  ),
                );
              }),

              SizedBox(height: h * .015),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: specialOffers.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .72,
                ),
                itemBuilder: (_, index) {
                  final offer = specialOffers[index];
                  return Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.background,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 8,
                          color: AppColors.textPrimarylight12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(18),
                            child: Image.asset(
                              offer.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: AppColors.backgroundSecondary2, child: const Icon(Icons.fastfood, color: AppColors.backgroundSecondary)),
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
                            Text("${offer.distance} |",
                            style: const TextStyle(
                              color: AppColors.textSecondary
                            ),),

                            const Icon(Icons.star,
                                size: 14,
                                color: Colors.amber),

                            Text(offer.rating,
                            style: const TextStyle(
                              color: AppColors.textSecondary
                            ),),
                            Text(offer.reviewCount,
                            style: const TextStyle(
                              color: AppColors.textSecondary
                            ),)
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
                            AppColors.textPrimary.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            size: 40,
                            color: AppColors.background,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Video promotion",
                            style: TextStyle(
                              color: AppColors.background,
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
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        TextButton(
          onPressed: onSeeAllTap ?? () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primaryLight05,
            foregroundColor: AppColors.primary,
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