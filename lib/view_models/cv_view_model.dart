import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/cv_data.dart';

class CVViewModel {
  // Model ka instance
  final CVData data = CVData();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final cityController = TextEditingController();
  final githubController = TextEditingController();
  final objectiveController = TextEditingController();
  final educationController = TextEditingController();
  final skillsController = TextEditingController();
  final experienceController = TextEditingController();
  final certificateController = TextEditingController();

  // Image Picking Logic
  Future<File?> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      data.profileImage = File(pickedFile.path);
      return data.profileImage;
    }
    return null;
  }

  // PDF Generation Logic
  Future<void> generateAndPrintPDF() async {
    final pdf = pw.Document();
    final profileImage = data.profileImage != null
        ? pw.MemoryImage(data.profileImage!.readAsBytesSync())
        : null;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header (Image + Personal Info)
            pw.Row(
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
                        nameController.text.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        "${emailController.text} | ${phoneController.text}",
                      ),
                      pw.Text("GitHub: ${githubController.text}"),
                    ],
                  ),
                ),
              ],
            ),
            pw.Divider(),
            _buildPdfSection("OBJECTIVE", objectiveController.text),
            _buildPdfSection("EDUCATION", educationController.text),
            _buildPdfSection("SKILLS", skillsController.text),
            _buildPdfSection("EXPERIENCE", experienceController.text),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  pw.Widget _buildPdfSection(String title, String content) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Text(content),
          pw.SizedBox(height: 10),
        ],
      ),
    );
  }
}
