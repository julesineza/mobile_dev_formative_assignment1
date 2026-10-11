import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../models/task.dart';
import '../services/auth_storage.dart';
import '../services/task_storage.dart';
import '../theme/app_colors.dart';
import '../widgets/navabar.dart';

class TeamProfileScreen extends StatefulWidget {
  const TeamProfileScreen({super.key});

  @override
  State<TeamProfileScreen> createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends State<TeamProfileScreen> {
  int currentScreen = 3;
  final _authStorage = AuthStorage();
  final _taskStorage = TaskStorage();
  String _userName = 'Your profile';
  List<Task> _tasks = [];
  List<_TeamMember> _members = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userName = await _authStorage.loadName();
    final tasks = await _taskStorage.loadTasks();
    final assignees = await _taskStorage.loadAssignees();
    final names = <String>{if (userName != null) userName, ...assignees};
    if (!mounted) return;
    setState(() {
      _userName = userName ?? 'Your profile';
      _tasks = tasks;
      _members = names
          .map(
            (name) => _TeamMember(
              initials: _initials(name),
              name: name,
              role: name == userName ? 'Product designer' : 'Team member',
              color: name == userName
                  ? AppColors.avatarMint
                  : AppColors.avatarGold,
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Workspace',
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  color: AppColors.muted,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your team',
                      style: TextStyle(
                        fontFamily: '.SF Pro Display',
                        color: AppColors.ink,
                        fontSize: 31,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _profileCard(),
              const SizedBox(height: 38),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Team members',
                      style: TextStyle(
                        fontFamily: '.SF Pro Display',
                        color: AppColors.ink,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    '${_members.length} people',
                    style: const TextStyle(
                      fontFamily: '.SF Pro Text',
                      color: AppColors.muted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ..._members.map(_memberTile),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await _authStorage.signOut();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
                    }
                  },
                  child: const Text(
                    'Switch user',
                    style: TextStyle(
                      fontFamily: '.SF Pro Text',
                      color: AppColors.overdue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: currentScreen,
        onItemSelected: _selectNavigation,
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _avatar(_initials(_userName), AppColors.avatarMint, 72),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: '.SF Pro Display',
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Product designer · Kigali',
                      style: TextStyle(
                        fontFamily: '.SF Pro Text',
                        color: AppColors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Metric('${_tasks.length}', 'Tasks'),
              _Metric('${_onTimePercentage()}%', 'On time'),
              const _Metric('0', 'Projects'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _memberTile(_TeamMember member) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE0E4DE))),
      ),
      child: Row(
        children: [
          _avatar(member.initials, member.color, 52),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: const TextStyle(
                    fontFamily: '.SF Pro Display',
                    color: AppColors.ink,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  member.role,
                  style: const TextStyle(
                    fontFamily: '.SF Pro Text',
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.circle, size: 11, color: AppColors.completed),
        ],
      ),
    );
  }

  Widget _avatar(String initials, Color color, double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        initials,
        style: TextStyle(
          fontFamily: '.SF Pro Text',
          color: AppColors.ink,
          fontSize: size * .22,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _selectNavigation(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.tasks);
    }
  }

  int _onTimePercentage() {
    if (_tasks.isEmpty) return 0;
    final onTime = _tasks
        .where(
          (task) =>
              !DateUtils.dateOnly(task.deadline)
                  .isBefore(DateUtils.dateOnly(DateTime.now())),
        )
        .length;
    return (onTime / _tasks.length * 100).round();
  }

  static String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) {
      return words.first
          .substring(0, words.first.length.clamp(1, 2))
          .toUpperCase();
    }
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

class _TeamMember {
  final String initials;
  final String name;
  final String role;
  final Color color;

  const _TeamMember({
    required this.initials,
    required this.name,
    required this.role,
    required this.color,
  });
}

class _Metric extends StatelessWidget {
  final String value;
  final String label;

  const _Metric(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: '.SF Pro Display',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: '.SF Pro Text',
            color: AppColors.muted,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
