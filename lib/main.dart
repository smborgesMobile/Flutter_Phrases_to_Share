import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';
import 'package:phrases_to_share/shared/widgets/app_bar/app_bar_widget.dart';
import 'package:phrases_to_share/shared/widgets/bottom_navigation/bottom_navigation_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      const Center(child: Text('Home')),
      const Center(child: Text('Profile')),
      const Center(child: Text('Settings')),
    ];

    return MaterialApp(
      theme: ThemeData(primaryColor: AppColors.primary),
      home: Scaffold(
        appBar: AppBarWidget(userName: "Sérgio"),
        body: bodies[_selectedIndex],
        bottomNavigationBar: BottomNavigationWidget(
          initialIndex: _selectedIndex,
          onItemSelected: _onNavItemSelected,
        ),
      ),
    );
  }
}
