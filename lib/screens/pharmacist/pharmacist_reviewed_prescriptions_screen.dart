import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'pharmacist_prescription_detail_screen.dart';

class PharmacistReviewedPrescriptionsScreen extends StatelessWidget {
  const PharmacistReviewedPrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
        title: const Text('Reviewed Prescriptions'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('prescriptions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Unable to load reviewed prescriptions right now.'),
              ),
            );
          }

          final reviewedPrescriptions = (snapshot.data?.docs ?? [])
              .where(
                (doc) =>
                    (doc.data()['pharmacistStatus'] as String? ?? 'Pending') ==
                    'Reviewed',
              )
              .toList();

          if (reviewedPrescriptions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('No reviewed prescriptions yet'),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0B6E4F), Color(0xFF1AA37A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reviewed Queue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All prescriptions already reviewed by the pharmacist.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...reviewedPrescriptions.map((prescription) {
                final data = prescription.data();

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFF0B6E4F),
                      child: Icon(Icons.verified, color: Colors.white),
                    ),
                    title: Text(
                      data['patientName'] as String? ?? 'Patient',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${data['doctorName'] ?? 'Doctor'} • ${data['diagnosis'] ?? 'No diagnosis'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PharmacistPrescriptionDetailScreen(
                            prescriptionId: prescription.id,
                            prescriptionData: data,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
