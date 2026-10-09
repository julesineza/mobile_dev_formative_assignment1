import 'package:flutter/material.dart';

import 'app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SLA task tracker',
      initialRoute: AppRoutes.tasks,
      routes: AppRoutes.routes,
    );
  }
}
