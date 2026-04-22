import 'dart:io';
import 'package:flutter/material.dart';
import '../view_models/cv_view_model.dart'; // ViewModel ko link karne ke liye

class CVFormScreen extends StatefulWidget {
  @override
  _CVFormScreenState createState() => _CVFormScreenState();
}

class _CVFormScreenState extends State<CVFormScreen> {
  // ViewModel ka instance banaya taake hum logic use kar sakein
  final CVViewModel vm = CVViewModel();
  File? _displayImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professional CV Builder (MVVM)"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // --- Image Picker UI ---
            GestureDetector(
              onTap: () async {
                File? img = await vm.pickImage();
                if (img != null) {
                  setState(() {
                    _displayImage = img;
                  });
                }
              },
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: _displayImage != null
                    ? FileImage(_displayImage!)
                    : null,
                child: _displayImage == null
                    ? Icon(Icons.add_a_photo, size: 40, color: Colors.blueGrey)
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tap to add Photo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // --- Input Fields (Using ViewModel Controllers) ---
            _input(vm.nameController, "Full Name"),
            _input(vm.phoneController, "Phone Number"),
            _input(vm.emailController, "Email Address"),
            _input(vm.cityController, "City/Location"),
            _input(vm.githubController, "GitHub/Portfolio Link"),
            _input(vm.objectiveController, "Professional Objective", lines: 3),
            _input(vm.educationController, "Education Details", lines: 3),
            _input(vm.skillsController, "Core Skills", lines: 2),
            _input(vm.experienceController, "Work Experience", lines: 4),
            _input(vm.certificateController, "Certificates & Awards", lines: 2),

            SizedBox(height: 30),

            // --- Action Button ---
            ElevatedButton.icon(
              icon: Icon(Icons.picture_as_pdf),
              label: Text("GENERATE & PRINT CV"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.blueGrey[900],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // ViewModel ka function call ho raha hai
                vm.generateAndPrintPDF();
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Reusable Input Widget
  Widget _input(
    TextEditingController controller,
    String label, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey[700]),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueGrey, width: 2),
          ),
        ),
      ),
    );
  }
}
