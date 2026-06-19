import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'patent_dashboard.dart';
import '../../widgets/smart_back_button.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  Future<DocumentSnapshot<Map<String, dynamic>>> _profileDoc() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) {
      return 'P';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final patientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F4C81),
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const PatientDashboard(),
        ),
        title: const Text('My Profile'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: _profileDoc(),
        builder: (context, profileSnapshot) {
          if (!profileSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = profileSnapshot.data!.data() ?? {};
          final fullName = data['fullName'] as String? ?? 'Patient';
          final email = data['email'] as String? ?? '-';
          final phone = data['phone'] as String? ?? '-';
          final nic = data['nic'] as String? ?? '-';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
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
                      color: const Color(0xFF0F4C81).withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white,
                      child: Text(
                        _initials(fullName),
                        style: const TextStyle(
                          color: Color(0xFF0F4C81),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('appointments')
                    .where('patientId', isEqualTo: patientId)
                    .snapshots(),
                builder: (context, appointmentSnapshot) {
                  final appointmentCount =
                      appointmentSnapshot.data?.docs.length ?? 0;

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('prescriptions')
                        .where('patientId', isEqualTo: patientId)
                        .snapshots(),
                    builder: (context, prescriptionSnapshot) {
                      final prescriptionCount =
                          prescriptionSnapshot.data?.docs.length ?? 0;

                      return Row(
                        children: [
                          Expanded(
                            child: _ProfileStatCard(
                              label: 'Appointments',
                              value: appointmentCount.toString(),
                              icon: Icons.calendar_month,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ProfileStatCard(
                              label: 'Prescriptions',
                              value: prescriptionCount.toString(),
                              icon: Icons.medication,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              _InfoSection(
                title: 'Personal Information',
                children: [
                  _InfoRow(label: 'Full Name', value: fullName),
                  _InfoRow(label: 'NIC', value: nic),
                  _InfoRow(label: 'Phone', value: phone),
                  _InfoRow(label: 'Email', value: email),
                  _InfoRow(
                    label: 'Role',
                    value: data['role'] as String? ?? 'patient',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProfileStatCard extends StatelessWidget {
  const _ProfileStatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0F4C81)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
