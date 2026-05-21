import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() =>
      _AddDoctorScreenState();
}

class _AddDoctorScreenState
    extends State<AddDoctorScreen> {

  final TextEditingController
  doctorNameController =
  TextEditingController();

  final TextEditingController
  phoneController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  final TextEditingController
  feeController =
  TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  String selectedSpecialization =
      "General Physician";

  List<String> selectedDays = [];

  final List<String>
  specializations = [
    "General Physician",
    "Cardiologist",
    "Neurologist",
    "Dermatologist",
    "Pediatrician",
    "Orthopedic",
    "Psychiatrist",
    "ENT Specialist",
  ];

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  Future<void> saveDoctor() async {

    if (doctorNameController
        .text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController
            .text.isEmpty ||
        feeController.text.isEmpty ||
        selectedDays.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Fill all fields"),
        ),
      );
      return;
    }

    try {

      setState(() {
        isLoading = true;
      });

      /// Create Login
      UserCredential
      userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email:
        emailController.text.trim(),
        password:
        passwordController.text.trim(),
      );

      String uid =
          userCredential.user!.uid;

      /// Save Doctor Data
      await FirebaseFirestore
          .instance
          .collection("users")
          .doc(uid)
          .set({

        "fullName":
        doctorNameController.text
            .trim(),

        "phone":
        phoneController.text
            .trim(),

        "email":
        emailController.text
            .trim(),

        "specialization":
        selectedSpecialization,

        "channelFee":
        feeController.text
            .trim(),

        "availableDays":
        selectedDays,

        "role": "doctor",

        "createdAt":
        Timestamp.now(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Doctor Added Successfully"),
        ),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(e.message ??
              "Error"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController
    controller,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType =
        TextInputType.text,
  }) {

    return Container(
      margin:
      const EdgeInsets.only(
          bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType:
        keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color:
            const Color(
                0xFF1565C0),
          ),
          suffixIcon:
          suffixIcon,
          border:
          InputBorder.none,
          contentPadding:
          const EdgeInsets
              .symmetric(
            vertical: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
      const Color(
          0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor:
        const Color(
            0xFF1565C0),
        title: const Text(
          "Add Doctor",
          style: TextStyle(
              color:
              Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding:
        const EdgeInsets.all(
            24),
        child: Column(
          children: [

            buildTextField(
              hint:
              "Doctor Name",
              icon:
              Icons.person,
              controller:
              doctorNameController,
            ),

            /// Specialization
            Container(
              padding:
              const EdgeInsets
                  .symmetric(
                horizontal: 16,
              ),
              decoration:
              BoxDecoration(
                color:
                Colors.white,
                borderRadius:
                BorderRadius
                    .circular(
                    18),
              ),
              child:
              DropdownButtonFormField<
                  String>(
                initialValue:
                selectedSpecialization,
                decoration:
                const InputDecoration(
                  border:
                  InputBorder
                      .none,
                ),
                items:
                specializations
                    .map(
                      (e) =>
                      DropdownMenuItem(
                        value:
                        e,
                        child:
                        Text(
                            e),
                      ),
                )
                    .toList(),
                onChanged:
                    (value) {
                  setState(() {
                    selectedSpecialization =
                    value!;
                  });
                },
              ),
            ),

            const SizedBox(
                height: 18),

            buildTextField(
              hint:
              "Phone Number",
              icon:
              Icons.phone,
              controller:
              phoneController,
              keyboardType:
              TextInputType
                  .phone,
            ),

            buildTextField(
              hint: "Email",
              icon:
              Icons.email,
              controller:
              emailController,
              keyboardType:
              TextInputType
                  .emailAddress,
            ),

            buildTextField(
              hint:
              "Password",
              icon:
              Icons.lock,
              controller:
              passwordController,
              obscureText:
              hidePassword,
              suffixIcon:
              IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons
                      .visibility_off
                      : Icons
                      .visibility,
                ),
                onPressed:
                    () {
                  setState(() {
                    hidePassword =
                    !hidePassword;
                  });
                },
              ),
            ),

            buildTextField(
              hint:
              "Channel Fee",
              icon:
              Icons.money,
              controller:
              feeController,
              keyboardType:
              TextInputType
                  .number,
            ),

            const SizedBox(
                height: 15),

            /// Days
            Align(
              alignment:
              Alignment
                  .centerLeft,
              child: Text(
                "Available Days",
                style:
                TextStyle(
                  fontSize:
                  18,
                  fontWeight:
                  FontWeight
                      .bold,
                  color:
                  Colors.grey
                      .shade800,
                ),
              ),
            ),

            const SizedBox(
                height: 10),

            Wrap(
              spacing: 8,
              children: days
                  .map((day) {

                bool selected =
                selectedDays
                    .contains(
                    day);

                return FilterChip(
                  selected:
                  selected,
                  label:
                  Text(day),
                  selectedColor:
                  const Color(
                      0xFF1565C0),
                  labelStyle:
                  TextStyle(
                    color: selected
                        ? Colors
                        .white
                        : Colors
                        .black,
                  ),
                  onSelected:
                      (value) {
                    setState(() {
                      if (selected) {
                        selectedDays
                            .remove(
                            day);
                      } else {
                        selectedDays
                            .add(
                            day);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(
                height: 35),

            SizedBox(
              width:
              double.infinity,
              height: 58,
              child:
              ElevatedButton(
                onPressed:
                isLoading
                    ? null
                    : saveDoctor,
                style:
                ElevatedButton
                    .styleFrom(
                  backgroundColor:
                  const Color(
                      0xFF1565C0),
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius
                        .circular(
                        18),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                  color: Colors
                      .white,
                )
                    : const Text(
                  "Save Doctor",
                  style:
                  TextStyle(
                    fontSize:
                    18,
                    color: Colors
                        .white,
                    fontWeight:
                    FontWeight
                        .bold,
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