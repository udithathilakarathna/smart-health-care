import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController
  fullNameController =
  TextEditingController();

  final TextEditingController
  nicController =
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
  confirmPasswordController =
  TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  Future<void> registerUser() async {

    if (fullNameController.text.isEmpty ||
        nicController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController
            .text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Please fill all fields"),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Passwords do not match"),
        ),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email:
        emailController.text.trim(),
        password:
        passwordController.text.trim(),
      );

      String uid =
          userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({
        "fullName":
        fullNameController.text
            .trim(),
        "nic":
        nicController.text.trim(),
        "phone":
        phoneController.text.trim(),
        "email":
        emailController.text
            .trim(),
        "role": "patient",
        "createdAt":
        Timestamp.now(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
              "Registration Successful"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const LoginScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
          Text(e.message ?? "Error"),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey
                .withOpacity(0.08),
            blurRadius: 12,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color:
            const Color(0xFF1565C0),
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(
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
      const Color(0xFFF4F8FC),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.only(
                  top: 40,
                  bottom: 40,
                ),
                decoration:
                const BoxDecoration(
                  gradient:
                  LinearGradient(
                    colors: [
                      Color(0xFF1565C0),
                      Color(0xFF42A5F5),
                    ],
                    begin:
                    Alignment.topLeft,
                    end: Alignment
                        .bottomRight,
                  ),
                  borderRadius:
                  BorderRadius.only(
                    bottomLeft:
                    Radius.circular(
                        35),
                    bottomRight:
                    Radius.circular(
                        35),
                  ),
                ),

                child: const Column(
                  children: [

                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                      Colors.white,
                      child: Icon(
                        Icons.local_hospital,
                        color: Color(
                            0xFF1565C0),
                        size: 45,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        color:
                        Colors.white,
                        fontSize: 30,
                        fontWeight:
                        FontWeight
                            .bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Join Smart Healthcare Today",
                      style: TextStyle(
                        color:
                        Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.all(
                    24),
                child: Column(
                  children: [

                    buildTextField(
                      hint:
                      "Full Name",
                      icon:
                      Icons.person,
                      controller:
                      fullNameController,
                    ),

                    const SizedBox(
                        height: 18),

                    buildTextField(
                      hint:
                      "NIC Number",
                      icon:
                      Icons.badge,
                      controller:
                      nicController,
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
                    ),

                    const SizedBox(
                        height: 18),

                    buildTextField(
                      hint: "Email",
                      icon:
                      Icons.email,
                      controller:
                      emailController,
                    ),

                    const SizedBox(
                        height: 18),

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
                        onPressed: () {
                          setState(() {
                            hidePassword =
                            !hidePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                        height: 18),

                    buildTextField(
                      hint:
                      "Confirm Password",
                      icon:
                      Icons.lock,
                      controller:
                      confirmPasswordController,
                      obscureText:
                      hideConfirmPassword,
                      suffixIcon:
                      IconButton(
                        icon: Icon(
                          hideConfirmPassword
                              ? Icons
                              .visibility_off
                              : Icons
                              .visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword =
                            !hideConfirmPassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                        height: 30),

                    SizedBox(
                      width:
                      double.infinity,
                      height: 58,
                      child:
                      ElevatedButton(
                        onPressed:
                        isLoading
                            ? null
                            : registerUser,
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                              0xFF1565C0),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                18),
                          ),
                          elevation: 6,
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                          color: Colors
                              .white,
                        )
                            : const Text(
                          "Create Account",
                          style:
                          TextStyle(
                            fontSize:
                            18,
                            color: Colors
                                .white,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 24),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .center,
                      children: [

                        const Text(
                          "Already have an account?",
                        ),

                        TextButton(
                          onPressed: () {

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .bold,
                            ),
                          ),
                        )
                      ],
                    )
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