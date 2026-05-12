import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/core/services/database_service.dart';
import 'package:millio/features/auth/presentation/providers/onboarding.dart';
import 'package:millio/features/home/data/models/product_model.dart';
import 'package:provider/provider.dart';

class AddReviewScreen extends StatefulWidget {
  final Product offer;

  const AddReviewScreen({super.key, required this.offer});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;
  String? _ratingError;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Validate rating
    if (_selectedRating == 0) {
      setState(() {
        _ratingError = "Please select a star rating";
      });
      return;
    }

    // Validate comment
    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please write a review before submitting")),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid ?? '';

      // Read username and profilePicture from OnboardingProvider (already
      // loaded from SharedPreferences — no extra Firestore call needed).
      final onboarding = context.read<OnboardingProvider>();
      final userName = onboarding.username.trim().isNotEmpty
          ? onboarding.username
          : (user?.email ?? 'Anonymous');
      final profilePicture = onboarding.profilePicture;

      await DatabaseService().addReview(
        productId: widget.offer.id,
        uid: uid,
        userName: userName,
        rating: _selectedRating.toDouble(),
        comment: _reviewController.text.trim(),
        profilePicture: profilePicture,
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Material(
              color: AppColorsLegacy.backgroundSecondary1,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back_ios_new,
                      size: 18, color: AppColorsLegacy.textPrimary),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          "Add A Review",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: colors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding),
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: h * 0.03),

                  // Product Image (Square, Centered)
                  Center(
                    child: Container(
                      width: w * 0.38,
                      height: w * 0.38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(w * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: AppColorsLegacy.textPrimary.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage(widget.offer.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  // Item Name
                  Text(
                    widget.offer.title,
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: h * 0.05),

                  // Interactive Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedRating = index + 1;
                            _ratingError = null; // clear error on tap
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.015),
                          child: Icon(
                            index < _selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColorsLegacy.amber,
                            size: w * 0.12,
                          ),
                        ),
                      );
                    }),
                  ),

                  // Rating error message
                  if (_ratingError != null) ...[
                    SizedBox(height: h * 0.01),
                    Text(
                      _ratingError!,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: w * 0.035,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],

                  SizedBox(height: h * 0.06),

                  // Heading: Rating description
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Rating description",
                      style: TextStyle(
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.02),

                  // Text Field
                  TextField(
                    controller: _reviewController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Message",
                      hintStyle: TextStyle(
                        color: AppColorsLegacy.backgroundSecondary4,
                        fontFamily: 'Montserrat',
                        fontSize: w * 0.038,
                      ),
                      filled: true,
                      fillColor: colors.textField,
                      contentPadding: EdgeInsets.all(w * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: BorderSide(
                            color: AppColorsLegacy.backgroundSecondary1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: BorderSide(color: colors.textField),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: BorderSide(
                            color: AppColorsLegacy.primary, width: 1.5),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: w * 0.04,
                      color: AppColorsLegacy.textPrimarylight87,
                    ),
                  ),

                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
          ),

          // Submit Button
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
            child: SizedBox(
              width: double.infinity,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorsLegacy.primary,
                  disabledBackgroundColor:
                      AppColorsLegacy.primary.withOpacity(0.6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.08),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        "Submit",
                        style: TextStyle(
                          color: AppColorsLegacy.background,
                          fontSize: w * 0.045,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
