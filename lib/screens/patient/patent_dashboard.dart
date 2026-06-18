import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view_doctors_screen.dart';
import '../auth/login_screen.dart';
import 'add_appointment_screen.dart';
import 'appointment_history_screen.dart';
<<<<<<< HEAD
import 'profile_screen.dart';


class PatientDashboard extends StatelessWidget {

  const PatientDashboard({
    super.key,
  });
=======
import 'my_prescriptions_screen.dart';
import 'patient_profile_screen.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});
>>>>>>> feature/pharmacist-role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Patient Dashboard",
          style: TextStyle(color: Colors.white),
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF1565C0),
                      size: 40,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Patient Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Dashboard"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text("Doctors"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewDoctorsScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Add Appointment"),
              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddAppointmentScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Appointment History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AppointmentHistoryScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("My Prescriptions"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyPrescriptionsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ProfileScreen(),
                  ),
                );
              },
            ),
            const Spacer(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();

                if (!context.mounted) {
                  return;
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F4C81), Color(0xFF1D9BF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
<<<<<<< HEAD
                borderRadius:
                BorderRadius.circular(20),
              ),
              child:Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    "Welcome 👋",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
=======
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F4C81).withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart Care for your health journey",
                    style: TextStyle(color: Colors.white70),
>>>>>>> feature/pharmacist-role
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Patient Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Book care, manage visits, and track prescriptions in one place.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: dashboardCard(
                    "My Appointments",
                    "0",
                    Icons.calendar_month,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: dashboardCard(
                    "Prescriptions",
                    "0",
                    Icons.medical_information,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: dashboardCard("Doctors", "Find", Icons.local_hospital),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: dashboardCard(
                    "Profile",
                    "View",
                    Icons.person,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PatientProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Container(
      height: 145,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4C81).withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFF0F4C81)),
                ),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(title, style: TextStyle(color: Colors.grey.shade700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
