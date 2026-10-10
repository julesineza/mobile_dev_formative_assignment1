import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../models/task.dart';

import 'package:intl/intl.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  final List<String> _checklistTitles = [
    'Map the happy path',
    'Design account setup',
    'Add validation states',
    'Create handoff notes',
    'Final team review',
  ];

  final List<bool> _checklistCompleted = [true, true, true, false, false];

  int get _completedCount =>
      _checklistCompleted.where((completed) => completed).length;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$_completedCount of ${_checklistTitles.length}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            for (int index = 0; index < _checklistTitles.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: AppColors.pageBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: Color(0xFFE3E7DF)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _checklistCompleted[index] =
                            !_checklistCompleted[index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _checklistCompleted[index]
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: _checklistCompleted[index]
                                ? AppColors.ink
                                : const Color(0xFFE3E7DF),
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _checklistTitles[index],
                              style: TextStyle(
                                color: _checklistCompleted[index]
                                    ? AppColors.muted
                                    : AppColors.ink,
                                fontSize: 14,
                                decoration: _checklistCompleted[index]
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  for (
                    int index = 0;
                    index < _checklistCompleted.length;
                    index++
                  ) {
                    _checklistCompleted[index] = true;
                  }
                });
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.ink,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(55),
                shape: const StadiumBorder(),
              ),
              icon: const Icon(Icons.check_circle_outline, size: 20),
              label: const Text(
                'Mark as complete',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
