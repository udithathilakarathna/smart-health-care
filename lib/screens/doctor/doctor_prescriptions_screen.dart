import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor_dashboard_screen.dart';
import '../../widgets/smart_back_button.dart';

class DoctorPrescriptionsScreen extends StatelessWidget {
  const DoctorPrescriptionsScreen({super.key});

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
        title: const Text('Prescriptions'),
      ),
      body: FutureBuilder<String>(
        future: _doctorName(),
        builder: (context, doctorSnapshot) {
          if (!doctorSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final doctorName = doctorSnapshot.data!;

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('prescriptions')
                .where('doctorName', isEqualTo: doctorName)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No prescriptions found'));
              }

              final prescriptions = snapshot.data!.docs;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = prescriptions[index].data();

                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prescription['patientName'] as String? ?? 'Patient',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text('Token: ${prescription['tokenNumber'] ?? '-'}'),
                          Text(
                            'Diagnosis: ${prescription['diagnosis'] ?? '-'}',
                          ),
                          Text(
                            'Medicines: ${prescription['medicines'] ?? '-'}',
                          ),
                          if ((prescription['notes'] as String?)?.isNotEmpty ??
                              false) ...[
                            const SizedBox(height: 6),
                            Text('Notes: ${prescription['notes']}'),
                          ],
                        ],
                      ),
                    ),
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
