import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _primaryBlue = Color(0xFF1565C0);
  static const Color _secondaryBlue = Color(0xFF42A5F5);
  static const Color _backgroundBlue = Color(0xFFF4F8FC);

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    nicController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> registerUser() async {
    if (fullNameController.text.isEmpty ||
        nicController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showSnack("Please fill all fields");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showSnack("Passwords do not match");
      return;
    }

    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      final String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "fullName": fullNameController.text.trim(),
        "nic": nicController.text.trim(),
        "phone": phoneController.text.trim(),
        "email": emailController.text.trim(),
        "role": "patient",
        "createdAt": Timestamp.now(),
      });

      if (!mounted) {
        return;
      }

      _showSnack("Registration successful");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showSnack(e.message ?? "Error");
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.blueGrey.shade300),
        prefixIcon: Icon(icon, color: _primaryBlue),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: _primaryBlue, width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _secondaryBlue.withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: -70,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _primaryBlue.withValues(alpha: 0.06),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF0D47A1,
                          ).withValues(alpha: 0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [_primaryBlue, _secondaryBlue],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.28,
                                      ),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person_add_alt_1_rounded,
                                    color: Colors.white,
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                const Text(
                                  "Create Account",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Join Smartcare and manage healthcare with ease",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14.5,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _primaryBlue.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    "Patient registration",
                                    style: TextStyle(
                                      color: _primaryBlue,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Full name",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Enter your full name",
                                  icon: Icons.person_outline,
                                  controller: fullNameController,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "NIC number",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Enter NIC number",
                                  icon: Icons.badge_outlined,
                                  controller: nicController,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Phone number",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Enter phone number",
                                  icon: Icons.phone_outlined,
                                  controller: phoneController,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Email address",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Enter your email",
                                  icon: Icons.email_outlined,
                                  controller: emailController,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Password",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Create a password",
                                  icon: Icons.lock_outline,
                                  controller: passwordController,
                                  obscureText: hidePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      hidePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Confirm password",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF455A64),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                buildTextField(
                                  hint: "Re-enter your password",
                                  icon: Icons.lock_reset_outlined,
                                  controller: confirmPasswordController,
                                  obscureText: hideConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      hideConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.blueGrey.shade400,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        hideConfirmPassword =
                                            !hideConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 58,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : registerUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _primaryBlue,
                                      foregroundColor: Colors.white,
                                      disabledBackgroundColor: _primaryBlue
                                          .withValues(alpha: 0.65),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 0,
                                      shadowColor: Colors.transparent,
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                              key: ValueKey('loading'),
                                              width: 22,
                                              height: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Row(
                                              key: ValueKey('create-account'),
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.verified_user_rounded,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "Create Account",
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade600,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const LoginScreen(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: _primaryBlue,
                                        padding: const EdgeInsets.only(left: 6),
                                      ),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
