import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_doctor_screen.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        elevation: 0,
        title: const Text(
          "Doctors",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// Search + Add Button
            Row(
              children: [

                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Search Doctor",
                        prefixIcon:
                        Icon(Icons.search),
                        border:
                        InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                        0xFF1565C0),
                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                          16),
                    ),
                    padding:
                    const EdgeInsets.all(
                        16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const AddDoctorScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// Firebase Doctor List
            Expanded(
              child: StreamBuilder<
                  QuerySnapshot>(
                stream: FirebaseFirestore
                    .instance
                    .collection("users")
                    .where(
                  "role",
                  isEqualTo:
                  "doctor",
                )
                    .snapshots(),

                builder:
                    (context, snapshot) {

                  if (snapshot
                      .connectionState ==
                      ConnectionState
                          .waiting) {

                    return const Center(
                      child:
                      CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot
                      .hasData ||
                      snapshot
                          .data!
                          .docs
                          .isEmpty) {

                    return const Center(
                      child: Text(
                        "No Doctors Found",
                        style:
                        TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    );
                  }

                  var doctors =
                      snapshot
                          .data!.docs;

                  return ListView.builder(
                    itemCount:
                    doctors.length,

                    itemBuilder:
                        (context, index) {

                      var doctor =
                      doctors[
                      index];

                      return Container(
                        margin:
                        const EdgeInsets
                            .only(
                            bottom:
                            16),

                        padding:
                        const EdgeInsets
                            .all(
                            18),

                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(
                              24),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .grey
                                  .shade200,
                              blurRadius:
                              8,
                            ),
                          ],
                        ),

                        child: Row(
                          children: [

                            /// Avatar
                            CircleAvatar(
                              radius: 32,
                              backgroundColor:
                              const Color(
                                  0xFFE3F2FD),
                              child:
                              const Icon(
                                Icons
                                    .local_hospital,
                                color:
                                Colors
                                    .blue,
                                size: 30,
                              ),
                            ),

                            const SizedBox(
                                width:
                                16),

                            /// Doctor Details
                            Expanded(
                              child:
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [

                                  Text(
                                    doctor[
                                    "fullName"],
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize:
                                      18,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                      5),

                                  Text(
                                    doctor[
                                    "specialization"],
                                    style:
                                    TextStyle(
                                      color: Colors
                                          .grey
                                          .shade700,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                      5),

                                  Text(
                                    doctor[
                                    "phone"],
                                  ),

                                  const SizedBox(
                                      height:
                                      5),

                                  Text(
                                    "Fee: LKR ${doctor["channelFee"]}",
                                    style:
                                    const TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                      10),

                                  Row(
                                    children: [

                                      /// Edit
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                          color:
                                          Colors.blue.shade50,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        child:
                                        IconButton(
                                          onPressed:
                                              () {},
                                          icon:
                                          const Icon(
                                            Icons.edit,
                                            color:
                                            Colors.blue,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                          width:
                                          10),

                                      /// Delete
                                      Container(
                                        decoration:
                                        BoxDecoration(
                                          color:
                                          Colors.red.shade50,
                                          borderRadius:
                                          BorderRadius.circular(
                                              10),
                                        ),
                                        child:
                                        IconButton(
                                          onPressed:
                                              () {},
                                          icon:
                                          const Icon(
                                            Icons.delete,
                                            color:
                                            Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
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