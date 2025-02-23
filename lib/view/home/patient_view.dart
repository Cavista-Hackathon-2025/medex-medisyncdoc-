import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'doctor_view.dart';
import '../../common_widget/round_button.dart';
import '../../common/color_extension.dart';

class PatientScreen extends StatefulWidget {
  final Map<String, dynamic> patient;
  final Function(Map<String, dynamic>) onUpdate;
  final Function(Map<String, dynamic>) onDischarge;

  const PatientScreen({
    super.key,
    required this.patient,
    required this.onUpdate,
    required this.onDischarge,
  });

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  late TextEditingController nameController;
  late TextEditingController idController;
  String? imagePath;
  List<String> doctors = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.patient["name"] ?? "");
    idController = TextEditingController(text: widget.patient["id"] ?? "");
    imagePath = widget.patient["image"];
    doctors = List<String>.from(widget.patient["doctors"] ?? []);
  }

  // **Pick Image Function**
  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text("Take Photo"),
              onTap: () async {
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  setState(() {
                    imagePath = pickedFile.path;
                  });
                }
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Choose from Gallery"),
              onTap: () async {
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    imagePath = pickedFile.path;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // **Edit Name & ID**
  void editField(TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Information"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new value"),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // **Save Patient Changes**
  void saveChanges() {
    setState(() {
      widget.onUpdate({
        "name": nameController.text,
        "id": idController.text,
        "image": imagePath,
        "doctors": doctors,
      });
    });
    Navigator.pop(context);
  }

  // **Discharge Patient**
  void dischargePatient() {
    widget.onDischarge(widget.patient);
    Navigator.pop(context);
  }

  // **Add New Doctor**
  Future<void> addDoctor() async {
    final String? newDoctor = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DoctorProfileScreen()),
    );

    if (newDoctor != null && newDoctor.isNotEmpty) {
      setState(() {
        doctors.add(newDoctor);
      });
    }
  }

  // **Delete Doctor with Swipe Effect**
  void deleteDoctor(int index) {
    setState(() {
      doctors.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Doctor removed"),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Applying theme color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // **Profile Section with "Add Doctor" Button**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Text(
                  "Patient",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 28, color: Colors.blue),
                  onPressed: addDoctor,
                ),
              ],
            ),

            // **Patient Image & Picker**
            const SizedBox(height: 2),
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                child: imagePath == null || imagePath!.isEmpty
                    ? const Icon(Icons.person, size: 50, color: Colors.black)
                    : ClipOval(
                  child: Image.file(
                    File(imagePath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // **Patient Name & Patient ID**
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      nameController.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () => editField(nameController),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Patient ID: ${idController.text}",
                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () => editField(idController),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // **Treatment Title**
            const Text(
              "Doctors Assigned",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            // **Doctor Cards (Added when Save Button is Clicked in Doctor Screen)**
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorProfileScreen(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.local_hospital, color: Colors.blue),
                        title: Text(
                          doctors[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // **Save & Discharge Buttons**
            Row(
              children: [
                Expanded(
                  child: RoundButton(
                    title: "Save Changes",
                    onPressed: saveChanges,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RoundButton(
                    title: "Discharge",
                    onPressed: dischargePatient,
                    type: RoundButtonType.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
