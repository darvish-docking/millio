import 'dart:async';

import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/services/auth_service.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/cart/data/models/card_model.dart';
import 'package:millio/features/cart/presentation/screens/add_card_screen.dart';

class SavedCardsScreen extends StatefulWidget {
  const SavedCardsScreen({super.key});

  @override
  State<SavedCardsScreen> createState() => _SavedCardsScreenState();
}

class _SavedCardsScreenState extends State<SavedCardsScreen> {
  List<CardInfo> _cards = [];
  bool _isLoading = true;
  String? _selectedCardId;
  StreamSubscription<List<CardInfo>>? _cardSubscription;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  void dispose() {
    _cardSubscription?.cancel();
    super.dispose();
  }

  void _fetchCards() {
    final user = AuthService().currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    _cardSubscription = DatabaseService().getUserCards(user.uid).listen((cards) {
      if (!mounted) return;
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    }, onError: (e) {
      debugPrint('Cards stream error: $e');
      if (!mounted) return;
      setState(() => _isLoading = false);
    });
  }

  String _networkAsset(String network) {
    switch (network) {
      case 'visa': return 'assets/images/Visa.png';
      case 'mastercard': return 'assets/images/MasterCard.png';
      case 'amex': return 'assets/images/Card.png';
      default: return 'assets/images/Wallet.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColorsLegacy.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColorsLegacy.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    "My Cards",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // --- CARDS LIST ---
            Expanded(
              child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cards.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "No saved cards",
                                style: TextStyle(
                                  fontSize: w * 0.04,
                                  color: AppColorsLegacy.textSecondary,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              SizedBox(height: h * 0.02),
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push<CardInfo>(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AddCardScreen()),
                                  );
                                  if (result != null && mounted) {
                                    setState(() => _selectedCardId = result.id);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColorsLegacy.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Add New Card",
                                  style: TextStyle(
                                    color: AppColorsLegacy.background,
                                    fontSize: w * 0.035,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  final card = _cards[index];
                  final isSelected = _selectedCardId == card.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCardId = card.id);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 0.02),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? colors.hintText : colors.textField,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColorsLegacy.primary : AppColors.transparent,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                              ? AppColorsLegacy.primary.withValues(alpha: .05) 
                              : AppColorsLegacy.textPrimary.withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Card Network Icon
                          Image.asset(
                            _networkAsset(card.cardNetwork),
                            width: w * 0.1,
                            height: w * 0.1,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: w * 0.04),

                          // Card Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.maskedNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                    fontFamily: 'Montserrat',
                                    color: colors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  'Expires ${card.expiryDate}',
                                  style: TextStyle(
                                    color: AppColorsLegacy.textSecondary,
                                    fontSize: w * 0.032,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Selection Dot
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColorsLegacy.primary : AppColors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColorsLegacy.primary : AppColorsLegacy.backgroundSecondary3,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- BOTTOM BUTTONS ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push<CardInfo>(
                          context,
                          MaterialPageRoute(builder: (context) => const AddCardScreen()),
                        );
                        if (result != null && mounted) {
                          setState(() => _selectedCardId = result.id);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsLegacy.primaryLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Add New Card",
                        style: TextStyle(
                          color: AppColorsLegacy.primary,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.015),
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedCardId != null) {
                          Navigator.pop(context, _selectedCardId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColorsLegacy.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Use This Card",
                        style: TextStyle(
                          color: AppColorsLegacy.background,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
