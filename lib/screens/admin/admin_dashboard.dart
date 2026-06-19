import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import 'bookings_screen.dart';
import 'doctor_screen.dart';
import 'patients_screen.dart';
import 'session_screen.dart';
import 'staff_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          'Smart Healthcare',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF1565C0),
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Admin Panel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Hospital Management',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            buildDrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () => Navigator.pop(context),
            ),
            buildDrawerItem(
              icon: Icons.local_hospital,
              title: 'Doctors',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DoctorsScreen()),
                );
              },
            ),
            buildDrawerItem(
              icon: Icons.people,
              title: 'Staff Members',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StaffScreen()),
                );
              },
            ),
            buildDrawerItem(
              icon: Icons.schedule,
              title: 'Sessions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SessionScreen()),
                );
              },
            ),
            buildDrawerItem(
              icon: Icons.calendar_today,
              title: 'Bookings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingsScreen()),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            buildDrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red,
              onTap: () async {
                final confirmLogout = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmLogout == true) {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1100;
            final isMedium = constraints.maxWidth >= 700;
            final cardWidth = isWide
                ? (constraints.maxWidth - 36) / 4
                : isMedium
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;
            final actionWidth = isWide
                ? (constraints.maxWidth - 24) / 3
                : isMedium
                ? (constraints.maxWidth - 12) / 2
                : constraints.maxWidth;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: Color(0xFF1565C0),
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning 👋',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Admin Dashboard',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'A clean overview of doctors, staff, sessions and bookings.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeader(
                  title: 'Hospital Overview',
                  subtitle: 'Tap a card to open full details',
                ),
                const SizedBox(height: 12),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('role', isEqualTo: 'doctor')
                      .snapshots(),
                  builder: (context, doctorSnapshot) {
                    final doctorCount = doctorSnapshot.data?.docs.length ?? 0;

                    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'staff')
                          .snapshots(),
                      builder: (context, staffSnapshot) {
                        final staffCount = staffSnapshot.data?.docs.length ?? 0;

                        return StreamBuilder<
                          QuerySnapshot<Map<String, dynamic>>
                        >(
                          stream: FirebaseFirestore.instance
                              .collection('sessions')
                              .snapshots(),
                          builder: (context, sessionSnapshot) {
                            final sessionCount =
                                sessionSnapshot.data?.docs.length ?? 0;

                            return StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>
                            >(
                              stream: FirebaseFirestore.instance
                                  .collection('appointments')
                                  .snapshots(),
                              builder: (context, bookingSnapshot) {
                                final bookingCount =
                                    bookingSnapshot.data?.docs.length ?? 0;

                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    DashboardCard(
                                      width: cardWidth,
                                      title: 'Doctors',
                                      value: doctorCount.toString(),
                                      icon: Icons.local_hospital,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const DoctorsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    DashboardCard(
                                      width: cardWidth,
                                      title: 'Staff',
                                      value: staffCount.toString(),
                                      icon: Icons.people,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const StaffScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    DashboardCard(
                                      width: cardWidth,
                                      title: 'Sessions',
                                      value: sessionCount.toString(),
                                      icon: Icons.schedule,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SessionScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    DashboardCard(
                                      width: cardWidth,
                                      title: 'Bookings',
                                      value: bookingCount.toString(),
                                      icon: Icons.person,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const BookingsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                const _SectionHeader(
                  title: 'Quick Actions',
                  subtitle: 'Fast access to common admin tasks',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    QuickActionCard(
                      width: actionWidth,
                      icon: Icons.add,
                      title: 'Add Doctor',
                      subtitle: 'Create a new doctor profile',
                      accent: const Color(0xFF1565C0),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DoctorsScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionCard(
                      width: actionWidth,
                      icon: Icons.person_add,
                      title: 'Add Staff',
                      subtitle: 'Register staff members',
                      accent: const Color(0xFF1C7C54),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StaffScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionCard(
                      width: actionWidth,
                      icon: Icons.schedule,
                      title: 'Create Session',
                      subtitle: 'Open doctor session slots',
                      accent: const Color(0xFF8E6C00),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SessionScreen(),
                          ),
                        );
                      },
                    ),
                    QuickActionCard(
                      width: actionWidth,
                      icon: Icons.assignment,
                      title: 'Bookings',
                      subtitle: 'Review all patient bookings',
                      accent: const Color(0xFF5E5E5E),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BookingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color color = Colors.black87,
}) {
  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(title, style: TextStyle(color: color)),
    onTap: onTap,
  );
}

Widget buildActionButton({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1565C0),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    );
  }
}

class QuickActionCard extends StatelessWidget {
  const QuickActionCard({
    super.key,
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: accent.withValues(alpha: 0.10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final double width;
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1565C0).withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFF1565C0)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
