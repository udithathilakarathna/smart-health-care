import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    String patientId =
        FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Appointment History",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("appointments")
            .where(
          "patientId",
          isEqualTo: patientId,
        )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Appointments Found",
              ),
            );
          }

          var appointments =
              snapshot.data!.docs;

          return ListView.builder(
            padding:
            const EdgeInsets.all(16),

            itemCount:
            appointments.length,

            itemBuilder:
                (context, index) {

              var appointment =
              appointments[index];

              return Container(
                margin:
                const EdgeInsets.only(
                  bottom: 15,
                ),

                padding:
                const EdgeInsets.all(
                  16,
                ),

                decoration:
                BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(
                      20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors
                          .grey.shade200,
                      blurRadius: 8,
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    Row(
                      children: [

                        CircleAvatar(
                          backgroundColor:
                          Colors.blue
                              .shade50,
                          child: const Icon(
                            Icons
                                .local_hospital,
                            color:
                            Colors.blue,
                          ),
                        ),

                        const SizedBox(
                            width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [

                              Text(
                                "Dr. ${appointment["doctorName"]}",
                                style:
                                const TextStyle(
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),

                              Text(
                                appointment[
                                "status"],
                                style:
                                const TextStyle(
                                  color: Colors
                                      .green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Booking ID : ${appointment["bookingNumber"]}",
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Text(
                      "📅 Date : ${appointment["sessionDate"]}",
                    ),

                    Text(
                      "⏰ Time : ${appointment["sessionTime"]}",
                    ),

                    Text(
                      "🏥 Room : ${appointment["roomNumber"]}",
                    ),

                    Text(
                      "💰 Fee : Rs. ${appointment["channelFee"]}",
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