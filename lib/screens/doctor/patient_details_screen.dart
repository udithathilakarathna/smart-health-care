import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'doctor_dashboard_screen.dart';
import 'add_prescription_screen.dart';
import '../../widgets/smart_back_button.dart';

class PatientDetailsScreen extends StatelessWidget {
  const PatientDetailsScreen({super.key, required this.appointment});

  final QueryDocumentSnapshot<Map<String, dynamic>> appointment;

  @override
  Widget build(BuildContext context) {
    final data = appointment.data();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const DoctorDashboardScreen(),
        ),
        title: const Text('Patient Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['patientName'] as String? ?? 'Patient',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Token ${data['tokenNumber'] ?? '-'}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _InfoCard(
              label: 'Date',
              value: data['sessionDate'] as String? ?? '-',
            ),
            _InfoCard(
              label: 'Time',
              value: data['sessionTime'] as String? ?? '-',
            ),
            _InfoCard(
              label: 'Room',
              value: data['roomNumber'] as String? ?? '-',
            ),
            _InfoCard(label: 'Status', value: data['status'] as String? ?? '-'),
            _InfoCard(label: 'Fee', value: 'Rs. ${data['channelFee'] ?? '-'}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddPrescriptionScreen(appointment: appointment),
                    ),
                  );
                },
                icon: const Icon(Icons.medication),
                label: const Text('Add Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Flexible(child: Text(value, textAlign: TextAlign.end)),
        ],
      ),
    );
  }
}
