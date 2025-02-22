import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../common/color_extension.dart';
import '../../common_widget/round_textfield.dart';
import '../about/notification_view.dart';
import '../discharge/discharge_view.dart';
import 'patient_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Map<String, dynamic>> patientArr = [];
  List<Map<String, dynamic>> filteredPatients = [];
  List<Map<String, dynamic>> dischargedPatients = [];
  TextEditingController txtSearch = TextEditingController();
  int unreadNotifications = 5;
  Map<String, dynamic>? lastDeletedPatient;
  int lastDeletedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadPatients();
    loadDischargedPatients();
  }

  // **Load Patients from Storage**
  Future<void> loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('patients');

    if (savedData != null) {
      setState(() {
        patientArr = List<Map<String, dynamic>>.from(json.decode(savedData));
        filteredPatients = List.from(patientArr);
      });
    }
  }

  // **Load Discharged Patients from Storage**
  Future<void> loadDischargedPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('dischargedPatients');

    if (savedData != null) {
      setState(() {
        dischargedPatients = List<Map<String, dynamic>>.from(json.decode(savedData));
      });
    }
  }

  // **Save Patients to Storage**
  Future<void> savePatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('patients', json.encode(patientArr));
  }

  // **Save Discharged Patients to Storage**
  Future<void> saveDischargedPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('dischargedPatients', json.encode(dischargedPatients));
  }

  // **Update Patient Details**
  void updatePatient(Map<String, dynamic> updatedPatient) {
    int index = patientArr.indexWhere((p) => p["id"] == updatedPatient["id"]);
    if (index != -1) {
      setState(() {
        patientArr[index] = updatedPatient;
        filteredPatients = List.from(patientArr);
        savePatients();
      });
    }
  }

  // **Search for a Patient**
  void searchPatients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPatients = List.from(patientArr);
      } else {
        filteredPatients = patientArr
            .where((patient) =>
            patient["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // **Add New Patient**
  void addNewPatient() {
    TextEditingController nameController = TextEditingController();
    TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Patient"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Patient Name"),
              ),
              TextField(
                controller: idController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Patient ID"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    idController.text.isNotEmpty) {
                  setState(() {
                    patientArr.add({
                      "name": nameController.text,
                      "image": null,
                      "id": idController.text,
                    });
                    filteredPatients = List.from(patientArr);
                    savePatients();
                  });
                }
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // **Return Patient from Discharged List to Home**
  void returnPatientToHome(Map<String, dynamic> patient) {
    setState(() {
      dischargedPatients.removeWhere((p) => p["id"] == patient["id"]);
      patientArr.add(patient);
      savePatients();
      saveDischargedPatients();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Patient returned to Home"),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
  // **Discharge Patient**
  void dischargePatient(Map<String, dynamic> patient) {
    setState(() {
      patientArr.removeWhere((p) => p["id"] == patient["id"]);
      dischargedPatients.add(patient);
      filteredPatients = List.from(patientArr);
      savePatients();
      saveDischargedPatients();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Patient discharged"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // **Slide-to-Delete Patient**
  void deletePatient(int index) {
    int realIndex = patientArr.indexWhere((p) => p["id"] == filteredPatients[index]["id"]);

    if (realIndex != -1) {
      setState(() {
        lastDeletedPatient = Map.from(patientArr[realIndex]);
        lastDeletedIndex = realIndex;

        patientArr.removeAt(realIndex);
        filteredPatients = List.from(patientArr);
        savePatients();
      });

      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Patient record deleted"),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          action: SnackBarAction(
            label: "Undo",
            onPressed: undoDeletePatient,
          ),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // **Undo Delete**
  void undoDeletePatient() {
    if (lastDeletedPatient != null && lastDeletedIndex != -1) {
      setState(() {
        patientArr.insert(lastDeletedIndex, lastDeletedPatient!);
        filteredPatients = List.from(patientArr);
        savePatients();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: addNewPatient,
                      icon: Icon(Icons.add, size: 28, color: TColor.primary),
                    ),
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              unreadNotifications = 0;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const NotificationsView()));
                          },
                          icon: Icon(Icons.notifications,
                              size: 28, color: TColor.primary),
                        ),
                        if (unreadNotifications > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                unreadNotifications.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RoundTextfield(
                  hintText: "Search Patient",
                  controller: txtSearch,
                  onChanged: searchPatients,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Icon(Icons.search, color: TColor.primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredPatients.length,
              itemBuilder: (context, index) {
                var patient = filteredPatients[index];

                return Dismissible(
                  key: Key(patient["id"].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    deletePatient(index);
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(patient["name"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Patient ID: ${patient["id"]}"),
                      trailing:
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientScreen(
                                patient: patient,
                                onUpdate: updatePatient,
                                onDischarge: dischargePatient,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DischargeScreen(
                        dischargedPatients: dischargedPatients,
                        onReturnToHome: returnPatientToHome,)));
        },
        backgroundColor: TColor.primary,
        child: const Icon(Icons.local_hospital),
      ),
    );
  }
}






