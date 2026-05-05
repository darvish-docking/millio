import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _pushNotifications = true;
  String _selectedLanguage = "English";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool("pushNotifications") ?? true;
      _selectedLanguage = prefs.getString("language") ?? "English";
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.themeMode == ThemeMode.dark;
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
          "Preferences",
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
            _buildPreferenceSection(
              context: context,
              title: "App Theme",
              children: [
                _buildToggleItem(
                  context: context,
                  title: "Dark Theme",
                  value: isDarkTheme,
                  onChanged: (val) {
                    themeProvider.setTheme(val);
                    _savePreference("isDarkMode", val);
                  },
                ),
                _buildToggleItem(
                  context: context,
                  title: "Light Theme",
                  value: !isDarkTheme,
                  onChanged: (val) {
                    themeProvider.setTheme(!val);
                    _savePreference("isDarkMode", !val);
                  },
                ),
              ],
            ),
            SizedBox(height: h * 0.03),
            _buildPreferenceSection(
              context: context,
              title: "Notifications",
              children: [
                _buildToggleItem(
                  context: context,
                  title: "Push Notifications",
                  value: _pushNotifications,
                  onChanged: (val) {
                    setState(() => _pushNotifications = val);
                    _savePreference("pushNotifications", val);
                  },
                ),
              ],
            ),
            SizedBox(height: h * 0.03),
            _buildPreferenceSection(
              context: context,
              title: "General",
              children: [
                _buildDropdownItem(
                  context: context,
                  title: "Language",
                  value: _selectedLanguage,
                  items: ["English", "Spanish", "French", "German"],
                  onChanged: (val) {
                    setState(() => _selectedLanguage = val!);
                    _savePreference("language", val);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
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
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14,
              color: colors.textPrimary,
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

  Widget _buildDropdownItem({
    required BuildContext context,
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Montserrat', 
              fontSize: 14,
              color: colors.textPrimary,
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            dropdownColor: colors.cardBackground,
            style: TextStyle(
              color: colors.textPrimary,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
