// 🌸 MainLayout — écran principal avec la bottom navigation
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../screens/home_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/create_post_screen.dart';
import '../screens/messages_screen.dart';
import '../screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  final String prenom;
  const MainLayout({super.key, required this.prenom});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ecrans = [
      HomeScreen(prenom: widget.prenom),
      const ExploreScreen(),
      const CreatePostScreen(),
      const MessagesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.roseBg,
      body: ecrans[_index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.blanc,
          boxShadow: [
            BoxShadow(
              color: AppColors.rose.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home_outlined, Icons.home, 0),
                _navItem(Icons.explore_outlined, Icons.explore, 1),
                _navItemCenter(2),
                _navItem(Icons.chat_bubble_outline, Icons.chat_bubble, 3),
                _navItem(Icons.person_outline, Icons.person, 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icone, IconData iconeActive, int i) {
    final actif = _index == i;
    return GestureDetector(
      onTap: () => setState(() => _index = i),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          actif ? iconeActive : icone,
          color: actif ? AppColors.rose : AppColors.texteDoux,
          size: 26,
        ),
      ),
    );
  }

  Widget _navItemCenter(int i) {
    return GestureDetector(
      onTap: () => setState(() => _index = i),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.rose,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
