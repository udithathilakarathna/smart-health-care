import 'package:flutter/material.dart';
import 'doctor_screen.dart';
import 'staff_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FC),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1565C0),
        title: const Text(
          "Smart Healthcare",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      drawer: Drawer(
        child: Column(
          children: [

            /// Drawer Header
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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                children: [

                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF1565C0),
                      size: 40,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Admin Panel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 4),

                  Text(
                    "Hospital Management",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// Dashboard
            buildDrawerItem(
              icon: Icons.dashboard,
              title: "Dashboard",
              onTap: () {
                Navigator.pop(context);
              },
            ),

            /// Doctors
            buildDrawerItem(
              icon: Icons.local_hospital,
              title: "Doctors",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const DoctorsScreen(),
                  ),
                );
              },
            ),

            /// Staff Members
            buildDrawerItem(
              icon: Icons.people,
              title: "Staff Members",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const StaffScreen(),
                  ),
                );
              },
            ),

            /// Sessions
            buildDrawerItem(
              icon: Icons.schedule,
              title: "Sessions",
              onTap: () {},
            ),

            /// Patients
            buildDrawerItem(
              icon: Icons.person,
              title: "Patients",
              onTap: () {},
            ),

            /// Bookings
            buildDrawerItem(
              icon: Icons.calendar_today,
              title: "Bookings",
              onTap: () {},
            ),

            const Spacer(),

            const Divider(),

            /// Logout
            buildDrawerItem(
              icon: Icons.logout,
              title: "Logout",
              color: Colors.red,
              onTap: () async {

                bool? confirmLogout =
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            20),
                      ),
                      title:
                      const Text("Logout"),
                      content: const Text(
                        "Are you sure you want to logout?",
                      ),
                      actions: [

                        TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                false);
                          },
                          child:
                          const Text("Cancel"),
                        ),

                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.red,
                          ),
                          onPressed: () {
                            Navigator.pop(
                                context,
                                true);
                          },
                          child:
                          const Text(
                            "Logout",
                            style: TextStyle(
                                color:
                                Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );

                if (confirmLogout ==
                    true) {

                  await FirebaseAuth
                      .instance
                      .signOut();

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                      const LoginScreen(),
                    ),
                        (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// Welcome Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient:
                const LinearGradient(
                  colors: [
                    Color(0xFF1565C0),
                    Color(0xFF42A5F5),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    "Good Morning 👋",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Manage doctors, staff, sessions and bookings",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Hospital Overview",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            /// Stats Cards
            GridView.count(
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.15,
              children: const [

                DashboardCard(
                  title: "Doctors",
                  value: "15",
                  icon:
                  Icons.local_hospital,
                ),

                DashboardCard(
                  title: "Staff",
                  value: "8",
                  icon: Icons.people,
                ),

                DashboardCard(
                  title: "Sessions",
                  value: "25",
                  icon: Icons.schedule,
                ),

                DashboardCard(
                  title: "Patients",
                  value: "120",
                  icon: Icons.person,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Quick Actions",
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            buildActionButton(
              icon: Icons.add,
              title: "Add Doctor",
            ),

            buildActionButton(
              icon: Icons.person_add,
              title: "Add Staff Member",
            ),

            buildActionButton(
              icon: Icons.schedule,
              title: "Create Session",
            ),

            buildActionButton(
              icon: Icons.assignment,
              title: "Manage Bookings",
            ),
          ],
        ),
      ),
    );
  }
}

/// Drawer Item
Widget buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  Color color = Colors.black87,
}) {
  return ListTile(
    leading: Icon(icon, color: color),
    title: Text(
      title,
      style: TextStyle(color: color),
    ),
    onTap: onTap,
  );
}

/// Quick Action Button
Widget buildActionButton({
  required IconData icon,
  required String title,
}) {
  return Container(
    margin:
    const EdgeInsets.only(bottom: 15),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        const Color(0xFF1565C0),
        minimumSize:
        const Size(double.infinity, 60),
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),
      ),
      onPressed: () {},
      icon: Icon(icon,
          color: Colors.white),
      label: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight:
          FontWeight.w600,
        ),
      ),
    ),
  );
}

/// Dashboard Card
class DashboardCard
    extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color:
            Colors.grey.shade200,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          CircleAvatar(
            backgroundColor:
            const Color(0xFFE3F2FD),
            child: Icon(
              icon,
              color:
              const Color(0xFF1565C0),
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}