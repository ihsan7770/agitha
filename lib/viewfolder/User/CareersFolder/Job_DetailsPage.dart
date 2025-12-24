import 'package:agitha/ControllersFolder/AddViewJobVaccancyController.dart';
import 'package:agitha/ModelsFoder/AddJobVacancyModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


class JobDetailsPage extends StatelessWidget {
  final String documentId;

  const JobDetailsPage({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<AddJobVaccancyProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(  ),
      body: FutureBuilder<AddJobVaccancys?>(
        future: provider.getJobById(documentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Job details not found"));
          }

          final job = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BASIC DETAILS
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "BASIC DETAILS",
                    style: GoogleFonts.tinos(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Job Title: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.jobTitle ?? "N/A")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Job Code: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.jobCode ?? "N/A")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Department: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.department ?? "N/A")),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Job Type: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.jobType ?? "N/A")),
                    ],
                  ),
                ),

                  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Salary: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.salaryRange ?? "N/A")),
                    ],
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text("Location: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(child: Text(job.jobLocation.toString() ?? "")),
                    ],
                  ),
                ),

                // JOB DESCRIPTION
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "JOB DESCRIPTION",
                    style: GoogleFonts.tinos(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    job.jobDescription ??
                        "No description provided for this job.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Responsibilities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    job.jobResponsibility ?? "No responsibilities listed.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Requirements",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    job.jobRequirements ?? "No requirements listed.",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
