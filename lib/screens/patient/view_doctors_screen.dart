import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewDoctorsScreen extends StatefulWidget {
  const ViewDoctorsScreen({super.key});

  @override
  State<ViewDoctorsScreen> createState() =>
      _ViewDoctorsScreenState();
}

class _ViewDoctorsScreenState
    extends State<ViewDoctorsScreen> {

  final TextEditingController
  searchController =
  TextEditingController();

  String selectedSpecialization = "All";

  final List<String> specializations = [
    "All",
    "General Physician",
    "Cardiologist",
    "Neurologist",
    "Dermatologist",
    "Pediatrician",
    "Orthopedic",
    "Psychiatrist",
    "ENT Specialist",
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor:
        const Color(0xFF1565C0),
        title: const Text(
          "Doctors",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(
          children: [

            /// SEARCH
            TextField(
              controller:
              searchController,
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
                      .circular(
                      16),
                  borderSide:
                  BorderSide.none,
                ),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),

            const SizedBox(
                height: 15),

            /// FILTER
            DropdownButtonFormField<
                String>(
              value:
              selectedSpecialization,

              decoration:
              InputDecoration(
                filled: true,
                fillColor:
                Colors.white,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                      16),
                  borderSide:
                  BorderSide.none,
                ),
              ),

              items:
              specializations
                  .map((item) {

                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),

              onChanged:
                  (value) {

                setState(() {

                  selectedSpecialization =
                  value!;
                });
              },
            ),

            const SizedBox(
                height: 15),

            /// DOCTOR LIST
            Expanded(
              child:
              StreamBuilder<
                  QuerySnapshot>(
                stream:
                FirebaseFirestore
                    .instance
                    .collection(
                    "users")
                    .where(
                  "role",
                  isEqualTo:
                  "doctor",
                )
                    .snapshots(),

                builder: (
                    context,
                    snapshot,
                    ) {

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
                      ),
                    );
                  }

                  var doctors =
                      snapshot
                          .data!
                          .docs;

                  doctors =
                      doctors.where(
                            (doctor) {

                          String name =
                          doctor[
                          "fullName"]
                              .toString()
                              .toLowerCase();

                          String spec =
                          doctor[
                          "specialization"];

                          bool matchesSearch =
                          name.contains(
                            searchController
                                .text
                                .toLowerCase(),
                          );

                          bool matchesSpec =
                              selectedSpecialization ==
                                  "All" ||
                                  spec ==
                                      selectedSpecialization;

                          return matchesSearch &&
                              matchesSpec;
                        },
                      ).toList();

                  return ListView.builder(
                    itemCount:
                    doctors.length,

                    itemBuilder:
                        (context,
                        index) {

                      var doctor =
                      doctors[
                      index];

                      return Container(

                        margin:
                        const EdgeInsets
                            .only(
                            bottom:
                            15),

                        padding:
                        const EdgeInsets
                            .all(
                            16),

                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,

                          borderRadius:
                          BorderRadius
                              .circular(
                              20),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .grey
                                  .shade200,
                              blurRadius:
                              8,
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            CircleAvatar(
                              radius: 30,
                              backgroundColor:
                              Colors
                                  .blue
                                  .shade50,

                              child:
                              const Icon(
                                Icons
                                    .local_hospital,
                                color:
                                Colors
                                    .blue,
                              ),
                            ),

                            const SizedBox(
                                width:
                                15),

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
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                      4),

                                  Text(
                                    doctor[
                                    "specialization"],
                                  ),

                                  const SizedBox(
                                      height:
                                      4),

                                  Text(
                                    doctor[
                                    "phone"],
                                  ),

                                  const SizedBox(
                                      height:
                                      4),

                                  Text(
                                    "Fee: Rs. ${doctor["channelFee"]}",
                                  ),

                                  const SizedBox(
                                      height:
                                      4),

                                  Text(
                                    "Days: ${doctor["availableDays"].join(", ")}",
                                  ),
                                ],
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