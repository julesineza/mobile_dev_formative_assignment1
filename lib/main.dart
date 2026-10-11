import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'screens/dashboard_screen.dart';
import 'screens/sign_in_screen.dart';
import 'services/auth_storage.dart';

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
      home: const _AuthGate(),
      routes: AppRoutes.routes,
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthStorage().isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data! ? const Dashboard() : const SignInScreen();
      },
    );
  }
}
