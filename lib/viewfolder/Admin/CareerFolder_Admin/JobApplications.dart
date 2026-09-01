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
    
          final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Applications"),
        centerTitle: true,

      ),
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

          return 
          

ListView(
  padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
  children: [
    ...applications.map((app) {
      return Container(
        margin: EdgeInsets.only(bottom: screenHeight * 0.025), // responsive spacing
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title
              Text(
                "Application for ${app.appliedJob}",
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.055,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
              SizedBox(height: screenHeight * 0.008),

              // Name
              Text(
                app.fullName,
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Email & Phone
              Text(
                app.email,
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ),
              Text(
                app.phone,
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.045,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: screenHeight * 0.008),

              // Address
              Text(
                "Address",
                style: GoogleFonts.tinos(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                app.address,
                style: TextStyle(
                  fontSize: screenWidth * 0.042,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify,
              ),

              SizedBox(height: screenHeight * 0.015),

              // View & Download CV buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: colorScheme.primary, width: screenWidth * 0.003),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.012,
                      ),
                    ),
                    onPressed: () => _showCvPopup(app.resumeFileName),
                    child: Text(
                      "View CV",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: screenWidth * 0.042,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.012,
                      ),
                    ),
                    onPressed: () => _downloadCv(app.resumeFileName),
                    child: Text(
                      "Download CV",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.042,
                      ),
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
