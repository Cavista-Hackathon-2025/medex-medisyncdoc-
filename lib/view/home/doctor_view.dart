import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  int _currentTabIndex = 0;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();

  List<String> voiceNotes = [];
  List<String> bodyCamVideos = [];
  bool _isRecordingVoice = false;
  bool _isRecordingVideo = false;
  int voiceCounter = 1;
  int videoCounter = 1;
  String? profileImagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isSaved = false; // Track if the doctor profile is saved

  @override
  void dispose() {
    noteController.dispose();
    prescriptionController.dispose();
    doctorNameController.dispose();
    super.dispose();
  }

  // Pick or take a profile picture
  void _pickProfileImage() {
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
                    profileImagePath = pickedFile.path;
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
                    profileImagePath = pickedFile.path;
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

  // Save doctor profile and return to patient screen
  void _saveDoctorProfile() {
    if (doctorNameController.text.isNotEmpty) {
      setState(() {
        _isSaved = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${doctorNameController.text} has been saved to patient records"),
          duration: const Duration(seconds: 2),
        ),
      );

      // Simulate returning to patient screen after save
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  Widget _buildTopBar() {
    final tabs = ["Note", "Voice Note", "Body Cam", "Prescription"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(tabs.length, (index) {
        bool isSelected = _currentTabIndex == index;
        return Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _currentTabIndex = index;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 2,
                  color: isSelected ? Colors.blue : Colors.transparent,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildContent() {
    switch (_currentTabIndex) {
      case 0:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: noteController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Write your note here...",
              border: OutlineInputBorder(),
            ),
          ),
        );
      case 1:
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: voiceNotes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.mic),
                    title: Text(voiceNotes[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        );
      case 2:
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bodyCamVideos.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.videocam),
                    title: Text(bodyCamVideos[index]),
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        );
      case 3:
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: prescriptionController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: "Write prescription here...",
              border: OutlineInputBorder(),
            ),
          ),
        );
      default:
        return Container();
    }
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
      if (!_isRecordingVoice) {
        voiceNotes.add("Voice Note #$voiceCounter");
        voiceCounter++;
      }
    });
  }

  void _toggleVideoRecording() {
    setState(() {
      _isRecordingVideo = !_isRecordingVideo;
      if (!_isRecordingVideo) {
        bodyCamVideos.add("Video Recording #$videoCounter");
        videoCounter++;
      }
    });
  }

  Widget? _buildFloatingActionButton() {
    if (_currentTabIndex == 1) {
      return FloatingActionButton(
        onPressed: _toggleVoiceRecording,
        backgroundColor: _isRecordingVoice ? Colors.red : Colors.blue,
        child: Icon(_isRecordingVoice ? Icons.stop : Icons.mic),
      );
    } else if (_currentTabIndex == 2) {
      return FloatingActionButton(
        onPressed: _toggleVideoRecording,
        backgroundColor: _isRecordingVideo ? Colors.red : Colors.blue,
        child: Icon(_isRecordingVideo ? Icons.stop : Icons.videocam),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove Back Arrow
        title: const Text("Doctor Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check), // Mark Icon instead of Save
            onPressed: _saveDoctorProfile,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: Column(
        children: [
          // Profile icon and doctor name
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: profileImagePath != null ? FileImage(File(profileImagePath!)) : null,
                    child: profileImagePath == null ? const Icon(Icons.camera_alt, size: 40) : null,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: doctorNameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: "Enter Doctor Name",
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          _buildTopBar(),
          const Divider(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
