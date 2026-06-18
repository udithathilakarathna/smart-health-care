import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  final TextEditingController
  nameController =
  TextEditingController();

  final TextEditingController
  phoneController =
  TextEditingController();

  String email = "";
  String nic = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (userDoc.exists) {

      nameController.text =
          userDoc["fullName"] ?? "";

      phoneController.text =
          userDoc["phone"] ?? "";

      email =
          userDoc["email"] ?? "";

      nic =
          userDoc["nic"] ?? "";

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({

      "fullName":
      nameController.text.trim(),

      "phone":
      phoneController.text.trim(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Profile Updated Successfully",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
          CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
      const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor:
        const Color(0xFF1565C0),

        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(25),

              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),

              child: const Column(
                children: [

                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                    Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color:
                      Color(0xFF1565C0),
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Patient Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              controller:
              nameController,

              decoration:
              InputDecoration(
                labelText:
                "Full Name",
                prefixIcon:
                const Icon(
                  Icons.person,
                ),
                filled: true,
                fillColor:
                Colors.white,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              readOnly: true,
              decoration:
              InputDecoration(
                labelText: email,
                prefixIcon:
                const Icon(
                  Icons.email,
                ),
                filled: true,
                fillColor:
                Colors.grey.shade100,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              readOnly: true,
              decoration:
              InputDecoration(
                labelText: nic,
                prefixIcon:
                const Icon(
                  Icons.badge,
                ),
                filled: true,
                fillColor:
                Colors.grey.shade100,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
              phoneController,

              keyboardType:
              TextInputType.phone,

              decoration:
              InputDecoration(
                labelText:
                "Phone Number",
                prefixIcon:
                const Icon(
                  Icons.phone,
                ),
                filled: true,
                fillColor:
                Colors.white,
                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(
                      15),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed:
                updateProfile,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF1565C0),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),
                ),

                child: const Text(
                  "Update Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}