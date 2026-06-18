import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() =>
      _AddAppointmentScreenState();
}

class _AddAppointmentScreenState
    extends State<AddAppointmentScreen> {

  String? selectedDoctor;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Book Appointment",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// HEADER CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),

              child: const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    "Book New Appointment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Find and book a doctor session",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// DOCTOR FILTER
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "doctor")
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                var doctors = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedDoctor,

                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.person),
                    hintText: "Select Doctor",
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),

                  items: doctors.map((doctor) {

                    return DropdownMenuItem<String>(
                      value: doctor["fullName"],
                      child: Text(
                        doctor["fullName"],
                      ),
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

            /// SESSION LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: selectedDoctor == null
                  ? FirebaseFirestore.instance
                  .collection("sessions")
                  .snapshots()
                  : FirebaseFirestore.instance
                  .collection("sessions")
                  .where(
                "doctorName",
                isEqualTo: selectedDoctor,
              )
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Available Sessions",
                    ),
                  );
                }

                var sessions = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: sessions.length,

                  itemBuilder: (context, index) {

                    var session = sessions[index];

                    int bookingCount =
                    session["bookingCount"];

                    int maxAppointments =
                    session["maxAppointments"];

                    int availableSlots =
                        maxAppointments -
                            bookingCount;

                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),

                      padding:
                      const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(
                            20),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.grey.shade200,
                            blurRadius: 8,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              const CircleAvatar(
                                child: Icon(
                                  Icons.local_hospital,
                                ),
                              ),

                              const SizedBox(
                                  width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      "Dr. ${session["doctorName"]}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),

                                    FutureBuilder<QuerySnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection("users")
                                          .where(
                                        "fullName",
                                        isEqualTo:
                                        session["doctorName"],
                                      )
                                          .limit(1)
                                          .get(),
                                      builder: (
                                          context,
                                          doctorSnapshot,
                                          ) {

                                        if (!doctorSnapshot.hasData ||
                                            doctorSnapshot
                                                .data!
                                                .docs
                                                .isEmpty) {
                                          return const SizedBox();
                                        }

                                        return Text(
                                          doctorSnapshot
                                              .data!
                                              .docs
                                              .first[
                                          "specialization"],
                                          style: TextStyle(
                                            color:
                                            Colors.grey.shade600,
                                            fontSize: 14,
                                          ),
                                        );
                                      },
                                    ),

                                    Text(
                                      "Room ${session["roomNumber"]}",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          Text(
                            "📅 Date : ${session["sessionDate"]}",
                          ),

                          Text(
                            "⏰ Time : ${session["sessionTime"]}",
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "💰 Fee : Rs. ${session["channelFee"]}",
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Available Slots : $availableSlots / $maxAppointments",
                            style:
                            const TextStyle(
                              color: Colors.green,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          SizedBox(
                            width:
                            double.infinity,

                            child: ElevatedButton(
                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                const Color(
                                    0xFF1565C0),
                              ),

                              onPressed: availableSlots == 0
                                  ? null
                                  : () {

                                showDialog(
                                  context:
                                  context,

                                  builder: (_) {

                                    return AlertDialog(
                                      title:
                                      const Text(
                                        "Confirm Appointment",
                                      ),

                                      content:
                                      Text(
                                        "Book appointment with ${session["doctorName"]} ?",
                                      ),

                                      actions: [

                                        TextButton(
                                          onPressed:
                                              () {
                                            Navigator.pop(
                                                context);
                                          },
                                          child:
                                          const Text(
                                            "Cancel",
                                          ),
                                        ),

                                        ElevatedButton(
                                          onPressed: () async {

                                            String sessionId = session.id;

                                            int bookingCount =
                                            session["bookingCount"];

                                            int maxAppointments =
                                            session["maxAppointments"];

                                            bookingCount++;

                                            String status = "Available";

                                            if (bookingCount >= maxAppointments) {
                                              status = "Not Available";
                                            }
                                            QuerySnapshot bookings =
                                            await FirebaseFirestore.instance
                                                .collection("appointments")
                                                .get();

                                            int nextNumber =
                                                bookings.docs.length + 1;

                                            String bookingNumber =
                                                "BK${nextNumber.toString().padLeft(3, '0')}";

                                            var doctorDoc =
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .where(
                                              "fullName",
                                              isEqualTo: session["doctorName"],
                                            )
                                                .limit(1)
                                                .get();

                                            String specialization =
                                            doctorDoc.docs.first["specialization"];

                                            String doctorId =
                                                doctorDoc.docs.first.id;

                                            // Save Appointment
                                            await FirebaseFirestore.instance
                                                .collection("appointments")
                                                .add({
                                              "bookingNumber":
                                              bookingNumber,

                                              "patientId":
                                              FirebaseAuth.instance.currentUser!.uid,

                                              "doctorId":
                                              doctorId,

                                              "doctorName":
                                              session["doctorName"],

                                              "specialization":
                                              specialization,

                                              "sessionId":
                                              sessionId,

                                              "sessionDate":
                                              session["sessionDate"],

                                              "sessionTime":
                                              session["sessionTime"],

                                              "roomNumber":
                                              session["roomNumber"],

                                              "channelFee":
                                              session["channelFee"],

                                              "status":
                                              "Booked",

                                              "bookingDate":
                                              Timestamp.now(),
                                            });

                                            // Update Session
                                            await FirebaseFirestore.instance
                                                .collection("sessions")
                                                .doc(sessionId)
                                                .update({

                                              "bookingCount": bookingCount,
                                              "status": status,
                                            });

                                            Navigator.pop(context);

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Appointment Booked Successfully",
                                                ),
                                              ),
                                            );
                                          },
                                          child:
                                          const Text(
                                            "Confirm",
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                availableSlots == 0
                                    ? "Session Full"
                                    : "Book Appointment",
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
            ),
          ),
          ],
        ),
      ),
    );
  }
}