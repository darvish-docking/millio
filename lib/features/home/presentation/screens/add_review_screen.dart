import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';

class AddReviewScreen extends StatefulWidget {
  final SpecialOffer offer;

  const AddReviewScreen({super.key, required this.offer});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  int _selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: Material(
              color: AppColors.backgroundSecondary1,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary,),
                ),
              ),
            ),
          ),
        ),
        title: const Text(
          "Add A Review",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: AppColors.textPrimary,
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
                            color: AppColors.textPrimary.withOpacity(0.08),
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
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.015),
                          child: Icon(
                            index < _selectedRating ? Icons.star : Icons.star_border,
                            color: AppColors.amber,
                            size: w * 0.12,
                          ),
                        ),
                      );
                    }),
                  ),
                  
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
                        color: AppColors.backgroundSecondary4,
                        fontFamily: 'Montserrat',
                        fontSize: w * 0.038,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundSecondary1,
                      contentPadding: EdgeInsets.all(w * 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: BorderSide(color: AppColors.backgroundSecondary1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: BorderSide(color: AppColors.backgroundSecondary1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(w * 0.04),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: w * 0.04,
                      color: AppColors.textPrimarylight87,
                    ),
                  ),
                  
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
          ),
          
          // Submit Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
            child: SizedBox(
              width: double.infinity,
              height: h * 0.065,
              child: ElevatedButton(
                onPressed: () {
                  // In a real app, logic to save review would go here
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(w * 0.08),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    color: AppColors.background,
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
