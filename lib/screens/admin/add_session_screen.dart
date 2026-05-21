import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSessionScreen extends StatefulWidget {
  const AddSessionScreen({super.key});

  @override
  State<AddSessionScreen> createState() =>
      _AddSessionScreenState();
}

class _AddSessionScreenState
    extends State<AddSessionScreen> {

  final TextEditingController
  dateController =
  TextEditingController();

  final TextEditingController
  timeController =
  TextEditingController();

  final TextEditingController
  feeController =
  TextEditingController();

  String selectedDoctor = "";
  String selectedRoom = "1";

  List<String> doctorList = [

    "Dr. Nipun",
    "Dr. Kaush",
    "Dr. Jalitha",
    "Dr. Uditha",

  ];

  /// DATE PICKER
  Future<void> pickDate() async {

    DateTime? pickedDate =
    await showDatePicker(

      context: context,

      initialDate:
      DateTime.now(),

      firstDate:
      DateTime.now(),

      lastDate:
      DateTime(2030),
    );

    if (pickedDate != null) {

      setState(() {

        dateController.text =
        "${pickedDate.day}/"
            "${pickedDate.month}/"
            "${pickedDate.year}";
      });
    }
  }

  /// TIME PICKER
  Future<void> pickTime() async {

    TimeOfDay? pickedTime =
    await showTimePicker(

      context: context,

      initialTime:
      TimeOfDay.now(),
    );

    if (pickedTime != null) {

      setState(() {

        timeController.text =
            pickedTime.format(context);
      });
    }
  }

  /// SAVE SESSION
  Future<void> saveSession() async {

    /// VALIDATION
    if (selectedDoctor.isEmpty ||
        dateController.text.isEmpty ||
        timeController.text.isEmpty ||
        feeController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          backgroundColor:
          Colors.red,

          content: Text(
            "Please fill all fields",
          ),
        ),
      );

      return;
    }

    try {

      /// CHECK SESSION LIMIT
      QuerySnapshot existingSessions =
      await FirebaseFirestore.instance
          .collection("sessions")
          .where(
            "doctorName",
            isEqualTo:
            selectedDoctor,
          )
          .where(
            "sessionDate",
            isEqualTo:
            dateController.text,
          )
          .get();

      /// MAX 15 SESSIONS
      if (existingSessions.docs.length >= 15) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            backgroundColor:
            Colors.red,

            content: Text(
              "Doctor session limit reached for this day",
            ),
          ),
        );

        return;
      }

      /// SAVE SESSION
      await FirebaseFirestore.instance
          .collection("sessions")
          .add({

        "doctorName":
        selectedDoctor,

        "sessionDate":
        dateController.text,

        "sessionTime":
        timeController.text,

        "roomNumber":
        selectedRoom,

        "channelFee":
        feeController.text,

        "status":
        "Available",

        "role":
        "admin",

        "bookingCount":
        0,

        "createdAt":
        Timestamp.now(),
      });

      /// SUCCESS MESSAGE
      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          backgroundColor:
          Colors.green,

          content: Text(
            "Session Added Successfully",
          ),
        ),
      );

      /// GO BACK
      Navigator.pop(context);

    } catch (e) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor:
          Colors.red,

          content:
          Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFFF4F8FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor:
        const Color(0xFF1565C0),

        title: const Text(

          "Add Session",

          style: TextStyle(

            color: Colors.white,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(
          children: [

            /// DOCTOR DROPDOWN
            DropdownButtonFormField(

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                prefixIcon:
                const Icon(Icons.person),

                hintText:
                "Select Doctor",

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              items: doctorList
                  .map((doctor) {

                return DropdownMenuItem(

                  value: doctor,

                  child: Text(doctor),
                );
              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedDoctor =
                  value.toString();
                });
              },
            ),

            const SizedBox(height: 18),

            /// DATE
            TextFormField(

              controller:
              dateController,

              readOnly: true,

              onTap: pickDate,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                prefixIcon:
                const Icon(
                    Icons.calendar_month),

                hintText:
                "Select Session Date",

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// TIME
            TextFormField(

              controller:
              timeController,

              readOnly: true,

              onTap: pickTime,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                prefixIcon:
                const Icon(Icons.access_time),

                hintText:
                "Select Session Time",

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// ROOM NUMBER
            DropdownButtonFormField(

              value: selectedRoom,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                prefixIcon:
                const Icon(Icons.room),

                hintText:
                "Select Room Number",

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              items:
              List.generate(50, (index) {

                return DropdownMenuItem(

                  value:
                  "${index + 1}",

                  child: Text(
                    "Room ${index + 1}",
                  ),
                );
              }),

              onChanged: (value) {

                setState(() {

                  selectedRoom =
                      value.toString();
                });
              },
            ),

            const SizedBox(height: 18),

            /// CHANNEL FEE
            TextFormField(

              controller:
              feeController,

              keyboardType:
              TextInputType.number,

              decoration: InputDecoration(

                filled: true,

                fillColor: Colors.white,

                prefixText: "Rs. ",

                prefixIcon:
                const Icon(
                    Icons.currency_rupee),

                hintText:
                "Enter Channel Fee",

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(16),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(

              width: double.infinity,

              height: 58,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  elevation: 5,

                  backgroundColor:
                  const Color(0xFF1565C0),

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                ),

                onPressed: saveSession,

                child: const Text(

                  "Save Session",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight:
                    FontWeight.bold,
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