import 'package:flutter/material.dart';

import '../widgets/navabar.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(252, 252, 249, 1),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(24), children: [
            
          ],
        ),
      ),
      bottomNavigationBar: Navbar(selectedIndex: 1, onItemSelected: (index) {}),
    );
  }
}
