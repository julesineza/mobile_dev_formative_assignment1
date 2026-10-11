# SLA Task Tracker

A Flutter-based task management application designed for a small team or personal workflow. The app lets users sign in, manage sprint tasks, track deadlines, and view a lightweight team profile screen while keeping all account and task data saved locally on the device.

## Project overview

This project is a mobile productivity app built with Flutter and Dart. It focuses on a clean dashboard experience and a simple task-tracking flow, including:

- user sign-in and sign-up flow
- a dashboard view with a sprint overview
- task creation, editing, and deletion
- task filtering and overdue/at-risk alerts
- team profile and user switching
- local persistence with `shared_preferences`

The app is intentionally lightweight and does not rely on an external backend or database. Instead, data is stored locally on the device for demonstration and coursework purposes.

## Features

### Authentication
- Sign in with email and password
- Register a local user profile
- Load the signed-in user name into the dashboard
- Sign out and switch user

### Dashboard
- Personal welcome message with current date
- Sprint progress overview
- Completed task count and total task stats
- Task deadline and urgency summary

### Task management
- Add new tasks with title, description, deadline, priority, and assignees
- Edit existing tasks
- Delete tasks with confirmation
- Filter tasks by all tasks, my tasks, at-risk tasks, and completed items
- View task details and alerts for due/overdue tasks

### Team/workspace view
- Show the current user profile card
- Compile team members from tracked task assignees
- Display member initials and role summary

## Tech stack

- Flutter
- Dart
- `shared_preferences` for local state persistence
- Material Design UI components

## Project structure

```text
lib/
├── main.dart
├── app_routes.dart
├── models/
│   └── task.dart
├── screens/
│   ├── add_task.dart
│   ├── dashboard_screen.dart
│   ├── password_recovery_screen.dart
│   ├── sign_in_screen.dart
│   ├── sign_up_screen.dart
│   ├── task_details_screen.dart
│   ├── task_list_screen.dart
│   └── team_profile_screen.dart
├── services/
│   ├── auth_storage.dart
│   └── task_storage.dart
├── theme/
│   └── app_colors.dart
├── widgets/
│   ├── navabar.dart
│   └── task_card.dart
└──
```

## Prerequisites

Before running the project, make sure you have the following installed:

- Flutter SDK (this project targets Dart SDK `^3.13.2`)
- Android Studio or VS Code with Flutter extensions
- An Android emulator or a connected physical device
- Xcode if you are running on iOS/macOS

You can check your setup with:

```bash
flutter --version
flutter doctor
```

## Setup and run

1. Clone the repository:

```bash
git clone https://github.com/julesineza/mobile_dev_formative_assignment1.git
cd mobile_dev_formative_assignment1
```

2. Install dependencies:

```bash
flutter pub get
```

3. Start the app:

```bash
flutter run
```

4. If you want to run a specific platform emulator:

```bash
flutter devices
flutter run -d <device-id>
```

## Local data behavior

The app stores user credentials and tasks using `SharedPreferences`, which means:

- sign-in state is remembered on the device
- tasks remain available after restarting the app
- no backend or API configuration is required

This makes the project simple to run locally for classwork or demo purposes.

## Notes for development

- To reset the app state during testing, clear app data in the emulator/device settings or remove the saved values from the device storage.
- Most screens are implemented as Flutter stateful widgets and use local navigation routes defined in `lib/app_routes.dart`.
- The app is a single-screen, lightweight mobile experience rather than a full production backend-driven product.

