import "package:flutter/material.dart";

class Dashboard extends StatefulWidget {
  const new({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}


class _DashboardState extends State<Dashboard> {
  int currentScreen = 0;

  final List = [Text("Dashboard"),Text("TaskList"),Text("Add TaskList"),]
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dashboard"),
      ),
      body: ,
    );
  }
}