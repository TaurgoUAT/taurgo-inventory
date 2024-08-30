import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:taurgo_inventory/constants/AppColors.dart';
import 'package:taurgo_inventory/pages/account_page.dart';
import 'package:taurgo_inventory/pages/landing_screen.dart';

class HomePage extends StatefulWidget {
  static final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void navigateToPage(int index) {
    setState(() {
      selected = index;
      controller.jumpToPage(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            selected = index;
          });
        },
        children: [LandingScreen(), AccountPage()],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: BubbleBarOptions(
          barStyle: BubbleBarStyle.horizontal,
          bubbleFillStyle: BubbleFillStyle.fill,
          opacity: 0.3,
        ),
        iconSpace: 24.0,
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.home,
              color: kPrimaryColor,
            ),
            title: const Text('Home'),
            backgroundColor: kPrimaryColor,
            selectedIcon: const Icon(Icons.home_outlined),
            // badge: const Text('1+'),
            // badgeColor: Colors.red,
            // showBadge: true,
          ),
          BottomBarItem(
            icon: const Icon(
              Icons.person,
              color: kPrimaryColor,
            ),
            title: const Text('Account'),
            backgroundColor: kPrimaryColor,
            selectedIcon: const Icon(Icons.perm_identity_rounded),
            // badge: const Text('1+'),
            // badgeColor: Colors.red,
            // showBadge: true,
          ),
        ],
        hasNotch: true,
        currentIndex: selected,
        onTap: (index) {
          setState(() {
            selected = index;
            controller.jumpToPage(index);
          });
        },
      ),
    );
  }
}
