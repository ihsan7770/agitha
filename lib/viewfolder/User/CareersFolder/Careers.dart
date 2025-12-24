
import 'package:agitha/ControllersFolder/AddViewJobVaccancyController.dart';
import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ModelsFoder/AddJobVacancyModel.dart';

import 'package:agitha/viewfolder/User/CareersFolder/Job_DetailsPage.dart';
import 'package:agitha/viewfolder/User/CareersFolder/Job_Form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CareersPage extends StatelessWidget {
  const CareersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = (screenWidth * 0.055).clamp(18.0, 28.0);
    double subtitleFontSize = (screenWidth * 0.045).clamp(14.0, 22.0);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Header image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/projectimages/Career.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Title and subtitle
            Text(
              "CAREER OPPORTUNITIES",
              style: GoogleFonts.tinos(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "JOB OPENINGS",
              style: GoogleFonts.tinos(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(245, 158, 158, 158),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // ✅ Stream builder for job vacancies
            Consumer<AddJobVaccancyProvider>(
              builder: (context, provider, child) {
                return StreamBuilder<List<AddJobVaccancys>>(
                  stream: provider.getJobVacanciesStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error loading job vacancies"),
                      );
                    }

                    final jobs = snapshot.data ?? [];
                    if (jobs.isEmpty) {
                      return const Center(
                        child: Text("No job vacancies available right now."),
                      );
                    }

                    // ✅ Display each job in a card
                    return Column(
                      children: jobs.map((job) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailsPage(
                                  documentId: job.documentId.toString(),
                              
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Job Title",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  job.jobTitle.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Brand Name",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                 " Agitha",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      bool loggedIn =
                                          Provider.of<AuthenticationController>(
                                                  context,
                                                  listen: false)
                                              .checkLogin(context);

                                      if (loggedIn) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => JobForm(
                                              appliedJobTitle: job.jobTitle.toString(),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Apply",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
