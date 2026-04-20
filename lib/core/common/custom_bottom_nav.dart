import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Nav item icons: Home, Ticket with a star, Messages, Profile
    final List<IconData> navIcons = [
      Icons.home_outlined,
      Icons.local_activity_outlined, 
      Icons.chat_bubble_outline,
      Icons.person_outline,
    ];

    final List<IconData> activeNavIcons = [
      Icons.home,
      Icons.local_activity,
      Icons.chat_bubble,
      Icons.person,
    ];

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 16),
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(navIcons.length, (i) {
            final isActive = index == i;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 60,
                height: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isActive ? activeNavIcons[i] : navIcons[i],
                      color: isActive ? Colors.white : Colors.grey.shade600,
                      size: 28,
                    ),
                    if (isActive)
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 8,
                          width: 16,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}