import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({super.key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
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
                  color: AppColors.atRisk.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'AT RISK',
                  style: TextStyle(
                    color: AppColors.atRisk,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Finalize onboarding flow',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Complete the final screens and handoff notes for '
              'the new account onboarding experience.',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
