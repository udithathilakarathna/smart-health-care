import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final TextEditingController staffNameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  String selectedRole = "Receptionist";

  final List<String> roles = [
    "Receptionist",
    "Nurse",
    "Lab Assistant",
    "Pharmacist",
    "Cashier",
    "Ward Assistant",
    "Management Staff",
  ];

  /// SAVE STAFF
  Future<void> saveStaff() async {
    if (staffNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));

      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      /// CREATE AUTH USER
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),

            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      /// SAVE FIRESTORE
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "fullName": staffNameController.text.trim(),

        "phone": phoneController.text.trim(),

        "email": emailController.text.trim(),

        "roleType": selectedRole,

        "role": "staff",

        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Staff Added Successfully")));

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Error")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    setState(() {
      isLoading = false;
    });
  }

  /// TEXT FIELD
  Widget buildTextField({
    required String hint,

    required IconData icon,

    required TextEditingController controller,

    bool obscureText = false,

    Widget? suffixIcon,

    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),
      ),

      child: TextField(
        controller: controller,

        obscureText: obscureText,

        keyboardType: keyboardType,

        decoration: InputDecoration(
          hintText: hint,

          prefixIcon: Icon(icon, color: Colors.blue),

          suffixIcon: suffixIcon,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(vertical: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),

        title: const Text(
          "Add Staff Member",

          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            /// NAME
            buildTextField(
              hint: "Staff Name",

              icon: Icons.person,

              controller: staffNameController,
            ),

            /// ROLE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18),
              ),

              child: DropdownButtonFormField<String>(
                value: selectedRole,

                decoration: const InputDecoration(border: InputBorder.none),

                items: roles
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 18),

            /// PHONE
            buildTextField(
              hint: "Phone Number",

              icon: Icons.phone,

              controller: phoneController,

              keyboardType: TextInputType.phone,
            ),

            /// EMAIL
            buildTextField(
              hint: "Email",

              icon: Icons.email,

              controller: emailController,

              keyboardType: TextInputType.emailAddress,
            ),

            /// PASSWORD
            buildTextField(
              hint: "Password",

              icon: Icons.lock,

              controller: passwordController,

              obscureText: hidePassword,

              suffixIcon: IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),

                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 35),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,

              height: 58,

              child: ElevatedButton(
                onPressed: isLoading ? null : saveStaff,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Save Staff Member",

                        style: TextStyle(
                          fontSize: 18,

                          color: Colors.white,

                          fontWeight: FontWeight.bold,
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
