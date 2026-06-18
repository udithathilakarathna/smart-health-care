import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/smart_back_button.dart';
import 'patent_dashboard.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key, this.initialDoctorName});

  final String? initialDoctorName;

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  String? selectedDoctor;

  @override
  void initState() {
    super.initState();
    selectedDoctor = widget.initialDoctorName;
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _normalizeDoctorLabel(String value) {
    final cleaned = value.trim();
    return cleaned.toLowerCase().startsWith('dr. ')
        ? cleaned.substring(4).trim()
        : cleaned;
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> _fetchDoctorDoc(
    String doctorName,
  ) async {
    final doctorQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('fullName', isEqualTo: _normalizeDoctorLabel(doctorName))
        .limit(1)
        .get();

    if (doctorQuery.docs.isEmpty) {
      return null;
    }

    return doctorQuery.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    final patientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const PatientDashboard(),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('role', isEqualTo: 'doctor')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final doctors = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  initialValue: selectedDoctor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    hintText: 'Select Doctor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: doctors.map((doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor['fullName'],
                      child: Text(doctor['fullName']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDoctor = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('appointments')
                    .where('patientId', isEqualTo: patientId)
                    .snapshots(),
                builder: (context, appointmentSnapshot) {
                  if (!appointmentSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final bookedDoctorIds = appointmentSnapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .map((data) => data['doctorId']?.toString().trim() ?? '')
                      .where((id) => id.isNotEmpty)
                      .toSet();

                  return StreamBuilder<QuerySnapshot>(
                    stream: selectedDoctor == null
                        ? FirebaseFirestore.instance
                              .collection('sessions')
                              .where('status', isEqualTo: 'Available')
                              .snapshots()
                        : FirebaseFirestore.instance
                              .collection('sessions')
                              .where('status', isEqualTo: 'Available')
                              .where('doctorName', isEqualTo: selectedDoctor)
                              .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No Available Sessions'),
                        );
                      }

                      final sessions = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          final bookingCount = session['bookingCount'] as int;
                          final maxAppointments =
                              session['maxAppointments'] as int;
                          final availableSlots = maxAppointments - bookingCount;
                          final doctorName = session['doctorName'].toString();

                          return FutureBuilder<
                            QueryDocumentSnapshot<Map<String, dynamic>>?
                          >(
                            future: _fetchDoctorDoc(doctorName),
                            builder: (context, doctorSnapshot) {
                              if (!doctorSnapshot.hasData) {
                                return const SizedBox(height: 0);
                              }

                              final doctorDoc = doctorSnapshot.data;
                              if (doctorDoc == null) {
                                return const SizedBox.shrink();
                              }

                              final doctorId = doctorDoc.id;
                              final specialization =
                                  doctorDoc['specialization']?.toString() ?? '';
                              final alreadyBooked = bookedDoctorIds.contains(
                                doctorId,
                              );
                              final canBook =
                                  availableSlots > 0 && !alreadyBooked;

                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          child: Icon(Icons.local_hospital),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Dr. $doctorName',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              if (specialization.isNotEmpty)
                                                Text(
                                                  specialization,
                                                  style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              Text(
                                                'Room ${session['roomNumber']}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Text('📅 Date : ${session['sessionDate']}'),
                                    Text('⏰ Time : ${session['sessionTime']}'),
                                    const SizedBox(height: 10),
                                    Text(
                                      '💰 Fee : Rs. ${session['channelFee']}',
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      alreadyBooked
                                          ? 'You already booked this doctor'
                                          : 'Available Slots : $availableSlots / $maxAppointments',
                                      style: TextStyle(
                                        color: alreadyBooked
                                            ? Colors.orange.shade700
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1565C0,
                                          ),
                                        ),
                                        onPressed: canBook
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Confirm Appointment',
                                                      ),
                                                      content: Text(
                                                        'Book appointment with Dr. $doctorName ?',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            final sessionId =
                                                                session.id;

                                                            final currentAppointments =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                      'appointments',
                                                                    )
                                                                    .where(
                                                                      'patientId',
                                                                      isEqualTo:
                                                                          patientId,
                                                                    )
                                                                    .get();

                                                            final alreadyBookedDoctor =
                                                                currentAppointments.docs.any((
                                                                  doc,
                                                                ) {
                                                                  final data =
                                                                      doc.data();
                                                                  return data['doctorId']
                                                                          ?.toString()
                                                                          .trim() ==
                                                                      doctorId;
                                                                });

                                                            if (alreadyBookedDoctor) {
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                                _showSnack(
                                                                  'You have already booked Dr. $doctorName.',
                                                                );
                                                              }
                                                              return;
                                                            }

                                                            final patientDoc =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                      'users',
                                                                    )
                                                                    .doc(
                                                                      patientId,
                                                                    )
                                                                    .get();

                                                            final patientName =
                                                                patientDoc
                                                                        .data()?['fullName']
                                                                    as String? ??
                                                                'Patient';

                                                            final currentBookingCount =
                                                                session['bookingCount']
                                                                    as int;
                                                            final maxAppts =
                                                                session['maxAppointments']
                                                                    as int;

                                                            var status =
                                                                'Available';
                                                            if (currentBookingCount >=
                                                                maxAppts) {
                                                              status =
                                                                  'Not Available';
                                                            }

                                                            final bookings =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                      'appointments',
                                                                    )
                                                                    .get();
                                                            final nextNumber =
                                                                bookings
                                                                    .docs
                                                                    .length +
                                                                1;
                                                            final bookingNumber =
                                                                'BK${nextNumber.toString().padLeft(3, '0')}';

                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  'appointments',
                                                                )
                                                                .add({
                                                                  'bookingNumber':
                                                                      bookingNumber,
                                                                  'patientId':
                                                                      patientId,
                                                                  'patientName':
                                                                      patientName,
                                                                  'doctorId':
                                                                      doctorId,
                                                                  'doctorName':
                                                                      doctorName,
                                                                  'specialization':
                                                                      specialization,
                                                                  'sessionId':
                                                                      sessionId,
                                                                  'sessionDate':
                                                                      session['sessionDate'],
                                                                  'sessionTime':
                                                                      session['sessionTime'],
                                                                  'roomNumber':
                                                                      session['roomNumber'],
                                                                  'channelFee':
                                                                      session['channelFee'],
                                                                  'tokenNumber':
                                                                      currentBookingCount +
                                                                      1,
                                                                  'status':
                                                                      'Booked',
                                                                  'bookingDate':
                                                                      Timestamp.now(),
                                                                });

                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  'sessions',
                                                                )
                                                                .doc(sessionId)
                                                                .update({
                                                                  'bookingCount':
                                                                      currentBookingCount +
                                                                      1,
                                                                  'status':
                                                                      status,
                                                                });

                                                            if (!context
                                                                .mounted) {
                                                              return;
                                                            }

                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            ScaffoldMessenger.of(
                                                              context,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                content: Text(
                                                                  'Appointment Booked Successfully',
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Confirm',
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            : null,
                                        child: Text(
                                          alreadyBooked
                                              ? 'Already Booked'
                                              : availableSlots == 0
                                              ? 'Session Full'
                                              : 'Book Appointment',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}
