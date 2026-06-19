import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/smart_back_button.dart';
import 'pharmacist_dashboard_screen.dart';

class PharmacistPrescriptionDetailScreen extends StatelessWidget {
  const PharmacistPrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
    required this.prescriptionData,
  });

  final String prescriptionId;
  final Map<String, dynamic> prescriptionData;

  Future<void> _markReviewed(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(prescriptionId)
        .update({
          'pharmacistStatus': 'Reviewed',
          'pharmacistReviewedAt': FieldValue.serverTimestamp(),
        });

    if (!context.mounted) {
      return;
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B6E4F),
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const PharmacistDashboardScreen(),
        ),
        title: const Text('Prescription Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0B6E4F), Color(0xFF1AA37A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prescriptionData['patientName'] as String? ?? 'Patient',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Doctor: ${prescriptionData['doctorName'] ?? '-'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  'Token: ${prescriptionData['tokenNumber'] ?? '-'}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DetailCard(
            label: 'Diagnosis',
            value: prescriptionData['diagnosis'] as String? ?? '-',
          ),
          _DetailCard(
            label: 'Symptoms',
            value: prescriptionData['symptoms'] as String? ?? '-',
          ),
          _DetailCard(
            label: 'Medicines',
            value: prescriptionData['medicines'] as String? ?? '-',
          ),
          if ((prescriptionData['notes'] as String?)?.isNotEmpty ?? false)
            _DetailCard(
              label: 'Doctor Notes',
              value: prescriptionData['notes'] as String,
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B6E4F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => _markReviewed(context),
              icon: const Icon(Icons.verified),
              label: const Text('Mark Reviewed'),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
