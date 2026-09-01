import 'package:agitha/ControllersFolder/AddViewJobVaccancyController.dart';


import 'package:agitha/ModelsFoder/AddJobVacancyModel.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AddJobVaccancy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditJobVaccancy extends StatefulWidget {
  const EditJobVaccancy({super.key});

  @override
  State<EditJobVaccancy> createState() => _EditJobVaccancyState();
}

class _EditJobVaccancyState extends State<EditJobVaccancy> {
  // bool _isExpanded = false;

  // ✅ Delete confirmation dialog
  void _showDeleteDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job'),
        content: const Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),

            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<AddJobVaccancyProvider>(context, listen: false)
                  .deleteJobVacancy(documentId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Job deleted successfully")),
              );
            },
            child:  Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<AddJobVaccancyProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Opened Job Vacancies"),
        centerTitle: true,
      
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           

            // ✅ Stream of jobs
            StreamBuilder<List<AddJobVaccancys>>(
              stream: jobProvider.getJobVacanciesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      "No job vacancies found.",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final jobs = snapshot.data!;
                return ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];

                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        title: Text(
                          job.jobTitle.toString(),
                          style: GoogleFonts.tinos(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        // subtitle: _isExpanded
                        //     ? null
                        //     :
                         
                        leading: Text(
                          "${index + 1}.",
                          style: GoogleFonts.tinos(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      
                        childrenPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text("Job Code: ",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(job.jobCode.toString())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text("Job Type: ",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(job.jobType.toString())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text("Department: ",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(job.department.toString())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text("Location: ",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(job.jobLocation.toString())),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Text("Salary: ",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(child: Text(job.salaryRange.toString())),
                              ],
                            ),
                          ),
                      
                          // Job Description
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "JOB DESCRIPTION",
                                style: GoogleFonts.tinos(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              job.jobDescription.toString(),
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                      
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "RESPONSIBILITIES",
                                style: GoogleFonts.tinos(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              job.jobResponsibility.toString(),
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                      
                          Padding(
                            padding: const EdgeInsets.only(top: 12, bottom: 4),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "REQUIREMENTS",
                                style: GoogleFonts.tinos(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              job.jobRequirements.toString(),
                              style: const TextStyle(fontSize: 16, height: 1.5),
                              textAlign: TextAlign.justify,
                            ),
                          ),


                            /// ACTION BUTTONS ROW
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        OutlinedButton(
                        onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddJobVaccancy(
                              documentId: job.documentId,
                              jobTitle: job.jobTitle,
                              jobCode: job.jobCode,
                              jobType: job.jobType,
                              jobLocation: job.jobLocation,
                              jobDescription: job.jobDescription,
                              jobRequirements: job.jobRequirements,
                              jobResponsibility: job.jobResponsibility,
                              department: job.department,
                              salaryRange: job.salaryRange,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: colorScheme.primary, // Outline color
                          width: 1.5,                    // Thickness of the border
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: colorScheme.primary, // Text color matches outline
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )                    ,                    


                                              const SizedBox(width: 10),
                                              ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              _showDeleteDialog(
                                  context, job.documentId.toString());
                            },
                            child: const Text(
                              "Delete",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),


                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),

      // ✅ Add Job button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 45,
        width: 230,
        child: FloatingActionButton.extended(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddJobVaccancy()),
            );
          },
          label: Text(
            "Add Job Vacancy",
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
