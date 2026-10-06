import 'package:flutter/material.dart';

// import '../screens/sign_in_screen.dart';
// import '../screens/dashboard_screen.dart';
// import '../screens/task_list_screen.dart';
// import '../screens/task_details_screen.dart';
// import '../screens/task_form_screen.dart';
// import '../screens/team_profile_screen.dart';
class AppRoutes {
  static const String signIn = '/';
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String taskDetails = '/task-details';
  static const String createTask = '/task/create';
  static const String editTask = '/task/edit';
  static const String teamProfile = '/team-profile';

  static final Map<String, WidgetBuilder> routes = {
    // signIn: (context) => const SignInScreen(),
    // dashboard: (context) => const DashboardScreen(),
    // tasks: (context) => const TaskListScreen(),
    // taskDetails: (context) => const TaskDetailsScreen(),
    // createTask: (context) => const TaskFormScreen(),
    // editTask: (context) => const TaskFormScreen(),
    // teamProfile: (context) => const TeamProfileScreen(),
  };
}