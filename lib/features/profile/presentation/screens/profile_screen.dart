import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/signIn_screen.dart';
import 'package:millio/features/home/presentation/screens/notification_screen.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:millio/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top Section with Curved Background and Avatar
            SizedBox(
              height: h * 0.25,
              child: Stack(
                children: [
                  // Curved Green Background
                  // ClipPath(
                  //   clipper: _HeaderClipper(),
                  //   child: Container(
                  //     height: h * 0.28,
                  //     width: double.infinity,
                  //     color: AppColors.primaryLight, // Or Color(0xFFD6EFC7)
                  //   ),
                  // ),

                  Image.asset('assets/images/profile-bg.png',
                  width: w,
                  fit: BoxFit.cover,),
                  
                  // Top Bar Elements
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Back Button
                          Material(
                            color: AppColors.background,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () => context.read<TabProvider>().goHome(),
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.025),
                                child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColors.textPrimary),
                              ),
                            ),
                          ),

                          SizedBox(width: w * 0.05,),
                          
                          // Title
                          Text(
                            "Account",
                            style: TextStyle(
                              fontSize: w * 0.06,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              color: AppColors.textPrimary,
                            ),
                          ),

                          Spacer(),
                          
                          // Notification Icon
                          Material(
                            color: AppColors.background,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const NotificationScreen()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.02),
                                child: Image.asset(
                                  'assets/images/Notification.png',
                                  width: w * 0.06,
                                  height: w * 0.06,
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.notifications_none, size: w * 0.06, color: AppColors.textPrimary),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Profile Avatar Overlapping
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top:95,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EditProfileScreen(),
                              ),
                            );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            // color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: w * 0.11,
                            // backgroundColor: Colors.pink.shade100, // Background color matching the image style
                            backgroundImage: const AssetImage('assets/images/profile.png'),
                            onBackgroundImageError: (exception, stackTrace) {},
                            child: null, // If image fails, you can put a fallback here, but AssetImage will handle it
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: h * 0.001),

            // User Info
            Text(
              '${context.watch<OnboardingProvider>().username}',
              style: TextStyle(
                fontSize: w * 0.055,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: h * 0.005),
            Text(
              context.watch<OnboardingProvider>().email,
              style: TextStyle(
                fontSize: w * 0.035,
                fontFamily: 'Montserrat',
                color: AppColors.backgroundSecondary6,
              ),
            ),

            SizedBox(height: h * 0.04),

            // Menu Items List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                children: [
                  _buildMenuItem(
                    w: w,
                    title: "Preferences",
                    imagePath: "assets/images/Setting.png", // Fallback image if Settings isn't there
                    fallbackIcon: Icons.settings_outlined,
                    gradientColors: [AppColors.category2, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Payment",
                    imagePath: "assets/images/Wallet.png",
                    fallbackIcon: Icons.account_balance_wallet_outlined,
                    gradientColors: [AppColors.category3, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Wishlist",
                    imagePath: "assets/images/Bookmark.png",
                    fallbackIcon: Icons.bookmark_border,
                    gradientColors: [AppColors.category4, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Addresses",
                    imagePath: "assets/images/Location.png",
                    fallbackIcon: Icons.location_on_outlined,
                    gradientColors: [AppColors.category5, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Privacy Setting",
                    imagePath: "assets/images/Lock.png",
                    fallbackIcon: Icons.lock_outline,
                    gradientColors: [AppColors.category6, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Change Password",
                    imagePath: "assets/images/Password.png",
                    fallbackIcon: Icons.password_outlined,
                    gradientColors: [AppColors.category7, AppColors.background],
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Sign Out",
                    imagePath: "assets/images/Logout.png",
                    fallbackIcon: Icons.logout_outlined,
                    gradientColors: [AppColors.category8, AppColors.background],
                    onTap: () async{
                      final prefs = await SharedPreferences.getInstance();

  await prefs.setBool("isLoggedIn", false);
  await prefs.remove("password");
  await prefs.remove("username"); 
  await prefs.remove("email"); 

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const SignInScreen(),
    ),
    (route) => false,
  );
                    },
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required double w,
    required String title,
    required String imagePath,
    required IconData fallbackIcon,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.05),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: w * 0.11,
            height: w * 0.11,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: w * 0.05,
                height: w * 0.05,
                color: AppColors.textPrimarylight87,
                errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: AppColors.textPrimarylight87, size: w * 0.05),
              ),
            ),
          ),
          SizedBox(width: w * 0.05),
          
          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: w * 0.035,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: AppColors.textPrimarylight87,
              ),
            ),
          ),
          
          // Trailing Button
          IconButton(
            onPressed: onTap,
            icon: Icon(Icons.chevron_right, color: AppColors.backgroundSecondary7, size: w * 0.06),
          ),
        ],
      ),
    );
  }
}


