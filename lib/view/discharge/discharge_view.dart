import 'dart:io';
import 'package:flutter/material.dart';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';

class DischargeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> dischargedPatients;
  final Function(Map<String, dynamic>) onReturnToHome; // ✅ Callback for returning patient

  const DischargeScreen({super.key, required this.dischargedPatients, required this.onReturnToHome});

  @override
  State<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends State<DischargeScreen> {
  List<Map<String, dynamic>> filteredPatients = [];
  TextEditingController txtSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredPatients = List.from(widget.dischargedPatients);
  }

  // **Search Discharged Patients**
  void searchPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPatients = List.from(widget.dischargedPatients);
      } else {
        filteredPatients = widget.dischargedPatients
            .where((patient) =>
            patient["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // **Delete Patient Permanently**
  void deletePatient(int index) {
    setState(() {
      filteredPatients.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Patient deleted permanently"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // **Return Patient to Home Screen**
  void returnPatientToHome(int index) {
    setState(() {
      var patient = filteredPatients.removeAt(index);
      widget.onReturnToHome(patient); // ✅ Send back to home
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Patient returned to Home"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      appBar: AppBar(
        backgroundColor: TColor.primary,
        title: Text(
          "Discharged Patients",
          style: TextStyle(color: TColor.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // **Search Bar**
            RoundTextfield(
              hintText: "Search Discharged Patients",
              controller: txtSearch,
              onChanged: searchPatients,
              left: Container(
                alignment: Alignment.center,
                width: 30,
                child: Icon(Icons.search, color: TColor.primary),
              ),
            ),
            const SizedBox(height: 10),

            // **Discharged Patients List**
            Expanded(
              child: filteredPatients.isEmpty
                  ? const Center(
                child: Text(
                  "No discharged patients yet.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: filteredPatients.length,
                itemBuilder: (context, index) {
                  var patient = filteredPatients[index];

                  return Dismissible(
                    key: Key(patient["id"].toString()),
                    direction: DismissDirection.horizontal, // ✅ Swipe left to delete, right to return
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        deletePatient(index);
                      } else if (direction == DismissDirection.startToEnd) {
                        returnPatientToHome(index);
                      }
                    },
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      color: Colors.green, // ✅ Swipe right to return
                      child: const Icon(Icons.undo, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      color: Colors.red, // ✅ Swipe left to delete
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      color: TColor.white,
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: TColor.placeholder,
                          backgroundImage: (patient["image"] != null &&
                              patient["image"].toString().isNotEmpty)
                              ? FileImage(File(patient["image"]))
                              : null,
                          child: (patient["image"] == null ||
                              patient["image"].toString().isEmpty)
                              ? Icon(Icons.person, color: TColor.secondaryText)
                              : null,
                        ),
                        title: Text(
                          patient["name"],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: TColor.primaryText),
                        ),
                        subtitle: Text(
                          "Patient ID: ${patient["id"]}",
                          style: TextStyle(color: TColor.secondaryText),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
