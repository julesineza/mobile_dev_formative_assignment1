import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskStorage {
  static const _tasksKey = 'tasks';
  static const _assigneesKey = 'assignees';

  Future<List<Task>> loadTasks() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedTasks = preferences.getStringList(_tasksKey) ?? <String>[];
    return encodedTasks
        .map((encodedTask) =>
            Task.fromJson(jsonDecode(encodedTask) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTask(Task task) async {
    final tasks = await loadTasks();
    final taskIndex = tasks.indexWhere((item) => item.id == task.id);
    if (taskIndex == -1) {
      tasks.add(task);
    } else {
      tasks[taskIndex] = task;
    }
    await _saveTasks(tasks);
    await saveAssignees(task.assignees);
  }

  Future<void> deleteTask(String taskId) async {
    final tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks(tasks);
  }

  Future<List<String>> loadAssignees() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_assigneesKey) ?? <String>[];
  }

  Future<void> saveAssignees(Iterable<String> assignees) async {
    final current = await loadAssignees();
    final allAssignees = {...current, ...assignees}.toList()..sort();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_assigneesKey, allAssignees);
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _tasksKey,
      tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }
}
