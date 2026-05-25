import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:premium_hub/features/home/screens/home_screen.dart';
import 'package:premium_hub/core/widgets/glass_card.dart';
import 'package:premium_hub/features/profile/screens/profile_screen.dart';
import 'package:premium_hub/features/bookings/screens/booking_list_screen.dart';
import 'package:premium_hub/features/search/screens/search_screen.dart';
import 'package:premium_hub/features/messages/screens/conversation_list_screen.dart';
import 'package:premium_hub/main.dart';
import 'package:premium_hub/core/services/log_service.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const BookingListScreen(),
    const ConversationListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    LogService.screenLoad('MainNavigationScreen');
    final appState = Provider.of<AppState>(context);
    final currentIndex = appState.navigationIndex;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[currentIndex],
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: GlassCard(
              height: 70,
              borderRadius: 35,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavBarItem(
                    icon: LucideIcons.home,
                    isSelected: currentIndex == 0,
                    onTap: () {
                      LogService.tabChanged(0);
                      appState.setNavigationIndex(0);
                    },
                  ),
                  _NavBarItem(
                    icon: LucideIcons.search,
                    isSelected: currentIndex == 1,
                    onTap: () {
                      LogService.tabChanged(1);
                      appState.setNavigationIndex(1);
                    },
                  ),
                  _NavBarItem(
                    icon: LucideIcons.calendar,
                    isSelected: currentIndex == 2,
                    onTap: () {
                      LogService.tabChanged(2);
                      appState.setNavigationIndex(2);
                    },
                  ),
                  _NavBarItem(
                    icon: LucideIcons.messageSquare,
                    isSelected: currentIndex == 3,
                    onTap: () {
                      LogService.tabChanged(3);
                      appState.setNavigationIndex(3);
                    },
                  ),
                  _NavBarItem(
                    icon: LucideIcons.user,
                    isSelected: currentIndex == 4,
                    onTap: () {
                      LogService.tabChanged(4);
                      appState.setNavigationIndex(4);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.amber,
          size: 24,
        ),
      ),
    );
  }
}
