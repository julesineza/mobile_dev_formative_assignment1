import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/task.dart';
import '../services/task_storage.dart';

import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final _storage = TaskStorage();
  bool _isSaving = false;

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String get _displayStatus {
    final task = widget.task;

    if (task.status == 'Done') return 'Done';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (task.deadline.isBefore(today)) return 'Overdue';
    if (task.deadline.isBefore(tomorrow)) return 'At risk';

    return task.status;
  }

  Color get _statusColor {
    if (_displayStatus == 'Done') return AppColors.completed;
    if (_displayStatus == 'Overdue') return AppColors.overdue;
    if (_displayStatus == 'At risk') return AppColors.atRisk;

    return AppColors.onTrack;
  }

  Future<void> _markAsComplete() async {
    if (_isSaving || widget.task.status == 'Done') return;

    setState(() => _isSaving = true);

    try {
      final completedTask = widget.task.copyWith(
        status: 'Done',
        completedAt: DateTime.now(),
      );
      await _storage.saveTask(completedTask);

      if (!mounted) return;
      Navigator.pop(context, completedTask);
    } catch (error) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not complete the task. Please try again.'),
        ),
      );
    }
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
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.softBackground,
                    foregroundColor: AppColors.ink,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.arrow_back, size: 20),
                ),
                const Text(
                  'Task details',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () {},
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.softBackground,
                    foregroundColor: AppColors.ink,
                    shape: const CircleBorder(),
                  ),
                  icon: const Icon(Icons.more_horiz, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _displayStatus.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.task.name,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              widget.task.description,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _infoRow(
                    icon: Icons.calendar_month_outlined,
                    label: 'Deadline',
                    value: DateFormat('MMM d, yyyy')
                        .format(widget.task.deadline),
                  ),
                  const Divider(height: 28, color: Color(0xFFE3E7DF)),
                  _infoRow(
                    icon: Icons.account_circle_outlined,
                    label: 'Assigned to',
                    value: widget.task.assignees.isEmpty
                        ? 'Unassigned'
                        : widget.task.assignees.join(', '),
                  ),
                  const Divider(height: 28, color: Color(0xFFE3E7DF)),
                  _infoRow(
                    icon: Icons.access_time,
                    label: 'Priority',
                    value: widget.task.priority,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _isSaving || widget.task.status == 'Done'
                  ? null
                  : () => _markAsComplete(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(55),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: Text(
                _isSaving
                    ? 'Saving...'
                    : widget.task.status == 'Done'
                    ? 'Completed'
                    : 'Mark as complete',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
