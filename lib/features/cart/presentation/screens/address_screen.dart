import 'package:flutter/material.dart';
import 'package:millio/core/constants/app_colors.dart';
import 'package:millio/features/cart/presentation/screens/add_address_screen.dart';

class SavedAddress {
  final String id;
  final String label;
  final String details;

  SavedAddress({
    required this.id,
    required this.label,
    required this.details,
  });
}

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String? _selectedAddressId = '1'; // Defaulting to the first one for demo

  final List<SavedAddress> _addresses = [
    SavedAddress(
      id: '1',
      label: 'Home',
      details: '23, Orchard Street, Near City Mall, New York, 10001',
    ),
    SavedAddress(
      id: '2',
      label: 'Office',
      details: 'Level 15, Tech Tower, 5th Avenue, New York, 10010',
    ),
    SavedAddress(
      id: '3',
      label: 'Home 2',
      details: 'Flat 402, Green Valley Apartments, Brooklyn, 11201',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final padding = w * 0.05;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.015),
              child: Row(
                children: [
                  Material(
                    color: AppColors.backgroundSecondary1,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.025),
                        child: Icon(Icons.arrow_back_ios_new, size: w * 0.045, color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.04),
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: w * 0.055,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // --- ADDRESS LIST ---
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: padding, vertical: h * 0.02),
                itemCount: _addresses.length,
                itemBuilder: (context, index) {
                  final address = _addresses[index];
                  final isSelected = _selectedAddressId == address.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAddressId = address.id;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: h * 0.02),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : AppColors.background,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.transparent,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                              ? AppColors.primary.withValues(alpha: .05) 
                              : AppColors.textPrimary.withValues(alpha: .04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Prefix Icon (Location Ring)
                          Container(
                            width: w * 0.12,
                            height: w * 0.12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 1.5),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on, color: AppColors.background, size: w * 0.05),
                            ),
                          ),
                          SizedBox(width: w * 0.04),

                          // Text Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.04,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: h * 0.005),
                                Text(
                                  address.details,
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: w * 0.032,
                                    fontFamily: 'Montserrat',
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Suffix Icons (Menu + Checkbox)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.more_horiz, color: AppColors.textSecondary),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  // Menu action
                                },
                              ),
                              SizedBox(height: h * 0.015),
                              // Selection Dot
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? AppColors.primary : AppColors.transparent,
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.backgroundSecondary3,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // --- ACTION BUTTONS ---
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: h * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddAddressScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryLight,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Add New Address",
                        style: TextStyle(
                          color: AppColors.primary,
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
                         // Apply logic
                        if (_selectedAddressId != null) {
                          Navigator.pop(context, _addresses.firstWhere((a) => a.id == _selectedAddressId));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: AppColors.background,
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
