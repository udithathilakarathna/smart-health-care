import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_session_screen.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() =>
      _SessionScreenState();
}

class _SessionScreenState
    extends State<SessionScreen> {

  final TextEditingController
  searchController =
  TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        const Color(0xFF1565C0),

        title: const Text(

          "Doctor Sessions",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      floatingActionButton:
      FloatingActionButton.extended(

        backgroundColor:
        const Color(0xFF1565C0),

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(
              builder: (_) =>
              const AddSessionScreen(),
            ),
          );
        },

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(

          "Add Session",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("sessions")
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData) {

            return const Center(
              child: Text(
                  "No Sessions Found"),
            );
          }

          var sessions =
          snapshot.data!.docs;

          /// SEARCH FILTER
          var filteredSessions =
          sessions.where((doc) {

            Map<String, dynamic> data =
            doc.data()
            as Map<String, dynamic>;

            String doctor =
            data["doctorName"]
                .toString()
                .toLowerCase();

            return doctor.contains(
                searchText.toLowerCase());

          }).toList();

          /// COUNTS
          int totalSessions =
              sessions.length;

          int activeDoctors =
          sessions
              .map((e) =>
          (e.data()
          as Map<String, dynamic>)
          ["doctorName"])
              .toSet()
              .length;

          return SingleChildScrollView(

            child: Padding(

              padding:
              const EdgeInsets.all(16),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  /// DASHBOARD CARDS
                  Row(

                    children: [

                      Expanded(
                        child: dashboardCard(
                          "Today Sessions",
                          totalSessions.toString(),
                          Icons.calendar_today,
                          Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: dashboardCard(
                          "Active Doctors",
                          activeDoctors.toString(),
                          Icons.people,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// SEARCH BAR
                  TextField(

                    controller:
                    searchController,

                    onChanged: (value) {

                      setState(() {

                        searchText =
                            value;
                      });
                    },

                    decoration:
                    InputDecoration(

                      hintText:
                      "Search Doctor",

                      prefixIcon:
                      const Icon(
                          Icons.search),

                      filled: true,

                      fillColor:
                      Colors.white,

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius
                            .circular(15),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// SESSION LIST
                  ListView.builder(

                    shrinkWrap: true,

                    physics:
                    const NeverScrollableScrollPhysics(),

                    itemCount:
                    filteredSessions.length,

                    itemBuilder:
                        (context, index) {

                      var session =
                      filteredSessions[index];

                      Map<String, dynamic>
                      data =
                      session.data()
                      as Map<String, dynamic>;

                      return Container(

                        margin:
                        const EdgeInsets.only(
                            bottom: 20),

                        padding:
                        const EdgeInsets.all(
                            18),

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(25),

                          boxShadow: [

                            BoxShadow(

                              color: Colors
                                  .grey
                                  .shade200,

                              blurRadius: 10,

                              offset:
                              const Offset(
                                  0, 4),
                            ),
                          ],
                        ),

                        child: Column(

                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            /// TOP ROW
                            Row(

                              children: [

                                CircleAvatar(

                                  radius: 28,

                                  backgroundColor:
                                  Colors.blue
                                      .shade100,

                                  child:
                                  const Icon(

                                    Icons
                                        .medical_services,

                                    color:
                                    Colors.blue,
                                  ),
                                ),

                                const SizedBox(
                                    width: 15),

                                Expanded(

                                  child: Column(

                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,

                                    children: [

                                      Text(

                                        data["doctorName"]
                                            ?? "",

                                        style:
                                        const TextStyle(

                                          fontSize:
                                          20,

                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      Text(

                                        data["specialization"]
                                            ?? "",

                                        style:
                                        TextStyle(

                                          color: Colors
                                              .grey
                                              .shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(

                                  padding:
                                  const EdgeInsets
                                      .symmetric(

                                    horizontal:
                                    12,

                                    vertical: 6,
                                  ),

                                  decoration:
                                  BoxDecoration(

                                    color:
                                    Colors.green
                                        .shade100,

                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        20),
                                  ),

                                  child: Text(

                                    data.containsKey(
                                        "status")
                                        ? data["status"]
                                        : "Available",

                                    style:
                                    const TextStyle(

                                      color:
                                      Colors.green,

                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                                height: 20),

                            sessionDetail(
                              Icons.calendar_month,
                              data["sessionDate"],
                            ),

                            sessionDetail(
                              Icons.access_time,
                              data["sessionTime"],
                            ),

                            sessionDetail(
                              Icons.room,
                              "Room ${data["roomNumber"]}",
                            ),

                            sessionDetail(
                              Icons.currency_rupee,
                              "Rs. ${data["channelFee"]}",
                            ),

                            const SizedBox(
                                height: 10),

                            Align(

                              alignment:
                              Alignment.centerRight,

                              child: IconButton(

                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),

                                onPressed: () async {

                                  await FirebaseFirestore
                                      .instance
                                      .collection(
                                      "sessions")
                                      .doc(
                                      session.id)
                                      .delete();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// DASHBOARD CARD
  Widget dashboardCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          colors: [

            color,
            color.withOpacity(0.8),
          ],
        ),

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),

          const SizedBox(height: 15),

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 28,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(

            title,

            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// SESSION DETAIL ROW
  Widget sessionDetail(
      IconData icon,
      String text,
      ) {

    return Padding(

      padding:
      const EdgeInsets.only(
          bottom: 10),

      child: Row(

        children: [

          Icon(
            icon,
            color: Colors.blue,
          ),

          const SizedBox(width: 10),

          Text(

            text,

            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}