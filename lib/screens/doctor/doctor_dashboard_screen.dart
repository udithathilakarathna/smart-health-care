import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor_prescriptions_screen.dart';
import 'today_patients_screen.dart';
import 'upcoming_patients_screen.dart';

class DoctorDashboardScreen extends StatelessWidget {
  const DoctorDashboardScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _doctorProfile() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        title: const Text('Smart Care Doctor'),
        centerTitle: false,
      ),
      drawer: _DoctorMenu(doctorProfile: _doctorProfile()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final showSidebar = constraints.maxWidth >= 980;

          return Row(
            children: [
              if (showSidebar)
                SizedBox(
                  width: 300,
                  child: _DoctorMenu(doctorProfile: _doctorProfile()),
                ),
              Expanded(
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: _doctorProfile(),
                  builder: (context, snapshot) {
                    final doctorData = snapshot.data?.data();
                    final doctorName =
                        doctorData?['fullName'] as String? ?? 'Doctor';
                    final specialization =
                        doctorData?['specialization'] as String? ?? 'Doctor';

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _HeroBanner(
                            doctorName: doctorName,
                            specialization: specialization,
                          ),
                          const SizedBox(height: 16),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('appointments')
                                .where('doctorName', isEqualTo: doctorName)
                                .where('status', isEqualTo: 'Booked')
                                .snapshots(),
                            builder: (context, appointmentSnapshot) {
                              final appointments =
                                  appointmentSnapshot.data?.docs ?? [];
                              final today = DateTime.now();

                              final todayCount = appointments.where((doc) {
                                final sessionDate =
                                    doc.data()['sessionDate'] as String?;
                                return sessionDate != null &&
                                    sessionDate ==
                                        '${today.day}/${today.month}/${today.year}';
                              }).length;

                              final upcomingCount = appointments.where((doc) {
                                final sessionDate =
                                    doc.data()['sessionDate'] as String?;
                                if (sessionDate == null) {
                                  return false;
                                }
                                final parts = sessionDate.split('/');
                                if (parts.length != 3) {
                                  return false;
                                }
                                final day = int.tryParse(parts[0]) ?? 0;
                                final month = int.tryParse(parts[1]) ?? 0;
                                final year = int.tryParse(parts[2]) ?? 0;
                                final parsed = DateTime(year, month, day);
                                return parsed.isAfter(today) &&
                                    !(parsed.year == today.year &&
                                        parsed.month == today.month &&
                                        parsed.day == today.day);
                              }).length;

                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _StatCard(
                                          label: 'Today Queue',
                                          value: todayCount.toString(),
                                          icon: Icons.today,
                                          tint: const Color(0xFF1565C0),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _StatCard(
                                          label: 'Upcoming',
                                          value: upcomingCount.toString(),
                                          icon: Icons.schedule,
                                          tint: const Color(0xFF1C7C54),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child:
                                            StreamBuilder<
                                              QuerySnapshot<
                                                Map<String, dynamic>
                                              >
                                            >(
                                              stream: FirebaseFirestore.instance
                                                  .collection('prescriptions')
                                                  .where(
                                                    'doctorName',
                                                    isEqualTo: doctorName,
                                                  )
                                                  .snapshots(),
                                              builder:
                                                  (
                                                    context,
                                                    prescriptionSnapshot,
                                                  ) {
                                                    final count =
                                                        prescriptionSnapshot
                                                            .data
                                                            ?.docs
                                                            .length ??
                                                        0;
                                                    return _StatCard(
                                                      label: 'Prescriptions',
                                                      value: count.toString(),
                                                      icon: Icons.medication,
                                                      tint: const Color(
                                                        0xFF8E6C00,
                                                      ),
                                                    );
                                                  },
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  GridView.count(
                                    crossAxisCount: constraints.maxWidth >= 1100
                                        ? 4
                                        : 2,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.35,
                                    children: [
                                      _DashboardCard(
                                        title: 'Today Patients',
                                        subtitle: 'Token-wise queue',
                                        icon: Icons.today,
                                        tint: const Color(0xFF1565C0),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const TodayPatientsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      _DashboardCard(
                                        title: 'Upcoming Patients',
                                        subtitle: 'Next sessions',
                                        icon: Icons.schedule,
                                        tint: const Color(0xFF1C7C54),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const UpcomingPatientsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      _DashboardCard(
                                        title: 'Prescriptions',
                                        subtitle: 'Saved treatment plans',
                                        icon: Icons.medication,
                                        tint: const Color(0xFF8E6C00),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const DoctorPrescriptionsScreen(),
                                            ),
                                          );
                                        },
                                      ),
                                      _DashboardCard(
                                        title: 'Refresh',
                                        subtitle: 'Reload dashboard',
                                        icon: Icons.refresh,
                                        tint: const Color(0xFF5E5E5E),
                                        onTap: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const DoctorDashboardScreen(),
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
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DoctorMenu extends StatelessWidget {
  const _DoctorMenu({required this.doctorProfile});

  final Future<DocumentSnapshot<Map<String, dynamic>>> doctorProfile;

  void _openPage(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F4C81), Color(0xFF0A2E5D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: doctorProfile,
                builder: (context, snapshot) {
                  final doctorData = snapshot.data?.data();
                  final doctorName =
                      doctorData?['fullName'] as String? ?? 'Doctor';
                  final specialization =
                      doctorData?['specialization'] as String? ?? 'Smart Care';

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.local_hospital,
                            color: Color(0xFF0F4C81),
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          doctorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialization,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Divider(color: Colors.white24, height: 1),
              _MenuTile(
                icon: Icons.dashboard,
                label: 'Dashboard',
                selected: true,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DoctorDashboardScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
              _MenuTile(
                icon: Icons.today,
                label: 'Today Patients',
                onTap: () => _openPage(context, const TodayPatientsScreen()),
              ),
              _MenuTile(
                icon: Icons.schedule,
                label: 'Upcoming Patients',
                onTap: () => _openPage(context, const UpcomingPatientsScreen()),
              ),
              _MenuTile(
                icon: Icons.medication,
                label: 'Prescriptions',
                onTap: () =>
                    _openPage(context, const DoctorPrescriptionsScreen()),
              ),
              const Spacer(),
              const Divider(color: Colors.white24, height: 1),
              _MenuTile(
                icon: Icons.logout,
                label: 'Logout',
                iconColor: Colors.redAccent,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) {
                    return;
                  }
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? Colors.white.withValues(alpha: 0.10)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor ?? Colors.white),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.doctorName, required this.specialization});

  final String doctorName;
  final String specialization;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF1D9BF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4C81).withValues(alpha: 0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.health_and_safety,
              color: Color(0xFF0F4C81),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, $doctorName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  specialization,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Token queue, prescriptions, and session control in one place.',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tint,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color tint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 28, color: tint),
              ),
              const Spacer(),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tint.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: tint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: tint),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: tint,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
