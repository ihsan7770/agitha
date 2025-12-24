import 'package:agitha/ControllersFolder/JobApplicationController.dart';
import 'package:agitha/ModelsFoder/JobApplicationModel.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AdminViewJobVaccancy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplications extends StatefulWidget {
  const JobApplications({super.key});

  @override
  State<JobApplications> createState() => _JobApplicationsState();
}

class _JobApplicationsState extends State<JobApplications> {
  bool loading = false;

  // ✅ Show CV in popup (from stored resumeUrl)
  void _showCvPopup(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          height: 600,
          width: 450,
          child: SfPdfViewer.network(url),
        ),
      ),
    );
  }

  // ✅ Open CV in browser for download
  Future<void> _downloadCv(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading CV: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobController =
        Provider.of<JobApplicationController>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<JobApplicationModel>>(
        stream: jobController.getAllJobApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No applications found.'));
          }

          final applications = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                "Job Applications",
                style: GoogleFonts.tinos(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              ...applications.map((app) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(4, 4),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Application for ${app.appliedJob}",
                          style: GoogleFonts.tinos(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          app.fullName,
                          style: GoogleFonts.tinos(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(app.email,
                            style: GoogleFonts.tinos(
                                fontSize: 17, color: Colors.black)),
                        Text(app.phone,
                            style: GoogleFonts.tinos(
                                fontSize: 17, color: Colors.black)),
                        const SizedBox(height: 8),
                        Text(
                          "Address",
                          style: GoogleFonts.tinos(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          app.address,
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 16),

                        // ✅ View and Download CV buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: colorScheme.primary, width: 1.5),
                              ),
                              onPressed: () => _showCvPopup(app.resumeFileName),
                              child: Text(
                                "View CV",
                                style: TextStyle(color: colorScheme.primary),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                              ),
                              onPressed: () => _downloadCv(app.resumeFileName),
                              child: const Text(
                                "Download CV",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 40,
        width: 200,
        child: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditJobVaccancy()),
            );
          },
          label: Text(
            "Current Vacancies",
            style: GoogleFonts.tinos(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
