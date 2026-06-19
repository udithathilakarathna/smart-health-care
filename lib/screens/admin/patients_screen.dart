import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  String _stringValue(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value == null || value.toString().trim().isEmpty) {
      return '-';
    }
    return value.toString();
  }

  String _bookingLabel(Map<String, dynamic> data) {
    final bookingNumber = data['bookingNumber'];
    if (bookingNumber != null && bookingNumber.toString().trim().isNotEmpty) {
      return bookingNumber.toString();
    }

    final tokenNumber = data['tokenNumber'];
    if (tokenNumber != null && tokenNumber.toString().trim().isNotEmpty) {
      return 'Token ${tokenNumber.toString()}';
    }

    return '-';
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('booked')) {
      return const Color(0xFF1C7C54);
    }
    if (normalized.contains('cancel')) {
      return Colors.red.shade700;
    }
    return const Color(0xFF1565C0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        title: const Text('Patients'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('status', isEqualTo: 'Booked')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No patient bookings found'));
          }

          final patients = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final appointment = patients[index];
              final data = appointment.data();
              final patientName = _stringValue(data, 'patientName');
              final doctorName = _stringValue(data, 'doctorName');
              final specialization = _stringValue(data, 'specialization');
              final sessionDate = _stringValue(data, 'sessionDate');
              final sessionTime = _stringValue(data, 'sessionTime');
              final roomNumber = _stringValue(data, 'roomNumber');
              final channelFee = _stringValue(data, 'channelFee');
              final status = _stringValue(data, 'status');
              final bookingLabel = _bookingLabel(data);
              final tokenNumber = _stringValue(data, 'tokenNumber');

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade200, blurRadius: 10),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(
                            0xFF1565C0,
                          ).withValues(alpha: 0.12),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                patientName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Booking #$bookingLabel',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(status),
                          backgroundColor: _statusColor(
                            status,
                          ).withValues(alpha: 0.12),
                          labelStyle: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _InfoRow(label: 'Doctor', value: 'Dr. $doctorName'),
                    _InfoRow(label: 'Specialization', value: specialization),
                    _InfoRow(label: 'Token', value: tokenNumber),
                    _InfoRow(label: 'Date', value: sessionDate),
                    _InfoRow(label: 'Time', value: sessionTime),
                    _InfoRow(label: 'Room', value: roomNumber),
                    _InfoRow(label: 'Fee', value: 'Rs. $channelFee'),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(patientName),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _DetailItem(
                                        label: 'Booking ID',
                                        value: bookingLabel,
                                      ),
                                      _DetailItem(
                                        label: 'Doctor',
                                        value: 'Dr. $doctorName',
                                      ),
                                      _DetailItem(
                                        label: 'Specialization',
                                        value: specialization,
                                      ),
                                      _DetailItem(
                                        label: 'Token',
                                        value: tokenNumber,
                                      ),
                                      _DetailItem(
                                        label: 'Date',
                                        value: sessionDate,
                                      ),
                                      _DetailItem(
                                        label: 'Time',
                                        value: sessionTime,
                                      ),
                                      _DetailItem(
                                        label: 'Room',
                                        value: roomNumber,
                                      ),
                                      _DetailItem(
                                        label: 'Fee',
                                        value: 'Rs. $channelFee',
                                      ),
                                      _DetailItem(
                                        label: 'Status',
                                        value: status,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.visibility_outlined),
                        label: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
      padding: const EdgeInsets.only(bottom: 8),
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

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
