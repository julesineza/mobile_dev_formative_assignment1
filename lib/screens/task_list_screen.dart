import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_storage.dart';
import '../theme/app_colors.dart';
import '../widgets/navabar.dart';
import '../widgets/task_card.dart';
import '../app_routes.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedFilter = 'All';
  final _storage = TaskStorage();
  List<Task> _tasks = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  bool _isAtRisk(Task task) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    return task.status != 'Done' && task.deadline.isBefore(tomorrow);
  }

  List<Task> get _filteredTasks {
    if (selectedFilter == 'At risk') {
      return _tasks.where(_isAtRisk).toList();
    }

    if (selectedFilter == 'Completed') {
      return _tasks.where((task) => task.status == 'Done').toList();
    }

    return _tasks;
  }

  Future<void> _loadTasks() async {
    final tasks = await _storage.loadTasks();

    if (!mounted) return;

    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _editTask(Task task) async {
    await Navigator.pushNamed(context, AppRoutes.editTask, arguments: task);

    if (!mounted) return;
    await _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sprint 04',
                      style: TextStyle(color: AppColors.muted, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'All tasks',
                      style: TextStyle(
                        color: AppColors.ink,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.softBackground,
                    foregroundColor: AppColors.ink,
                    fixedSize: const Size(50, 50),
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.notifications_outlined, size: 26),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: selectedFilter == 'All',
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = 'All';
                      });
                    },
                    showCheckmark: false,
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.softBackground,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: selectedFilter == 'All'
                          ? AppColors.white
                          : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('My tasks'),
                    selected: selectedFilter == 'My tasks',
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = 'My tasks';
                      });
                    },
                    showCheckmark: false,
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.softBackground,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: selectedFilter == 'My tasks'
                          ? AppColors.white
                          : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('At risk'),
                    selected: selectedFilter == 'At risk',
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = 'At risk';
                      });
                    },
                    showCheckmark: false,
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.softBackground,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: selectedFilter == 'At risk'
                          ? AppColors.white
                          : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ChoiceChip(
                    label: const Text('Completed'),
                    selected: selectedFilter == 'Completed',
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = 'Completed';
                      });
                    },
                    showCheckmark: false,
                    selectedColor: AppColors.ink,
                    backgroundColor: AppColors.softBackground,
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                    labelStyle: TextStyle(
                      color: selectedFilter == 'Completed'
                          ? AppColors.white
                          : AppColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_filteredTasks.isEmpty)
              const Text('No tasks match this filter.')
            else
              ..._filteredTasks.map(
                (task) => TaskCard(
                  title: task.name,
                  details: task.description,
                  status: _isAtRisk(task) ? 'At risk' : task.status,
                  statusColor: task.status == 'Done'
                      ? AppColors.completed
                      : _isAtRisk(task)
                      ? AppColors.atRisk
                      : AppColors.onTrack,
                  avatars: const [],
                  onTap: () => _editTask(task),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Navbar(
          selectedIndex: 1,
          onItemSelected: (index) {
            if (index == 0) {
              Navigator.popUntil(
                context,
                ModalRoute.withName(AppRoutes.dashboard),
              );
            }
          },
        ),
      ),
    );
  }
}
