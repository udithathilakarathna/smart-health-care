import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/login_screen.dart';
import 'appointment_history_screen.dart';
import 'my_prescriptions_screen.dart';
import 'patient_profile_screen.dart';
import 'view_doctors_screen.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _profileDoc() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Patient Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 26),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: _profileDoc(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data() ?? {};
                  final name = data['fullName'] as String? ?? 'Patient';
                  final initials = _initials(name);

                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white,
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Patient Panel',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                },
              ),
            ),
            _DrawerItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              onTap: () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.local_hospital,
              title: 'Doctors',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewDoctorsScreen()),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.calendar_month,
              title: 'Appointments',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentHistoryScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.receipt_long,
              title: 'My Prescriptions',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyPrescriptionsScreen(),
                  ),
                );
              },
            ),
            _DrawerItem(
              icon: Icons.person,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PatientProfileScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            _DrawerItem(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red,
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _profileDoc(),
        builder: (context, profileSnapshot) {
          final data = profileSnapshot.data?.data() ?? {};
          final fullName = data['fullName'] as String? ?? 'Patient';
          final patientId = FirebaseAuth.instance.currentUser!.uid;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final tileWidth = isWide
                    ? (constraints.maxWidth - 12) / 2
                    : constraints.maxWidth;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F4C81), Color(0xFF1D9BF0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF0F4C81,
                            ).withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
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
                                  'Hello, $fullName',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Book appointments, track prescriptions, and manage your profile in one place.',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionHeader(
                      title: 'Your Health Hub',
                      subtitle: 'Tap a card to open the related page',
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('appointments')
                          .where('patientId', isEqualTo: patientId)
                          .get(),
                      builder: (context, appointmentSnapshot) {
                        final appointmentCount =
                            appointmentSnapshot.data?.docs.length ?? 0;

                        return FutureBuilder<
                          QuerySnapshot<Map<String, dynamic>>
                        >(
                          future: FirebaseFirestore.instance
                              .collection('prescriptions')
                              .where('patientId', isEqualTo: patientId)
                              .get(),
                          builder: (context, prescriptionSnapshot) {
                            final prescriptionCount =
                                prescriptionSnapshot.data?.docs.length ?? 0;

                            return FutureBuilder<
                              QuerySnapshot<Map<String, dynamic>>
                            >(
                              future: FirebaseFirestore.instance
                                  .collection('users')
                                  .where('role', isEqualTo: 'doctor')
                                  .get(),
                              builder: (context, doctorSnapshot) {
                                final doctorCount =
                                    doctorSnapshot.data?.docs.length ?? 0;

                                return Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    _DashboardTile(
                                      width: tileWidth,
                                      icon: Icons.calendar_month,
                                      title: 'My Appointments',
                                      value: appointmentCount.toString(),
                                      subtitle: 'View your bookings',
                                      accent: const Color(0xFF1565C0),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const AppointmentHistoryScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    _DashboardTile(
                                      width: tileWidth,
                                      icon: Icons.receipt_long,
                                      title: 'Prescriptions',
                                      value: prescriptionCount.toString(),
                                      subtitle: 'See doctor prescriptions',
                                      accent: const Color(0xFF1C7C54),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MyPrescriptionsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    _DashboardTile(
                                      width: tileWidth,
                                      icon: Icons.local_hospital,
                                      title: 'Doctors',
                                      value: doctorCount.toString(),
                                      subtitle: 'Find and book doctors',
                                      accent: const Color(0xFF8E6C00),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ViewDoctorsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                    _DashboardTile(
                                      width: tileWidth,
                                      icon: Icons.person,
                                      title: 'Profile',
                                      value: '',
                                      subtitle: 'Open your profile details',
                                      accent: const Color(0xFF5E5E5E),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const PatientProfileScreen(),
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
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'P';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color = Colors.black87,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
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

class _DashboardTile extends StatelessWidget {
  const _DashboardTile({
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final double width;
  final IconData icon;
  final String title;
  final String value;
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
                  width: 46,
                  height: 46,
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
                        value,
                        style: TextStyle(
                          color: accent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
