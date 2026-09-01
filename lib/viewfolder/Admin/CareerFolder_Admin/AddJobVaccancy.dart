import 'package:agitha/ControllersFolder/AddViewJobVaccancyController.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AdminViewJobVaccancy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddJobVaccancy extends StatefulWidget {
 
 final String? documentId;
 final String? jobTitle;
 final String? jobCode;
 final String? jobType;
 final String? department;
 final String? jobResponsibility;
 final String? jobDescription;
 final String? jobRequirements;
 final String? jobLocation;
 final String? salaryRange; 

  const AddJobVaccancy({
    super.key,
    this.documentId,
    this.jobTitle,
    this.jobCode,
    this.jobType,
    this.department,
    this.jobResponsibility,
    this.jobDescription,
    this.jobRequirements,
    this.jobLocation,
    this.salaryRange, 
 
    });

  @override
  State<AddJobVaccancy> createState() => _AddJobVaccancyState();
}

class _AddJobVaccancyState extends State<AddJobVaccancy> {

 bool get isEditMode => widget.documentId != null;
     final _formKey = GlobalKey<FormState>();
    final TextEditingController _JobTitleController = TextEditingController();
    final TextEditingController _JobCodeController = TextEditingController();
     final TextEditingController _DepartmentController = TextEditingController();
     final TextEditingController _LocationController = TextEditingController();
      final TextEditingController _SalaryRangeController = TextEditingController();
      final TextEditingController _DescriptionController = TextEditingController();
      final TextEditingController _ResponsibilityController = TextEditingController();
       final TextEditingController _RequrementsController = TextEditingController();
 



  String? _selectedRole;
  final List<String> _roles = ["Full Time", "Permanent", "Temporary"];
 void _showSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
      ),
    );
  }


Future<void> submitJobDetails() async {
  final provider = Provider.of<AddJobVaccancyProvider>(context, listen: false);

  if (!_formKey.currentState!.validate()) return;

  try {
    if (isEditMode) {
      // 🔹 Update existing job
      await provider.updateJobVacancy(
        documentId: widget.documentId!,
        updatedData: {
          "jobTitle": _JobTitleController.text.trim(),
          "jobCode": _JobCodeController.text.trim(),
          "department": _DepartmentController.text.trim(),
          "jobDescription": _DescriptionController.text.trim(),
          "jobLocation": _LocationController.text.trim(),
          "jobRequirements": _RequrementsController.text.trim(),
          "jobResponsibility": _ResponsibilityController.text.trim(),
          "jobType": _selectedRole ?? widget.jobType,
          "salaryRange": _SalaryRangeController.text.trim(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job updated successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EditJobVaccancy()),
        );
      }
    } else {
      // 🔹 Add new job
      await provider.addjobvaccacy(
        jobTitle: _JobTitleController.text.trim(),
        jobCode: _JobCodeController.text.trim(),
        department: _DepartmentController.text.trim(),
        jobDescription: _DescriptionController.text.trim(),
        jobLocation: _LocationController.text.trim(),
        jobRequirements: _RequrementsController.text.trim(),
        jobResponsibility: _ResponsibilityController.text.trim(),
        jobType: _selectedRole!,
        salaryRange: _SalaryRangeController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Job added successfully")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EditJobVaccancy()),
        );
      }
    }
  } catch (e) {
    _showSnackBar("An error occurred: $e");
  }
}



  @override
  void initState() {
    super.initState();
    _JobTitleController.text = widget.jobTitle ?? "";
    _JobCodeController.text = widget.jobCode ?? "";
    _DepartmentController   .text = widget.department ?? "";
    _SalaryRangeController  .text  =  widget.salaryRange ?? "";
    _DescriptionController  .text = widget.jobDescription ?? "";
    _ResponsibilityController.text = widget.jobResponsibility ?? "";
    _RequrementsController  .text = widget.jobRequirements ?? "";
    _LocationController.text=widget.jobLocation ?? '';
    _selectedRole = widget.jobType;
  }

  @override
  void dispose() {                                             
      _JobTitleController .dispose();    
    _JobCodeController  .dispose();       
    _DepartmentController   .dispose();   
    _SalaryRangeController  .dispose();
    _DescriptionController   .dispose();
    _ResponsibilityController .dispose(); 
    _RequrementsController  .dispose();
    
    super.dispose();
  }

  



  @override
  Widget build(BuildContext context) {
    final jobprovider =
        Provider.of<AddJobVaccancyProvider>(context);
    

   final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return  Scaffold(
      appBar: AppBar(
      title:  Text(
                  isEditMode ? "Edit job vaccancy" : "Add job vaccancy", ),
                  centerTitle: true,
                  ),
                  
      body: SingleChildScrollView(
        child: Column(
          children: [
        
              Align(
              alignment: Alignment.topLeft,
               child: Padding(
                   padding: const EdgeInsets.only(left: 16.0,),
                   child: Text(
                         "Basic Details",
                         style: GoogleFonts.tinos(
                           fontSize: 25,
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                         ),
                       ),
                 ),
             ),

              Form(
                key: _formKey  ,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                                 controller:_JobTitleController,
                                   decoration: const InputDecoration(
                                     labelText: "Job title",
                                     alignLabelWithHint: true,
                                       border: OutlineInputBorder(),
                                   ),
                                   
                                   validator: (value) {
                                     if (value == null || value.isEmpty) {
                                       return "Enter the Job title";
                                     }
                                     return null;
                                   },
                                 ),
                                 const SizedBox(height: 10,),
                      
                                    TextFormField(
                                   controller: _JobCodeController ,
                                   keyboardType: TextInputType.number,
                                   decoration: const InputDecoration(
                                     labelText: "Job Code",
                                     alignLabelWithHint: true,
                                       border: OutlineInputBorder(),
                                   ),
                                   
                                   validator: (value) {
                                     if (value == null || value.isEmpty) {
                                       return "Enter the Job Code";
                                     }
                                     return null;
                                   },
                                 ),
                                  const SizedBox(height: 10,),
                      
                                 
                                    DropdownButtonFormField<String>(
                                  value: _selectedRole,
                                  decoration: const InputDecoration(
                                    labelText: "Select Job Type",
                                    border: OutlineInputBorder(),
                                  ),
                                  items: _roles
                                      .map((role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(role),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedRole = value;
                                    });
                                  },
                                  validator: (value) =>
                                      value == null ? "Please select a Job Type" : null,
                                ),
                                 const SizedBox(height: 10,),
                      
                                    TextFormField(
                                   controller:_DepartmentController,
                                   keyboardType: TextInputType.number,
                                   decoration: const InputDecoration(
                                     labelText: "Department",
                                     alignLabelWithHint: true,
                                       border: OutlineInputBorder(),
                                   ),
                                   
                                   validator: (value) {
                                     if (value == null || value.isEmpty) {
                                       return "Enter the Department";
                                     }
                                     return null;
                                   },
                                 ),
                                  const SizedBox(height: 10,),
                                   TextFormField(
                                   controller:_LocationController ,
                                   keyboardType: TextInputType.number,
                                   decoration: const InputDecoration(
                                     labelText: "Location",
                                     alignLabelWithHint: true,
                                       border: OutlineInputBorder(),
                                   ),
                                   
                                   validator: (value) {
                                     if (value == null || value.isEmpty) {
                                       return "Enter the Location";
                                     }
                                     return null;
                                   },
                                 ),
                                  const SizedBox(height: 10,),
                      
                                   TextFormField(
                                   controller:_SalaryRangeController,
                                   keyboardType: TextInputType.number,
                                   decoration: const InputDecoration(
                                     labelText: "Salary Range",
                                     alignLabelWithHint: true,
                                       border: OutlineInputBorder(),
                                   ),
                                   
                                   validator: (value) {
                                     if (value == null || value.isEmpty) {
                                       return "Enter the Salary Range";
                                     }
                                     return null;
                                   },
                                 ),
                                  const SizedBox(height: 20,),
                                  
                 Align(
              alignment: Alignment.topLeft,
               child: Text(
                     "Job Describtion",
                     style: GoogleFonts.tinos(
                       fontSize: 25,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                   ),
             ),


                  const SizedBox(height: 10,),

                       
                         TextFormField(
                    controller: _DescriptionController ,
                     decoration: const InputDecoration(
                       labelText: "Describtion",
                       alignLabelWithHint: true,
                         border: OutlineInputBorder(),
                     ),
                     maxLines: 5, 
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return "Enter the Describtion";
                       }
                       return null;
                     },
                   ),
                 
                  const SizedBox(height: 10,),

                      TextFormField(
                    controller: _ResponsibilityController,
                     decoration: const InputDecoration(
                       labelText: "Responsibility",
                       alignLabelWithHint: true,
                         border: OutlineInputBorder(),
                     ),
                     maxLines: 5, 
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return "Enter the Responsibility";
                       }
                       return null;
                     },
                   ),

                       const SizedBox(height: 10,),


                        TextFormField(
                    controller: _RequrementsController,
                     decoration: const InputDecoration(
                       labelText: "Requirements",
                       alignLabelWithHint: true,
                         border: OutlineInputBorder(),
                     ),
                     maxLines: 5, 
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return "Enter the Requirements";
                       }
                       return null;
                     },
                   ),                      
                    ],
                  ),
                ),
              ),
        
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                            padding: const EdgeInsets.only(left:16.0,right: 16.0,),
                            child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              
                              backgroundColor:  jobprovider .isLoading? Colors.grey[100]:colorScheme.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                              
                                onPressed: 
                               submitJobDetails,
                                                     
                           
                            child:jobprovider.isLoading? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                            
                            
                            : Text("Submit",
                              style: textTheme.bodyLarge
                                  ?.copyWith(color: Colors.white)),
                                                      ),
                                                    ),
                          ),

                          const SizedBox(height: 20,)
                            
        
        
        
        
        
        
        
          ],
        ),
      ),
    );
  }
}