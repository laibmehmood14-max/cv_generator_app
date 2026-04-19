import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() => runApp(
  MaterialApp(debugShowCheckedModeBanner: false, home: FinalCVGenerator()),
);

class FinalCVGenerator extends StatefulWidget {
  @override
  _FinalCVGeneratorState createState() => _FinalCVGeneratorState();
}

class _FinalCVGeneratorState extends State<FinalCVGenerator> {
  // Controllers
  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final github = TextEditingController();
  final objective = TextEditingController();
  final education = TextEditingController();
  final skills = TextEditingController();
  final experience = TextEditingController();
  final certificates = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Uint8List> _createPdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    final profileImage = _image != null
        ? pw.MemoryImage(_image!.readAsBytesSync())
        : null;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section (Image + Personal Info)
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (profileImage != null)
                    pw.ClipOval(
                      child: pw.Image(
                        profileImage,
                        width: 80,
                        height: 80,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          name.text.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey900,
                          ),
                        ),
                        pw.Text(
                          "Phone: ${phone.text} | Email: ${email.text}",
                          style: pw.TextStyle(fontSize: 10),
                        ),
                        pw.Text(
                          "Location: ${city.text} | GitHub: ${github.text}",
                          style: pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 2, color: PdfColors.blueGrey900),
              pw.SizedBox(height: 15),

              // Body Content
              _pdfSection("OBJECTIVE", objective.text),
              _pdfSection("EDUCATION", education.text),
              _pdfSection("SKILLS", skills.text),
              _pdfSection("EXPERIENCE", experience.text),
              _pdfSection("CERTIFICATES", certificates.text),
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget _pdfSection(String title, String content) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(bottom: 15),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey800,
            ),
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 5),
          pw.Text(content, style: pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Professional CV Builder"),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.blueGrey)
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Text("Add Photo", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            _input(name, "Full Name"),
            _input(phone, "Phone"),
            _input(email, "Email"),
            _input(city, "City"),
            _input(github, "GitHub Profile"),
            _input(objective, "Objective/Summary", lines: 3),
            _input(education, "Education", lines: 3),
            _input(skills, "Skills", lines: 2),
            _input(experience, "Experience", lines: 4),
            _input(certificates, "Certificates", lines: 2),

            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.blueGrey[900],
                foregroundColor: Colors.white,
              ),
              onPressed: () =>
                  Printing.layoutPdf(onLayout: (format) => _createPdf(format)),
              child: Text("GENERATE CV"),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    int lines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
