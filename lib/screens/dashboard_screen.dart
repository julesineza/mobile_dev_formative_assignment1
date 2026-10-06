import "package:flutter/material.dart";

import '../widgets/navabar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text("Dashboard"),
        ),
        bottomNavigationBar: Navbar(
          selectedIndex: currentScreen,
          onItemSelected: (index) {
            setState(() {
              currentScreen = index;
            });
          },
        ),
      ),
    );
  }
}
