import 'package:flutter/material.dart';

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
            const Text(
              'TODAY · 2 TASKS',
              style: TextStyle(color: Color(0xFF7C8883), fontSize: 12),
            ),
            const SizedBox(height: 12),
            TaskCard(
              title: 'Finalize onboarding flow',
              details: 'Design · Due 4:00 PM',
              status: 'At risk',
              statusColor: AppColors.atRisk,
              avatars: const [
                TaskAvatar('AM', AppColors.avatarMint),
                TaskAvatar('JK', AppColors.avatarGold),
              ],
              onTap: () => Navigator.pushNamed(context, AppRoutes.taskDetails),
            ),
            const TaskCard(
              title: 'Reciew empty states',
              details: 'Design · Due 6:00 PM',
              status: 'On track',
              statusColor: AppColors.onTrack,
              avatars: [
                TaskAvatar('AM', AppColors.avatarMint),
                TaskAvatar('JK', AppColors.avatarGold),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'EARLIER',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            const TaskCard(
              title: 'Finalize onboarding flow',
              details: 'Design · Due 4:00 PM',
              status: 'Overdue',
              statusColor: AppColors.overdue,
              avatars: [
                TaskAvatar('AM', AppColors.avatarMint),
                TaskAvatar('JK', AppColors.avatarGold),
              ],
            ),
            TaskCard(
              title: 'Prepare Release Notes',
              details: 'Product · Completed 2 days ago',
              status: 'Completed',
              statusColor: AppColors.completed,
              avatars: [
                TaskAvatar('AM', AppColors.avatarMint),
                TaskAvatar('JK', AppColors.avatarGold),
              ],
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
