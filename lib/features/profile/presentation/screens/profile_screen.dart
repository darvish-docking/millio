import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/theme/app_images.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/auth/presentation/screens/signIn_screen.dart';
import 'package:millio/features/home/presentation/screens/notification_screen.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:millio/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:millio/features/cart/presentation/screens/address_screen.dart';
import 'package:millio/features/cart/presentation/screens/payment_method_screen.dart';
import 'package:millio/features/auth/presentation/screens/new_password.dart';
import 'package:millio/features/profile/presentation/screens/preferences_screen.dart';
import 'package:millio/features/profile/presentation/screens/privacy_settings_screen.dart';
import 'package:millio/features/profile/presentation/screens/wishlist_screen.dart';
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
                final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Top Section with Curved Background and Avatar
            SizedBox(
              height: h * 0.25,
              child: Stack(
                children: [
                  Image.asset(
                    // 'assets/images/profile-bg.png',
                    AppImages.profile_bg(context),
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
                            color: AppColorsLegacy.background,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: InkWell(
                              onTap: () => context.read<TabProvider>().goHome(),
                              child: Padding(
                                padding: EdgeInsets.all(w * 0.025),
                                child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColorsLegacy.textPrimary),
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
                              color: AppColorsLegacy.textPrimary,
                            ),
                          ),

                          Spacer(),
                          
                          // Notification Icon
                          Material(
                            color: AppColorsLegacy.background,
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
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.notifications_none, size: w * 0.06, color: AppColorsLegacy.textPrimary),
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
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: w * 0.11,
                            backgroundImage: const AssetImage('assets/images/profile.png'),
                            onBackgroundImageError: (exception, stackTrace) {},
                            child: null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // User Info
            Text(
              context.watch<OnboardingProvider>().username,
              style: TextStyle(
                fontSize: w * 0.055,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: colors.textPrimary,
              ),
            ),
            SizedBox(height: h * 0.005),
            Text(
              context.watch<OnboardingProvider>().email,
              style: TextStyle(
                fontSize: w * 0.035,
                fontFamily: 'Montserrat',
                color: AppColorsLegacy.backgroundSecondary6,
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
                    imagePath: "assets/images/Setting.png",
                    fallbackIcon: Icons.settings_outlined,
                    gradientColors: [AppColors.category2, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PreferencesScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Payment",
                    imagePath: "assets/images/Wallet.png",
                    fallbackIcon: Icons.account_balance_wallet_outlined,
                    gradientColors: [AppColors.category3, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentMethodScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Wishlist",
                    imagePath: "assets/images/Bookmark.png",
                    fallbackIcon: Icons.bookmark_border,
                    gradientColors: [AppColors.category4, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WishlistScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Addresses",
                    imagePath: "assets/images/Location.png",
                    fallbackIcon: Icons.location_on_outlined,
                    gradientColors: [AppColors.category5, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddressScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Privacy Setting",
                    imagePath: "assets/images/Lock.png",
                    fallbackIcon: Icons.lock_outline,
                    gradientColors: [AppColors.category6, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacySettingsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Change Password",
                    imagePath: "assets/images/Password.png",
                    fallbackIcon: Icons.password_outlined,
                    gradientColors: [AppColors.category7, colors.background],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    w: w,
                    title: "Sign Out",
                    imagePath: "assets/images/Logout.png",
                    fallbackIcon: Icons.logout_outlined,
                    gradientColors: [AppColors.category8, colors.background],
                    onTap: () async {
                      // Reset tab index to 0 before logging out
                      if (context.mounted) {
                        Provider.of<TabProvider>(context, listen: false).goHome();
                      }

                      // Call Firebase Sign Out via OnboardingProvider
                      if (context.mounted) {
                        await context.read<OnboardingProvider>().logout();
                      }

                      if (!mounted) return;
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
                final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
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
                  color: AppColorsLegacy.textPrimarylight87,
                  errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, color: AppColorsLegacy.textPrimarylight87, size: w * 0.05),
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
                  color: colors.textPrimary,
                ),
              ),
            ),
            
            // Trailing Button
            IconButton(
              onPressed: onTap,
              icon: Icon(Icons.chevron_right, color: AppColorsLegacy.backgroundSecondary7, size: w * 0.06),
            ),
          ],
        ),
      ),
    );
  }
}
