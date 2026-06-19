import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/smart_back_button.dart';
import 'doctor_dashboard_screen.dart';

class DoctorPrescriptionsScreen extends StatelessWidget {
  const DoctorPrescriptionsScreen({super.key});

  static const Color _primaryBlue = Color(0xFF1565C0);
  static const Color _secondaryBlue = Color(0xFF42A5F5);
  static const Color _backgroundBlue = Color(0xFFF4F8FC);

  Future<String> _doctorName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return snapshot.data()?['fullName'] as String? ?? '';
  }

  Widget _infoChip({
    required IconData icon,
    required String text,
    Color? textColor,
    Color? backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF7FAFF),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3EAF3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor ?? _primaryBlue),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: textColor ?? const Color(0xFF455A64),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [_primaryBlue, _secondaryBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryBlue.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medication_outlined,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No prescriptions found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prescriptions created for your patients will appear here once you save them.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: Colors.blueGrey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF455A64),
        ),
      ),
    );
  }

  Widget _buildSummaryBanner({required int count}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryBlue, _secondaryBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Doctor prescriptions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Review saved treatment plans and patient medication notes in a clean, quick view.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _infoChip(
                  icon: Icons.receipt_long_outlined,
                  text: '$count prescriptions',
                  textColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoChip(
                  icon: Icons.health_and_safety_outlined,
                  text: 'Patient treatment records',
                  textColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Map<String, dynamic> prescription) {
    final patientName = prescription['patientName'] as String? ?? 'Patient';
    final doctorName = prescription['doctorName'] as String? ?? 'Doctor';
    final diagnosis = prescription['diagnosis'] as String? ?? '-';
    final medicines = prescription['medicines'] as String? ?? '-';
    final notes = prescription['notes'] as String? ?? '';
    final tokenNumber = prescription['tokenNumber']?.toString() ?? '-';
    final sessionDate = prescription['sessionDate']?.toString() ?? '-';
    final sessionTime = prescription['sessionTime']?.toString() ?? '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: const Color(0xFFE8EEF7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [_primaryBlue, _secondaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryBlue.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.medication_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        doctorName,
                        style: TextStyle(
                          color: Colors.blueGrey.shade600,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _infoChip(
                            icon: Icons.confirmation_number_outlined,
                            text: 'Token: $tokenNumber',
                          ),
                          _infoChip(
                            icon: Icons.calendar_month_outlined,
                            text: sessionDate,
                          ),
                          _infoChip(
                            icon: Icons.access_time_rounded,
                            text: sessionTime,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionLabel('Diagnosis'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE3EAF3)),
              ),
              child: Text(
                diagnosis,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: Color(0xFF37474F),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _sectionLabel('Medicines'),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE3EAF3)),
              ),
              child: Text(
                medicines,
                style: const TextStyle(
                  fontSize: 13.5,
                  height: 1.45,
                  color: Color(0xFF37474F),
                ),
              ),
            ),
            if (notes.trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              _sectionLabel('Notes'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE3EAF3)),
                ),
                child: Text(
                  notes,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Color(0xFF37474F),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundBlue,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const DoctorDashboardScreen(),
        ),
        title: const Text(
          'Prescriptions',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -0.2),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _secondaryBlue.withValues(alpha: 0.14),
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: -70,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _primaryBlue.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: FutureBuilder<String>(
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

                    final prescriptions = snapshot.data?.docs ?? [];

                    if (prescriptions.isEmpty) {
                      return Column(
                        children: [
                          _buildSummaryBanner(count: 0),
                          const SizedBox(height: 16),
                          Expanded(child: _emptyState()),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _buildSummaryBanner(count: prescriptions.length),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 12),
                            itemCount: prescriptions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              return _buildPrescriptionCard(
                                prescriptions[index].data(),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
