import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';
import 'package:phrases_to_share/shared/widgets/app_bar/app_bar_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: AppColors.primary),
      home: Scaffold(
        appBar: AppBarWidget(userName: "Sérgio"),
        body: const Center(child: Text('Hello World!')),
      ),
    );
  }
}
