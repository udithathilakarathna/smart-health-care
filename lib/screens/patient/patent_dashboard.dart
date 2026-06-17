import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'view_doctors_screen.dart';
import '../auth/login_screen.dart';

class PatientDashboard extends StatelessWidget {



  const PatientDashboard({
    super.key,
  });

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
              padding: const EdgeInsets.only(
                top: 60,
                bottom: 30,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
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
                  MaterialPageRoute(
                    builder: (_) =>
                    const ViewDoctorsScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text("Add Appointment"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Appointment History"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text("My Prescriptions"),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {},
            ),
            const Spacer(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () async {

                await FirebaseAuth.instance.signOut();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const LoginScreen(),
                  ),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child:Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    "Welcome Patient 👋",
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Patient Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

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
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
      String title,
      String value,
      IconData icon,
      ) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: const Color(0xFF1565C0),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title),
        ],
      ),
    );
  }
}