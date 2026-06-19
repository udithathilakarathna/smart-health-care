import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../widgets/smart_back_button.dart';
import 'add_appointment_screen.dart';
import 'patent_dashboard.dart';

class ViewDoctorsScreen extends StatefulWidget {
  const ViewDoctorsScreen({super.key});

  @override
  State<ViewDoctorsScreen> createState() => _ViewDoctorsScreenState();
}

class _ViewDoctorsScreenState extends State<ViewDoctorsScreen> {
  static const Color _primaryBlue = Color(0xFF1565C0);
  static const Color _secondaryBlue = Color(0xFF42A5F5);
  static const Color _backgroundBlue = Color(0xFFF4F8FC);

  final TextEditingController searchController = TextEditingController();

  String selectedSpecialization = "All";

  final List<String> specializations = [
    "All",
    "General Physician",
    "Cardiologist",
    "Neurologist",
    "Dermatologist",
    "Pediatrician",
    "Orthopedic",
    "Psychiatrist",
    "ENT Specialist",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    Color backgroundColor = Colors.white,
    Color textColor = const Color(0xFF455A64),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE3EAF3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _primaryBlue),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Color(0xFF455A64),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundBlue,
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: SmartBackButton(
          fallbackPageBuilder: (_) => const PatientDashboard(),
        ),
        title: const Text(
          "Doctors",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -90,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _secondaryBlue.withValues(alpha: 0.14),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_primaryBlue, _secondaryBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D47A1).withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Find the right doctor",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Search specialists, compare fees, and book in one tap.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoChip(
                              icon: Icons.health_and_safety_outlined,
                              text: "Verified profiles",
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildInfoChip(
                              icon: Icons.event_available_outlined,
                              text: "Easy booking",
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              textColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D47A1).withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildSectionLabel("Search doctor"),
                      TextField(
                        controller: searchController,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search by name or specialization",
                          hintStyle: TextStyle(color: Colors.blueGrey.shade300),
                          prefixIcon: const Icon(Icons.search_rounded),
                          filled: true,
                          fillColor: const Color(0xFFF7FAFF),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                              color: _primaryBlue,
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      _buildSectionLabel("Specialization"),
                      DropdownButtonFormField<String>(
                        initialValue: selectedSpecialization,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF7FAFF),
                          prefixIcon: const Icon(Icons.category_outlined),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: Colors.blueGrey.shade100,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                            borderSide: BorderSide(
                              color: _primaryBlue,
                              width: 1.5,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        items: specializations
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            selectedSpecialization = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .where("role", isEqualTo: "doctor")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0D47A1,
                                  ).withValues(alpha: 0.06),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.medical_services_outlined,
                                  size: 42,
                                  color: _primaryBlue,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No Doctors Found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      var doctors = snapshot.data!.docs;

                      doctors = doctors.where((doctor) {
                        final name = doctor["fullName"]
                            .toString()
                            .toLowerCase();
                        final specialization = doctor["specialization"]
                            .toString();
                        final query = searchController.text.toLowerCase();

                        final matchesSearch =
                            name.contains(query) ||
                            specialization.toLowerCase().contains(query);
                        final matchesSpecialization =
                            selectedSpecialization == "All" ||
                            specialization == selectedSpecialization;

                        return matchesSearch && matchesSpecialization;
                      }).toList();

                      if (doctors.isEmpty) {
                        return Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0D47A1,
                                  ).withValues(alpha: 0.06),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 42,
                                  color: _primaryBlue,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "No matching doctors",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: doctors.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];
                          final availableDays = doctor["availableDays"];
                          final daysText = availableDays is List
                              ? availableDays
                                    .map((day) => day.toString())
                                    .join(", ")
                              : doctor["availableDays"].toString();

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.97),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0D47A1,
                                  ).withValues(alpha: 0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: const Color(0xFFE8EEF7),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [_primaryBlue, _secondaryBlue],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: _primaryBlue.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.local_hospital_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          doctor["fullName"],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _buildInfoChip(
                                              icon: Icons.badge_outlined,
                                              text: doctor["specialization"]
                                                  .toString(),
                                            ),
                                            _buildInfoChip(
                                              icon: Icons.phone_outlined,
                                              text: doctor["phone"].toString(),
                                            ),
                                            _buildInfoChip(
                                              icon: Icons.payments_outlined,
                                              text:
                                                  "Rs. ${doctor["channelFee"]}",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Days: $daysText",
                                          style: TextStyle(
                                            color: Colors.blueGrey.shade700,
                                            fontSize: 13,
                                            height: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _primaryBlue,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddAppointmentScreen(
                                                  initialDoctorName:
                                                      doctor["fullName"],
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Book',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
