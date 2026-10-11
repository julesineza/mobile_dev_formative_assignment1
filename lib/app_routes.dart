import 'package:flutter/material.dart';

import 'models/task.dart';
import 'screens/add_task.dart';
import 'screens/dashboard_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/task_details_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/team_profile_screen.dart';

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String dashboard = '/dashboard';
  static const String tasks = '/tasks';
  static const String taskDetails = '/task-details';
  static const String addTask = '/add-task';
  static const String createTask = addTask;
  static const String editTask = '/task/edit';
  static const String teamProfile = '/team-profile';

  static final Map<String, WidgetBuilder> routes = {
    // Login and registration
    signIn: (context) => const SignInScreen(),
    signUp: (context) => const SignUpScreen(),

    // Dashboard
    dashboard: (context) => const Dashboard(),

    // Create a new task
    addTask: (context) => NewTaskScreen(
      task: ModalRoute.of(context)?.settings.arguments as Task?,
    ),

    // Edit an existing task
    editTask: (context) => NewTaskScreen(
      task: ModalRoute.of(context)?.settings.arguments as Task?,
    ),

    // Task list
    tasks: (context) => const TaskListScreen(),
    teamProfile: (context) => const TeamProfileScreen(),
    taskDetails: (context) => TaskDetailsScreen(
      task: ModalRoute.of(context)!.settings.arguments as Task,
    ),
    // createTask: (context) => const TaskFormScreen(),
    // editTask: (context) => const TaskFormScreen(),
    // teamProfile: (context) => const TeamProfileScreen(),
  };
}
