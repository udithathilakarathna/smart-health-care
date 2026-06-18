import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor_dashboard_screen.dart';
import 'doctor_appointment_utils.dart';
import 'patient_details_screen.dart';
import '../../widgets/smart_back_button.dart';

class TodayPatientsScreen extends StatelessWidget {
  const TodayPatientsScreen({super.key});

  Future<String> _doctorName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return snapshot.data()?['fullName'] as String? ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const DoctorDashboardScreen(),
        ),
        title: const Text('Today Patients'),
      ),
      body: FutureBuilder<String>(
        future: _doctorName(),
        builder: (context, doctorSnapshot) {
          if (!doctorSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctorName = doctorSnapshot.data!;
          final today = DateTime.now();

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('appointments')
                .where('doctorName', isEqualTo: doctorName)
                .where('status', isEqualTo: 'Booked')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final appointments = snapshot.data!.docs.where((doc) {
                final appointmentDate = parseSessionDate(
                  doc.data()['sessionDate'] as String?,
                );
                return appointmentDate != null &&
                    isSameDay(appointmentDate, today);
              }).toList();

              appointments.sort((first, second) {
                final firstToken =
                    (first.data()['tokenNumber'] as num?)?.toInt() ?? 0;
                final secondToken =
                    (second.data()['tokenNumber'] as num?)?.toInt() ?? 0;
                return firstToken.compareTo(secondToken);
              });

              if (appointments.isEmpty) {
                return const Center(
                  child: Text('No patients scheduled for today'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final appointment = appointments[index];
                  final data = appointment.data();
                  final token =
                      (data['tokenNumber'] as num?)?.toInt() ?? index + 1;
                  final patientName =
                      data['patientName'] as String? ?? 'Patient';

                  return _PatientCard(
                    token: token,
                    name: patientName,
                    subtitle:
                        '${data['sessionTime'] ?? ''} | Room ${data['roomNumber'] ?? ''}',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PatientDetailsScreen(appointment: appointment),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.token,
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  final int token;
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF1565C0),
          child: Text(
            token.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
