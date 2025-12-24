import 'dart:io';
import 'dart:typed_data';
import 'package:agitha/ControllersFolder/JobApplicationController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:flutter/services.dart' show rootBundle;

class JobForm extends StatefulWidget {
  final String appliedJobTitle;

  const JobForm({super.key, required this.appliedJobTitle});

  @override
  State<JobForm> createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _resumeFile;
  bool _isLoading = false;

  // ✅ Pick Resume File
  Future<void> _pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  // ✅ Submit Job Application (Upload + Firestore + Email)
  Future<void> _submitForm() async {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_formKey.currentState!.validate()) return;

    if (_resumeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload a resume"),
          backgroundColor: colorScheme.primary,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
  
      final jobController = JobApplicationController();

      // ✅ Upload resume + Submit Firestore entry in one step
      await jobController.uploadAndSubmitApplication(
        resumeFile: _resumeFile!,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
        appliedJob: widget.appliedJobTitle,
      );

      // ✅ Send confirmation email
      await _sendEmail(
        recipientEmail: _emailController.text.trim(),
        fullName: _nameController.text.trim(),
        jobTitle: widget.appliedJobTitle,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Job Application submitted successfully!"),
          backgroundColor: colorScheme.primary,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: colorScheme.primary,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Send Email Confirmation
  Future<void> _sendEmail({
    required String recipientEmail,
    required String fullName,
    required String jobTitle,
  }) async {
    const String username = 'mohammedihsankp600@gmail.com';
    const String password = 'xapt numz rrac dzvq'; // Gmail App Password

    final smtpServer = gmail(username, password);

    // Load banner image from assets
    final Uint8List bannerBytes =
        (await rootBundle.load('assets/agithabg.jpg')).buffer.asUint8List();

    const String bannerCid = '<banner@agitha>';

    final message = Message()
      ..from = Address(username, 'Agitha Jobs')
      ..recipients.add(recipientEmail)
      ..subject = 'Job Application Confirmation - $jobTitle'
      ..html = '''
        <div style="font-family: Arial, sans-serif; color: #333;">
          <p>Dear <b>$fullName</b>,</p>
          <p>Thank you for applying for the "<b>$jobTitle</b>" position at Agitha.</p>
          <p>We have received your application successfully. Our team will review it and get back to you soon.</p>

          <p>Best Regards,<br>
          <b>Agitha Recruitment Team</b><br>
          <small style="color: gray;">This is an automated message. Please do not reply.</small></p>

          <div style="text-align:center; margin-top: 20px;">
            <img src="cid:banner@agitha"
                 alt="Agitha Banner"
                 style="width:100%; max-width:600px; border-radius:10px;" />
          </div>
        </div>
      ''';

    final bannerAttachment = StreamAttachment(
      Stream.fromIterable([bannerBytes]),
      'image/jpeg',
      fileName: 'agithabg.jpg',
    )
      ..cid = bannerCid
      ..location = Location.inline;

    message.attachments.add(bannerAttachment);

    try {
      await send(message, smtpServer);
      debugPrint('✅ Email with inline banner sent to $recipientEmail');
    } on MailerException catch (e) {
      debugPrint('❌ Email sending failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
       

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "JOB APPLICATION FORM",
                      style: GoogleFonts.tinos(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 75, 2, 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 👤 Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter your full name" : null,
                ),
                const SizedBox(height: 16),

                // 📞 Phone
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value!.isEmpty ? "Enter your phone number" : null,
                ),
                const SizedBox(height: 16),

                // 📧 Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      value!.isEmpty ? "Enter your email" : null,
                ),
                const SizedBox(height: 16),

                // 🏠 Address
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? "Enter your address" : null,
                ),
                const SizedBox(height: 16),

                // 📄 Resume Upload
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickResume,
                      icon: const Icon(Icons.upload_file),
                      label: const Text("Upload Resume"),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _resumeFile != null
                            ? _resumeFile!.path.split('/').last
                            : "No file selected",
                        style: const TextStyle(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colorScheme.primary,
                          width: 1.5,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          _isLoading
                              ? Colors.grey[400]
                              : colorScheme.primary,
                        ),
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
