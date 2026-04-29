import 'package:flutter/material.dart';
import 'package:millio/core/common/custom_bottom_nav.dart';
import 'package:millio/features/home/presentation/screens/home_screen.dart';
import 'package:millio/features/home/presentation/screens/ticket_screen.dart';
import 'package:millio/features/home/presentation/screens/chat_box_screen.dart';
import 'package:millio/features/profile/presentation/screens/profile_screen.dart';
import 'package:millio/core/providers/tab_provider.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const TicketScreen(),
    const ChatBoxScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final tabProvider = context.watch<TabProvider>();
    final currentIndex = tabProvider.currentIndex;

    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.read<TabProvider>().goHome();
      },
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomBottomNav(
          index: currentIndex,
          onTap: (index) {
            context.read<TabProvider>().setIndex(index);
          },
        ),
      ),
    );
  }
}
