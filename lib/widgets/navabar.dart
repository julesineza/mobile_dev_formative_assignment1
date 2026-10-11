import 'package:flutter/material.dart';

import '../app_routes.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(23, 32, 27, 1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(icon: Icons.home_outlined, index: 0),

            _navItem(icon: Icons.checklist, index: 1),

            _navItem(icon: Icons.people_outline, index: 3),

            _addButton(context),

            // _navItem(icon: Icons.chat_bubble_outline, index: 4),
          ],
        ),
      ),
    );
  }

  Widget _navItem({required IconData icon, required int index}) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 29,
          color: isSelected ? const Color(0xFF111B18) : const Color(0xFF7A8580),
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.addTask),
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 201, 170, 83),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, size: 36, color: Color(0xFF111B18)),
        ),
      ),
    );
  }
}
