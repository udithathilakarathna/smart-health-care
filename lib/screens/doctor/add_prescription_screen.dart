import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor_dashboard_screen.dart';
import '../../widgets/smart_back_button.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({super.key, required this.appointment});

  final QueryDocumentSnapshot<Map<String, dynamic>> appointment;

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController medicinesController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isSaving = false;

  Future<void> _savePrescription() async {
    if (diagnosisController.text.trim().isEmpty ||
        medicinesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diagnosis and medicines are required')),
      );
      return;
    }

    final doctorUid = FirebaseAuth.instance.currentUser!.uid;
    final doctorDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(doctorUid)
        .get();
    final doctorName = doctorDoc.data()?['fullName'] as String? ?? 'Doctor';

    final data = widget.appointment.data();

    setState(() {
      isSaving = true;
    });

    try {
      await FirebaseFirestore.instance.collection('prescriptions').add({
        'appointmentId': widget.appointment.id,
        'sessionId': data['sessionId'],
        'doctorId': doctorUid,
        'doctorName': doctorName,
        'patientId': data['patientId'],
        'patientName': data['patientName'],
        'tokenNumber': data['tokenNumber'],
        'sessionDate': data['sessionDate'],
        'sessionTime': data['sessionTime'],
        'diagnosis': diagnosisController.text.trim(),
        'symptoms': symptomsController.text.trim(),
        'medicines': medicinesController.text.trim(),
        'notes': notesController.text.trim(),
        'pharmacistStatus': 'Pending',
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointment.id)
          .update({
            'status': 'Completed',
            'prescriptionAdded': true,
            'completedAt': Timestamp.now(),
          });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prescription saved successfully')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.appointment.data();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const DoctorDashboardScreen(),
        ),
        title: Text('Prescription - ${data['patientName'] ?? 'Patient'}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient: ${data['patientName'] ?? '-'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('Token: ${data['tokenNumber'] ?? '-'}'),
                  Text('Date: ${data['sessionDate'] ?? '-'}'),
                  Text('Time: ${data['sessionTime'] ?? '-'}'),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _buildField(label: 'Diagnosis', controller: diagnosisController),
            _buildField(
              label: 'Symptoms',
              controller: symptomsController,
              maxLines: 3,
            ),
            _buildField(
              label: 'Medicines',
              controller: medicinesController,
              maxLines: 4,
            ),
            _buildField(
              label: 'Doctor Notes',
              controller: notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isSaving ? null : _savePrescription,
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Prescription'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
