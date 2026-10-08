import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  int currentScreen = 0;

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
                _searchBar(),
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
          selectedIndex: currentScreen,
          onItemSelected: (index) {
            setState(() {
              currentScreen = index;
            });
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
                'Good morning, Amina',
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

  Widget _searchBar() {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0E9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Row(
        children: [
          Icon(Icons.search, color: _muted, size: 30),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Search projects or tasks',
              style: TextStyle(color: _muted, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sprintCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(23, 32, 27, 1),
        borderRadius: BorderRadius.circular(34),
      ),
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
                  color: const Color(0xFF3B4740),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '8 days left',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Mobile app launch',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '65%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '17 of 26 tasks completed',
                      style: TextStyle(color: _muted, fontSize: 15),
                    ),
                  ],
                ),
              ),
              _progressCircle(),
            ],
          ),
          const SizedBox(height: 28),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: .65,
              minHeight: 8,
              backgroundColor: Color(0xFF3B4740),
              valueColor: AlwaysStoppedAnimation(Color(0xFF9BDC72)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCircle() {
    return SizedBox(
      width: 74,
      height: 74,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const CircularProgressIndicator(
            value: .65,
            strokeWidth: 5,
            backgroundColor: Color(0xFF3B4740),
            valueColor: AlwaysStoppedAnimation(Color(0xFF9BDC72)),
          ),
          const Text(
            '65',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCards() {
    return Row(
      children: [
        _statusCard('17', 'Completed', const Color(0xFF65BE66)),
        const SizedBox(width: 12),
        _statusCard('05', 'At risk', const Color(0xFFE4AC20)),
        const SizedBox(width: 12),
        _statusCard('03', 'Overdue', const Color(0xFFD94B40)),
      ],
    );
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
                  width: 30,
                  height: 30,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Needs attention',
                style: TextStyle(
                  color: _ink,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See all',
                style: TextStyle(color: _muted, fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _taskCard(
          status: 'At risk',
          statusColor: const Color(0xFFE4AC20),
          title: 'Finalize onboarding flow',
          details: 'Design · Due today',
          avatars: const [
            _Avatar('AM', Color(0xFFA9DEC9)),
            _Avatar('JK', Color(0xFFF4CF7D)),
          ],
        ),
        const SizedBox(height: 16),
        _taskCard(
          status: 'Overdue',
          statusColor: const Color(0xFFE85C50),
          title: 'Fix payment API errors',
          details: 'Development · 2 days late',
          avatars: const [_Avatar('JK', Color(0xFFA9DEC9))],
        ),
      ],
    );
  }

  Widget _taskCard({
    required String status,
    required Color statusColor,
    required String title,
    required String details,
    required List<_Avatar> avatars,
  }) {
    return Container(
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
              const Icon(Icons.more_horiz, color: _muted),
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
