import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  // 0: Note, 1: Voice Note, 2: Body Cam, 3: Prescription
  int _currentTabIndex = 0;

  // Controllers for text input areas
  final TextEditingController noteController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();

  // Lists to hold voice notes and video recordings
  List<String> voiceNotes = [];
  List<String> bodyCamVideos = [];

  // Recording states
  bool _isRecordingVoice = false;
  bool _isRecordingVideo = false;
  int voiceCounter = 1;
  int videoCounter = 1;

  @override
  void dispose() {
    noteController.dispose();
    prescriptionController.dispose();
    super.dispose();
  }

  // Build the top bar with the four menu options
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

  // Build the content area based on the selected tab
  Widget _buildContent() {
    switch (_currentTabIndex) {
      case 0: // Note section with a text area
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
      case 1: // Voice Note section with a list and space for the record button
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
            const SizedBox(height: 80), // leave space for record button
          ],
        );
      case 2: // Body Cam section with a list and space for the record button
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
            const SizedBox(height: 80), // leave space for record button
          ],
        );
      case 3: // Prescription section with a text area
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

  // Toggle voice recording simulation
  void _toggleVoiceRecording() {
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
      if (!_isRecordingVoice) {
        // When stopped, add a new voice note placeholder
        voiceNotes.add("Voice Note #$voiceCounter");
        voiceCounter++;
      }
    });
  }

  // Toggle video recording simulation for body cam
  void _toggleVideoRecording() {
    setState(() {
      _isRecordingVideo = !_isRecordingVideo;
      if (!_isRecordingVideo) {
        // When stopped, add a new video placeholder
        bodyCamVideos.add("Video Recording #$videoCounter");
        videoCounter++;
      }
    });
  }

  // Show a record button only on the Voice Note or Body Cam sections
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
        title: const Text("Doctor Profile"),
        centerTitle: true,
      ),
      floatingActionButton: _buildFloatingActionButton(),
      body: Column(
        children: [
          // Profile icon and doctor name
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  "Dr. John Doe",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Top bar menu
          _buildTopBar(),
          const Divider(),
          // Content based on selected tab
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}
