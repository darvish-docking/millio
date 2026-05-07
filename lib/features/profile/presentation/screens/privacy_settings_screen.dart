import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _profileVisible = true;
  bool _showActivity = false;
  bool _personalizedAds = true;
  bool _dataUsageAnalytics = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileVisible = prefs.getBool("profileVisible") ?? true;
      _showActivity = prefs.getBool("showActivity") ?? false;
      _personalizedAds = prefs.getBool("personalizedAds") ?? true;
      _dataUsageAnalytics = prefs.getBool("dataUsageAnalytics") ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leadingWidth: 48,
        leading: Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: colors.border.withAlpha(50),
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
                    color: colors.textPrimary,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Privacy Setting",
          style: TextStyle(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.05,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.05, vertical: h * 0.02),
        child: Column(
          children: [
            _buildSection(
              context: context,
              title: "Profile Privacy",
              description: "Control who can see your profile information and activity.",
              children: [
                _buildToggleItem(
                  context: context,
                  title: "Public Profile",
                  subtitle: "Allow everyone to see your profile",
                  value: _profileVisible,
                  onChanged: (val) {
                    setState(() => _profileVisible = val);
                    _saveSetting("profileVisible", val);
                  },
                ),
                _buildToggleItem(
                  context: context,
                  title: "Show Activity Status",
                  subtitle: "Let others see when you're online",
                  value: _showActivity,
                  onChanged: (val) {
                    setState(() => _showActivity = val);
                    _saveSetting("showActivity", val);
                  },
                ),
              ],
            ),
            SizedBox(height: h * 0.03),
            _buildSection(
              context: context,
              title: "Ad Preferences",
              description: "Manage how we use your data for advertising purposes.",
              children: [
                _buildToggleItem(
                  context: context,
                  title: "Personalized Ads",
                  subtitle: "Ads tailored to your interests",
                  value: _personalizedAds,
                  onChanged: (val) {
                    setState(() => _personalizedAds = val);
                    _saveSetting("personalizedAds", val);
                  },
                ),
              ],
            ),
            SizedBox(height: h * 0.03),
            _buildSection(
              context: context,
              title: "Analytics & Data",
              description: "Help us improve Millio by sharing anonymous usage data.",
              children: [
                _buildToggleItem(
                  context: context,
                  title: "Usage Analytics",
                  subtitle: "Share anonymous app usage data",
                  value: _dataUsageAnalytics,
                  onChanged: (val) {
                    setState(() => _dataUsageAnalytics = val);
                    _saveSetting("dataUsageAnalytics", val);
                  },
                ),
              ],
            ),
            SizedBox(height: h * 0.05),
            Text(
              "Read our Full Privacy Policy",
              style: TextStyle(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String description,
    required List<Widget> children,
  }) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 4),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colors.textPrimary,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 12),
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors.boxShadow,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: colors.border, width: 1),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildToggleItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Montserrat', 
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Montserrat', 
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: colors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
