import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';

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

  final offers = List.generate(6, (index) => index);

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: Colors.white,

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

                  Icon(Icons.notifications_none, size: w * .07),
                  SizedBox(width: w * .03),

                  Icon(Icons.menu, size: w * .07),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
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
                      color: const Color.fromARGB(255, 121, 39, 176),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),

                  Positioned(
                    right: 10,
                    bottom: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/images/Hamburger.png",
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * .03),

              /// CATEGORIES HEADER
              sectionHeader("Categories"),

              SizedBox(height: h * .015),

              /// CATEGORY LIST
              SizedBox(
                height: h * .14,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, index) {
                    return Container(
                      width: w * .22,
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: w * .08,
                            backgroundColor: Colors.orange.shade50,
                            child: Image.asset(
                              "assets/images/${categories[index]}.png",
                              width: w * .09,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            categories[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: w * .03),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: h * .025),

              /// HOT DEAL
              sectionHeader("Hot Deal Today"),

              SizedBox(height: h * .015),

              SizedBox(
                height: h * .28,
                child: PageView.builder(
                  controller: PageController(viewportFraction: .75),
                  itemCount: 5,
                  itemBuilder: (_, index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: DecorationImage(
                          image: AssetImage("assets/deal${index+1}.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: h * .03),

              /// SPECIAL OFFER
              sectionHeader("Special Offers"),

              SizedBox(height: h * .015),

              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: offers.length,
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: .72,
                ),
                itemBuilder: (_, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black12,
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
                              "assets/food1.png",
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          "Burger Meal",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14,
                                color: Colors.grey),
                            Text("1.2 km"),

                            Spacer(),

                            Icon(Icons.star,
                                size: 14,
                                color: Colors.amber),

                            Text("4.8"),
                            Text("(230)")
                          ],
                        ),

                        SizedBox(height: 6),

                        Text(
                          "\$12.99",
                          style: TextStyle(
                            color: Colors.green,
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
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_fill,
                    size: 60,
                  ),
                ),
              ),

              SizedBox(height: h * .03),
            ],
          ),
        ),
      ),

      /// REUSABLE NAV BAR
      bottomNavigationBar: CustomBottomNav(
        index: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
    );
  }

  Widget sectionHeader(String title) {
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
          onPressed: () {},
          child: Text("See All"),
        ),
      ],
    );
  }
}