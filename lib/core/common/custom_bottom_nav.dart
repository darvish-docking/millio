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
    return BottomNavigationBar(
      currentIndex: index,
      onTap: onTap,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [

        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: "Wishlist",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: "Cart",
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}