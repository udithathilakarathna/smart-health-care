import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../admin/admin_dashboard.dart';
import 'register_screen.dart';
import '../patient/patent_dashboard.dart';

import '../doctor/doctor_dashboard_screen.dart';
import '../pharmacist/pharmacist_dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("User data not found")));

        setState(() {
          isLoading = false;
        });

        return;
      }

      String role = userDoc["role"];
      String roleType = userDoc.data().toString().contains("roleType")
          ? userDoc["roleType"]
          : "";

      print("================================");
      print("ROLE = $role");
      print("UID = $uid");
      print("================================");

      /// ADMIN
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
      }
      /// DOCTOR
      else if (role == "doctor") {
        print("DOCTOR DASHBOARD OPENING");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
        );
      } else if (role == "staff" && roleType == "Pharmacist") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PharmacistDashboardScreen()),
        );
      } else if (role == "patient") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PatientDashboard()),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login Failed")));
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1565C0)),
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

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 45),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                ),
                child: const Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.local_hospital,
                        color: Color(0xFF1565C0),
                        size: 45,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Access your healthcare account",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    buildTextField(
                      hint: "Email",
                      icon: Icons.email,
                      controller: emailController,
                    ),

                    const SizedBox(height: 20),

                    buildTextField(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      obscureText: hidePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text("Forgot Password?"),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 6,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
