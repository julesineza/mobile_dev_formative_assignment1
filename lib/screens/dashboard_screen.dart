import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../services/auth_storage.dart';
import '../services/task_storage.dart';
import '../widgets/navabar.dart';

const _ink = Color(0xFF17211D);
const _muted = Color(0xFF7C8883);
const _pageBackground = Color.fromRGBO(252, 252, 249, 1);

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _taskStorage = TaskStorage();
  final _authStorage = AuthStorage();
  List<Task> _savedTasks = [];
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadProfile();
  }

  Future<void> _loadTasks() async {
    final tasks = await _taskStorage.loadTasks();
    if (mounted) setState(() => _savedTasks = tasks);
  }

  Future<void> _loadProfile() async {
    final name = await _authStorage.loadName();
    if (!mounted) return;
    setState(
      () => _userName = name?.trim().isNotEmpty == true ? name!.trim() : 'User',
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    final String formattedDate = DateFormat('EEEE, MMMM d').format(now);

    return Scaffold(
      backgroundColor: _pageBackground,
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: const _DashboardScrollBehavior(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _welcomeHeader(formattedDate),
                const SizedBox(height: 24),
                const SizedBox(height: 30),
                _sprintCard(),
                const SizedBox(height: 30),
                _statusCards(),
                const SizedBox(height: 24),
                _attentionSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
        child: Navbar(
          selectedIndex: 0,
          onItemSelected: (index) async {
            if (index == 1) {
              await Navigator.pushNamed(context, AppRoutes.tasks);

              if (!mounted) return;
              await _loadTasks();
            } else if (index == 3) {
              await Navigator.pushNamed(context, AppRoutes.teamProfile);
            }
          },
        ),
      ),
    );
  }

  Widget _welcomeHeader(String formattedDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: TextStyle(color: _muted, fontSize: 16),
              ),
              SizedBox(height: 4),
              Text(
                'Hello, $_userName!',
                style: TextStyle(
                  color: _ink,
                  fontSize: 31,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sprintCard() {
    final completedTasks = _savedTasks
        .where((task) => task.status == 'Done')
        .length;
    final totalTasks = _savedTasks.length;
    final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    final latestDeadline = _savedTasks.isEmpty
        ? null
        : _savedTasks
              .map((task) => task.deadline)
              .reduce(
                (latest, deadline) =>
                    deadline.isAfter(latest) ? deadline : latest,
              );
    final daysLeft = latestDeadline == null ? 0 : _daysUntil(latestDeadline);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F2), Color(0xFFE4E8E6)],
          stops: [0.0, 0.52, 1.0],
        ),
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFD3DAD6)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-1, .15),
                      end: const Alignment(1, -.1),
                      colors: [
                        Colors.transparent,
                        const Color(0xFF9CA9A4).withValues(alpha: .12),
                        Colors.transparent,
                        const Color(0xFFB7C1BD).withValues(alpha: .1),
                        Colors.transparent,
                      ],
                      stops: const [0, .28, .43, .68, 1],
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: const Alignment(-.4, -1),
                      end: const Alignment(.55, 1),
                      colors: [
                        Colors.transparent,
                        const Color(0xFF7F8E87).withValues(alpha: .1),
                        Colors.transparent,
                      ],
                      stops: const [.2, .48, .75],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'CURRENT SPRINT',
                          style: TextStyle(color: _muted, fontSize: 14),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E7E3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$daysLeft ${daysLeft == 1 ? 'day' : 'days'} left',
                          style: TextStyle(color: _ink, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _savedTasks.isEmpty ? 'No tasks yet' : 'Task overview',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${(progress * 100).round()}%',
                              style: TextStyle(
                                color: _ink,
                                fontSize: 48,
                                fontWeight: FontWeight.w700,
                                height: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '$completedTasks of $totalTasks tasks completed',
                              style: TextStyle(color: _muted, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      _progressCircle(progress),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Color(0xFFD7E0DB),
                      valueColor: AlwaysStoppedAnimation(Color(0xFF6E9F7D)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressCircle(double progress) {
    return SizedBox(
      width: 74,
      height: 74,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 5,
            backgroundColor: Color(0xFFD7E0DB),
            valueColor: AlwaysStoppedAnimation(Color(0xFF6E9F7D)),
          ),
          Text(
            '${(progress * 100).round()}',
            style: TextStyle(
              color: _ink,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCards() {
    final completedCount = _savedTasks
        .where((task) => task.status == 'Done')
        .length;
    final inProgressCount = _savedTasks
        .where((task) => task.status == 'In progress')
        .length;
    final overdueCount = _savedTasks
        .where((task) => task.status != 'Done' && _isOverdue(task.deadline))
        .length;

    return Row(
      children: [
        _statusCard('$completedCount', 'Completed', const Color(0xFF65BE66)),
        const SizedBox(width: 12),
        _statusCard('$inProgressCount', 'At risk', const Color(0xFFE4AC20)),
        const SizedBox(width: 12),
        _statusCard('$overdueCount', 'Overdue', const Color(0xFFD94B40)),
      ],
    );
  }

  bool _isOverdue(DateTime deadline) {
    return DateUtils.dateOnly(deadline)
        .isBefore(DateUtils.dateOnly(DateTime.now()));
  }

  int _daysUntil(DateTime deadline) {
    final days = DateUtils.dateOnly(deadline)
        .difference(DateUtils.dateOnly(DateTime.now()))
        .inDays;
    return days < 0 ? 0 : days;
  }

  Widget _statusCard(String number, String label, Color dotColor) {
    return Expanded(
      child: Container(
        height: 98,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E4DE)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 1,
                  height: 1,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  number,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(label, style: const TextStyle(color: _muted, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _attentionSection() {
    final visibleTasks = [..._savedTasks]
      ..sort((first, second) => first.deadline.compareTo(second.deadline));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Working On',
                style: TextStyle(
                  color: _ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.tasks);
              },
              child: const Text(
                'See all',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_savedTasks.isEmpty)
          const Text(
            'No saved tasks yet.',
            style: TextStyle(color: _muted, fontSize: 16),
          )
        else
          ...visibleTasks
              .take(3)
              .map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _taskCard(
                    status: task.status,
                    statusColor: _statusColor(task.status),
                    title: task.name,
                    details:
                        '${task.priority} priority · Due ${DateFormat('MMM d').format(task.deadline)}',
                    avatars: task.assignees
                        .map(
                          (name) => _Avatar(
                            name
                                .substring(0, name.length >= 2 ? 2 : 1)
                                .toUpperCase(),
                            const Color(0xFFA9DEC9),
                          ),
                        )
                        .toList(),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.taskDetails,
                        arguments: task,
                      );
                      if (mounted) await _loadTasks();
                    },
                    onMore: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.editTask,
                        arguments: task,
                      );
                      if (mounted) await _loadTasks();
                    },
                  ),
                ),
              ),
      ],
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Done':
        return const Color(0xFF65BE66);
      case 'In progress':
        return const Color(0xFFE4AC20);
      default:
        return const Color(0xFF77827D);
    }
  }

  Widget _taskCard({
    required String status,
    required Color statusColor,
    required String title,
    required String details,
    required List<_Avatar> avatars,
    VoidCallback? onTap,
    VoidCallback? onMore,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E4DE)),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor.withValues(alpha: .95),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  tooltip: 'Task actions',
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.more_horiz, color: _muted),
                  onSelected: (action) {
                    if (action == 'edit') onMore?.call();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit task'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(
                color: _ink,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(details, style: const TextStyle(color: _muted, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 70,
                  height: 38,
                  child: Stack(
                    children: [
                      for (var i = 0; i < avatars.length; i++)
                        Positioned(left: i * 28, child: _avatar(avatars[i])),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: _muted, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(_Avatar avatar) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: avatar.color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        avatar.initials,
        style: const TextStyle(
          color: _ink,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DashboardScrollBehavior extends MaterialScrollBehavior {
  const _DashboardScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

class _Avatar {
  final String initials;
  final Color color;

  const _Avatar(this.initials, this.color);
}
