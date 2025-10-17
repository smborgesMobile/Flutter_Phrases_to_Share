import 'package:flutter/material.dart';
import 'package:phrases_to_share/shared/themes/app_colors.dart';

class BottomNavigationWidget extends StatefulWidget {
  final ValueChanged<int>? onItemSelected;
  final int initialIndex;

  const BottomNavigationWidget({super.key, this.onItemSelected, this.initialIndex = 0});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (widget.onItemSelected != null) widget.onItemSelected!(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.body,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Imagens'),
        BottomNavigationBarItem(
          icon: Icon(Icons.format_quote),
          label: 'Frases',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.share),
          label: 'Compartilhados',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
