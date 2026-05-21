import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_staff_screen.dart';

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F8FC),

      appBar: AppBar(

        title: const Text(
          "Staff Members",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        backgroundColor:
        const Color(0xFF1565C0),
      ),

      /// ADD STAFF BUTTON
      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        const Color(0xFF1565C0),

        onPressed: () {

          Navigator.push(

            context,

            MaterialPageRoute(
              builder: (context) =>
              const AddStaffScreen(),
            ),
          );
        },

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      /// BODY
      body: StreamBuilder(

        stream: FirebaseFirestore.instance
            .collection("users")
            .where(
          "role",
          isEqualTo: "staff",
        )
            .snapshots(),

        builder: (context, snapshot) {

          /// LOADING
          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          /// NO DATA
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(

              child: Text(

                "No Staff Members Found",

                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            );
          }

          var staffList =
          snapshot.data!.docs;

          return ListView.builder(

            padding:
            const EdgeInsets.all(15),

            itemCount:
            staffList.length,

            itemBuilder:
                (context, index) {

              var staff =
              staffList[index];

              /// SAFE VALUES
              String fullName =
              staff.data().toString().contains("fullName")
                  ? staff["fullName"]
                  : "No Name";

              String roleType =
              staff.data().toString().contains("roleType")
                  ? staff["roleType"]
                  : "No Role";

              String email =
              staff.data().toString().contains("email")
                  ? staff["email"]
                  : "No Email";

              return Card(

                elevation: 3,

                margin:
                const EdgeInsets.only(
                    bottom: 15),

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(
                      18),
                ),

                child: ListTile(

                  contentPadding:
                  const EdgeInsets.all(15),

                  leading:
                  CircleAvatar(

                    radius: 28,

                    backgroundColor:
                    Colors.blue.shade100,

                    child: const Icon(

                      Icons.person,

                      size: 30,

                      color: Colors.blue,
                    ),
                  ),

                  /// NAME
                  title: Text(

                    fullName,

                    style: const TextStyle(

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  /// ROLE + EMAIL
                  subtitle: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                    children: [

                      const SizedBox(
                          height: 5),

                      Text(
                        roleType,
                      ),

                      const SizedBox(
                          height: 3),

                      Text(
                        email,
                      ),
                    ],
                  ),

                  /// DELETE BUTTON
                  trailing: IconButton(

                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),

                    onPressed: () async {

                      await FirebaseFirestore
                          .instance
                          .collection("users")
                          .doc(staff.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}