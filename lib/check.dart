
// import 'package:agitha/ModelsFoder/StripePaymentClass.dart';
// import 'package:flutter/material.dart';


// class PaymentDemo extends StatelessWidget {
//   const PaymentDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Stripe Demo")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await PaymentService.makePayment(5000); // ₹50 (5000 paise)
//           },
//           child: const Text("Pay ₹50"),
//         ),
//       ),
//     );
//   }
// }





































// class FoodListPage extends StatefulWidget {
//   final String restaurantId;
//   const FoodListPage({super.key, required this.restaurantId});

//   @override
//   State<FoodListPage> createState() => _FoodListPageState();
// }

// class _FoodListPageState extends State<FoodListPage> {
//   final FoodItemsController _controller = FoodItemsController();

//   @override
//   void initState() {
//     super.initState();
//     _controller.fetchFoodItemsById(widget.restaurantId);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: _controller.foodStream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text("No food items found"));
//         }

//         final foodItems = snapshot.data!;

//         return GridView.builder(
//           padding: const EdgeInsets.all(12),
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: 0.9,
//           ),
//           itemCount: foodItems.length,
//           itemBuilder: (context, index) {
//             final item = foodItems[index];
//             return Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(2, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Image.network(item['imageUrl'], height: 100, fit: BoxFit.cover),
//                   Text(item['title'], style: const TextStyle(fontSize: 16)),
//                   Text("₹ ${item['price']}"),
//                 ],
//               ),
//             );
//           },
//         );




        
//       },
//     );
//   }
// }



// // import 'package:flutter/material.dart';

// // class ScrollableImageList extends StatelessWidget {
// //   const ScrollableImageList({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final List<String> imageUrls = [
// //       'https://picsum.photos/200/300',
// //       'https://picsum.photos/201/300',
// //       'https://picsum.photos/202/300',
// //       'https://picsum.photos/203/300',
// //       'https://picsum.photos/204/300',
// //     ];

// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Scrollable Image List")),
// //       body: SingleChildScrollView(
// //         scrollDirection: Axis.vertical,
// //         child: Column(
// //           children: [
// //             // Repeatable rows
// //             for (int i = 0; i < 3; i++) 
// //               Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 10),
// //                 child: SizedBox(
// //                   height: 120,
// //                   child: ListView.builder(
// //                     scrollDirection: Axis.horizontal,
// //                     itemCount: imageUrls.length,
// //                     itemBuilder: (context, index) {
// //                       return Padding(
// //                         padding: const EdgeInsets.symmetric(horizontal: 8),
// //                         child: Stack(
// //                           alignment: Alignment.bottomRight,
// //                           children: [
// //                             ClipRRect(
// //                               borderRadius: BorderRadius.circular(16),
// //                               child: Image.network(
// //                                 imageUrls[index],
// //                                 width: 120,
// //                                 height: 120,
// //                                 fit: BoxFit.cover,
// //                               ),
// //                             ),
// //                             Positioned(
// //                               bottom: 6,
// //                               right: 6,
// //                               child: Container(
// //                                 decoration: const BoxDecoration(
// //                                   color: Colors.white,
// //                                   shape: BoxShape.circle,
// //                                   boxShadow: [
// //                                     BoxShadow(
// //                                         color: Colors.black26,
// //                                         blurRadius: 4,
// //                                         offset: Offset(1, 1))
// //                                   ],
// //                                 ),
// //                                 child: IconButton(
// //                                   icon: const Icon(Icons.add, color: Colors.green),
// //                                   onPressed: () {
// //                                     // handle add action
// //                                   },
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }


















// // // import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
// // // import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/DeliveryBoyDetails.dart';
// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:provider/provider.dart';

// // // class ViewDeliveryBoys extends StatefulWidget {
// // //   const ViewDeliveryBoys({super.key});

// // //   @override
// // //   State<ViewDeliveryBoys> createState() => _ViewDeliveryBoysState();
// // // }

// // // class _ViewDeliveryBoysState extends State<ViewDeliveryBoys> {
// // //   @override
// // //    void initState() {
// // //     super.initState();
// // //     // Fetch data when screen opens - use addPostFrameCallback to ensure context is available
// // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // //       Provider.of<DeliveryBoyViewProvider>(context, listen: false);
// // //           // .fetchDeliveryBoyWithEmails();
// // //     });
// // //   }
// // //   Widget build(BuildContext context) {

// // // // final provider = Provider.of<DeliveryBoyViewProvider>(context);
       
       
// // //    // ❌ Decline Alert
// // //   void dbdeleteAlert(
// // //       BuildContext context, String docId, String deliveryboy) {
// // //             final colorScheme = Theme.of(context).colorScheme;
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('Reject Restaurant'),
// // //         content: Text('Are you sure you want to Reject $deliveryboy?'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text('Cancel'),
// // //           ),
// // //           TextButton(
// // //             onPressed: () async {
// // //               try {
// // //                 await Provider.of<DeliveryBoyViewProvider>(context, listen: false)
// // //                     .declineDeliveryBoy(docId);
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(content: Text('$deliveryboy rejected successfully'),
// // //                   backgroundColor: colorScheme.primary  ,
                  
// // //                   ),
// // //                 );
// // //                 await Provider.of<DeliveryBoyViewProvider>(context, listen: false);
// // //                     // .fetchDeliveryBoyWithEmails();
// // //                 setState(() {});
// // //               } catch (e) {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(content: Text('Error: $e')),
// // //                 );
// // //               }
// // //               Navigator.pop(context);
// // //             },
// // //             child: const Text('Reject'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   // ✅ Approve Alert
// // //   void dbApproveAlert(
// // //       BuildContext context, String docId, String deliveryboy) {
// // //     final colorScheme = Theme.of(context).colorScheme;
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         title: const Text('Approve Restaurant'),
// // //         content: Text('Are you sure you want to approve $deliveryboy?'),
// // //         actions: [
// // //           TextButton(
// // //             onPressed: () => Navigator.pop(context),
// // //             child: const Text('Cancel'),
// // //           ),
// // //           TextButton(
// // //             onPressed: () async {
// // //               try {
// // //                 await Provider.of<DeliveryBoyViewProvider>(context, listen: false)
// // //                     .approveDeliveryBoy(docId);
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(
// // //                     content: Text('$deliveryboy approved successfully'),
// // //                     backgroundColor: colorScheme.primary,
// // //                   ),
// // //                 );
// // //                 await Provider.of<DeliveryBoyViewProvider>(context, listen: false);
// // //                     // .fetchDeliveryBoyWithEmails();
// // //                 setState(() {});
// // //               } catch (e) {
// // //                 ScaffoldMessenger.of(context).showSnackBar(
// // //                   SnackBar(content: Text('Error: $e')),
// // //                 );
// // //               }
// // //               Navigator.pop(context);
// // //             },
// // //             child: const Text('Approve'),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }





// // //      final colorScheme = Theme.of(context).colorScheme;
// // //     return Scaffold(
// // //       appBar: AppBar(),
// // //       body: StreamBuilder<List<Map<String, dynamic>>>(
// // //   stream: Provider.of<DeliveryBoyViewProvider>(context, listen: false)
// // //      .streamPendingAndApprovedDeliveryBoys(),
// // //   builder: (context, snapshot) {
// // //     if (!snapshot.hasData) {
// // //       return const Center(child: CircularProgressIndicator());
// // //     }

// // //     final deliveryBoys = snapshot.data!;
// // //     return ListView.builder(
// // //                   padding: const EdgeInsets.all(16.0),
// // //                   itemCount: deliveryBoys.length,
// // //                   itemBuilder: (context, index) {
// // //                     final deliveryboys = deliveryBoys[index];

// // //                     // Safe null handling
// // //                     final db_name = deliveryboys['db_name']?.toString() ?? 'Unknown Delivery Boy';
// // //                     final db_location = deliveryboys['db_location']?.toString()?? 'Unknown location';

// // //                     final email = deliveryboys['email']?.toString() ?? 'No email available';
// // //                     final userId = deliveryboys['userId']?.toString();
// // //                     final docId = deliveryboys['docid']?.toString();

// // //                     return
      
      
      
      
      
      
      
      
// // //       Column(
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(16.0),
          
// // //             child: InkWell(
// // //             onTap: () {
              

// // //               Navigator.push(
// // //                 context,
// // //                  MaterialPageRoute(builder: (context) => DeliveryBoyDetails(
// // //                   deliveryboyId: userId ?? '',
// // //                   deliverboyemail: email,
// // //                   )),
// // //               );
// // //               },
// // //             child: Container(
              
// // //               width: double.infinity,
// // //               decoration:  BoxDecoration(
// // //                     color: Colors.grey[100],
// // //                     borderRadius: BorderRadius.circular(20),
// // //                     boxShadow: [
// // //                       BoxShadow(
// // //                         color: Colors.black.withOpacity(0.1),
// // //                         spreadRadius: 2,
// // //                         blurRadius: 16,
// // //                         offset: const Offset(4,4)
// // //                       )
// // //                     ] ),
// // //                     child: Padding(
// // //                       padding: const EdgeInsets.all(12.0),
// // //                       child: Row(
// // //                           crossAxisAlignment: CrossAxisAlignment.start,
// // //                         children: [
                          
                         
// // //                           Align(
// // //                             alignment: Alignment.topRight,
// // //                             child: Text("${index + 1}.", style: GoogleFonts.tinos(
// // //                               fontSize: 25,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.black,
// // //                             ),),
// // //                           ),
// // //                           const SizedBox(width: 20,),


// // //                           Column(
// // //                            crossAxisAlignment: CrossAxisAlignment.start,
                          
// // //                            children: [ 
                            
// // //                              Text(
// // //                               db_name ,
// // //                              style: GoogleFonts.tinos(
// // //                               fontSize: 20,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: const Color.fromARGB(255, 75, 2, 2),
// // //                                                     ),
// // //                                                   ),
// // //                               Text(
// // //                              email ,
// // //                              style: GoogleFonts.tinos(
// // //                               fontSize: 18,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.grey,
                              
// // //                                                     ),
// // //                              softWrap:true,
// // //                              overflow: TextOverflow.visible,
                                                   
// // //                                                 ),


// // //                                                      Text(
// // //                              db_location ,
// // //                              style: GoogleFonts.tinos(
// // //                               fontSize: 18,
// // //                               fontWeight: FontWeight.bold,
// // //                               color: Colors.grey,
                              
// // //                                                     ),
// // //                              softWrap:true,
// // //                              overflow: TextOverflow.visible,
                                                   
// // //                                                 ),

// // //                                         // Show debug info
// // //                                       if (userId == null || userId.isEmpty) ...[
// // //                                         const SizedBox(height: 8),
// // //                                         Text(
// // //                                           " No User ID available",
// // //                                           style: GoogleFonts.tinos(
// // //                                             fontSize: 12,
// // //                                             // color: Colors.red,
// // //                                           ),
// // //                                         ),
// // //                                       ],


// // //                              const SizedBox(height: 20,),




// // // Row(
// // //   children: [
// // //     // ✅ Reject Button (No Stream)
// // //     OutlinedButton(
// // //       onPressed: () => dbdeleteAlert(
// // //         context, 
// // //         docId.toString(), 
// // //         db_name
        
// // //       ),
// // //       style: OutlinedButton.styleFrom(
// // //         side: BorderSide(
// // //           color: Theme.of(context).colorScheme.primary,
// // //           width: 1.5,
// // //         ),
// // //       ),
// // //       child: const Text("Reject"),
// // //     ),

// // //     const SizedBox(width: 20),

// // // StreamBuilder<bool>(
// // //   stream: context
// // //       .watch<DeliveryBoyViewProvider>()
// // //       .checkDeliveryBoyApprovedStream(docId!),
// // //   builder: (context, snapshot) {
// // //     bool isApproved = snapshot.data ?? false;

// // //     return ElevatedButton(
// // //       onPressed: isApproved
// // //           ? null
// // //           : () => dbApproveAlert(
// // //                 context,
// // //                 docId.toString(),
// // //                 db_name,
// // //               ),
// // //       style: ButtonStyle(
// // //         backgroundColor: MaterialStateProperty.resolveWith<Color>(
// // //           (states) {
// // //             if (isApproved) {
// // //               return Colors.grey;
// // //             }
// // //             return Theme.of(context).colorScheme.primary;
// // //           },
// // //         ),
// // //         shape: MaterialStateProperty.all(
// // //           RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(20),
// // //           ),
// // //         ),
// // //       ),
// // //       child: Text(
// // //         isApproved ? "Approved" : "Approve",
// // //         style: const TextStyle(color: Colors.white),
// // //       ),
// // //     );
// // //   },
// // // )





// // //   ],
// // // )

// // //                    ],),
// // //                         ],
// // //                       ),
// // //                     ),
            
            
// // //             ),
// // //           ),
// // //         )
// // //         ],
// // //       );
// // //       }
// // //               );
// // //   },
// // // )

            
            
            
         


// // //     );
// // //   }
// // // }
                            
// // //      //last code             //   ///////////////////////////////////        
                             
                             
                             
                          
                          
                     
                                                
                          
                   
                          
                            
                          
                          
                                            
                          
                          
                          
                            
                          
                          
                          
                          
                          
                                  
                             
                             
                             
          
   
               











































// // // // import 'dart:io';
// // // // import 'dart:typed_data';
// // // // import 'package:agitha/ControllersFolder/JobApplicationController.dart';
// // // // import 'package:firebase_auth/firebase_auth.dart';
// // // // import 'package:file_picker/file_picker.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:mailer/mailer.dart';
// // // // import 'package:mailer/smtp_server/gmail.dart';
// // // // import 'package:flutter/services.dart' show rootBundle;

// // // // class JobForm extends StatefulWidget {
// // // //   final String appliedJobTitle;

// // // //   const JobForm({super.key, required this.appliedJobTitle});

// // // //   @override
// // // //   State<JobForm> createState() => _JobFormState();
// // // // }

// // // // class _JobFormState extends State<JobForm> {
// // // //   final _formKey = GlobalKey<FormState>();

// // // //   final TextEditingController _nameController = TextEditingController();
// // // //   final TextEditingController _phoneController = TextEditingController();
// // // //   final TextEditingController _emailController = TextEditingController();
// // // //   final TextEditingController _addressController = TextEditingController();

// // // //   File? _resumeFile;
// // // //   bool _isLoading = false;

// // // //   // ✅ Pick Resume File
// // // //   Future<void> _pickResume() async {
// // // //     FilePickerResult? result = await FilePicker.platform.pickFiles(
// // // //       type: FileType.custom,
// // // //       allowedExtensions: ['pdf', 'doc', 'docx'],
// // // //     );

// // // //     if (result != null && result.files.single.path != null) {
// // // //       setState(() {
// // // //         _resumeFile = File(result.files.single.path!);
// // // //       });
// // // //     }
// // // //   }

// // // //   // ✅ Submit Job Application (Upload + Firestore + Email)
// // // //   Future<void> _submitForm() async {
// // // //     final colorScheme = Theme.of(context).colorScheme;

// // // //     if (!_formKey.currentState!.validate()) return;

// // // //     if (_resumeFile == null) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: const Text("Please upload a resume"),
// // // //           backgroundColor: colorScheme.primary,
// // // //         ),
// // // //       );
// // // //       return;
// // // //     }

// // // //     setState(() => _isLoading = true);

// // // //     try {
  
// // // //       final jobController = JobApplicationController();

// // // //       // ✅ Upload resume + Submit Firestore entry in one step
// // // //       await jobController.uploadAndSubmitApplication(
// // // //         resumeFile: _resumeFile!,
// // // //         fullName: _nameController.text.trim(),
// // // //         phone: _phoneController.text.trim(),
// // // //         email: _emailController.text.trim(),
// // // //         address: _addressController.text.trim(),
// // // //         appliedJob: widget.appliedJobTitle,
// // // //       );

// // // //       // ✅ Send confirmation email
// // // //       await _sendEmail(
// // // //         recipientEmail: _emailController.text.trim(),
// // // //         fullName: _nameController.text.trim(),
// // // //         jobTitle: widget.appliedJobTitle,
// // // //       );

// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: const Text("Job Application submitted successfully!"),
// // // //           backgroundColor: colorScheme.primary,
// // // //         ),
// // // //       );

// // // //       Navigator.pop(context);
// // // //     } catch (e) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: Text("Error: $e"),
// // // //           backgroundColor: colorScheme.primary,
// // // //         ),
// // // //       );
// // // //     } finally {
// // // //       setState(() => _isLoading = false);
// // // //     }
// // // //   }

// // // //   // ✅ Send Email Confirmation
// // // //   Future<void> _sendEmail({
// // // //     required String recipientEmail,
// // // //     required String fullName,
// // // //     required String jobTitle,
// // // //   }) async {
// // // //     const String username = 'mohammedihsankp600@gmail.com';
// // // //     const String password = 'xapt numz rrac dzvq'; // Gmail App Password

// // // //     final smtpServer = gmail(username, password);

// // // //     // Load banner image from assets
// // // //     final Uint8List bannerBytes =
// // // //         (await rootBundle.load('assets/agithabg.jpg')).buffer.asUint8List();

// // // //     const String bannerCid = '<banner@agitha>';

// // // //     final message = Message()
// // // //       ..from = Address(username, 'Agitha Jobs')
// // // //       ..recipients.add(recipientEmail)
// // // //       ..subject = 'Job Application Confirmation - $jobTitle'
// // // //       ..html = '''
// // // //         <div style="font-family: Arial, sans-serif; color: #333;">
// // // //           <p>Dear <b>$fullName</b>,</p>
// // // //           <p>Thank you for applying for the "<b>$jobTitle</b>" position at Agitha.</p>
// // // //           <p>We have received your application successfully. Our team will review it and get back to you soon.</p>

// // // //           <p>Best Regards,<br>
// // // //           <b>Agitha Recruitment Team</b><br>
// // // //           <small style="color: gray;">This is an automated message. Please do not reply.</small></p>

// // // //           <div style="text-align:center; margin-top: 20px;">
// // // //             <img src="cid:banner@agitha"
// // // //                  alt="Agitha Banner"
// // // //                  style="width:100%; max-width:600px; border-radius:10px;" />
// // // //           </div>
// // // //         </div>
// // // //       ''';

// // // //     final bannerAttachment = StreamAttachment(
// // // //       Stream.fromIterable([bannerBytes]),
// // // //       'image/jpeg',
// // // //       fileName: 'agithabg.jpg',
// // // //     )
// // // //       ..cid = bannerCid
// // // //       ..location = Location.inline;

// // // //     message.attachments.add(bannerAttachment);

// // // //     try {
// // // //       await send(message, smtpServer);
// // // //       debugPrint('✅ Email with inline banner sent to $recipientEmail');
// // // //     } on MailerException catch (e) {
// // // //       debugPrint('❌ Email sending failed: $e');
// // // //     }
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     final colorScheme = Theme.of(context).colorScheme;

// // // //     return Scaffold(
// // // //       appBar: AppBar(
       

// // // //       ),
// // // //       body: Padding(
// // // //         padding: const EdgeInsets.all(16.0),
// // // //         child: Form(
// // // //           key: _formKey,
// // // //           child: SingleChildScrollView(
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Center(
// // // //                   child: Padding(
// // // //                     padding: const EdgeInsets.all(8.0),
// // // //                     child: Text(
// // // //                       "JOB APPLICATION FORM",
// // // //                       style: GoogleFonts.tinos(
// // // //                         fontSize: 22,
// // // //                         fontWeight: FontWeight.bold,
// // // //                         color: const Color.fromARGB(255, 75, 2, 2),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 20),

// // // //                 // 👤 Name
// // // //                 TextFormField(
// // // //                   controller: _nameController,
// // // //                   decoration: const InputDecoration(
// // // //                     labelText: "Full Name",
// // // //                     border: OutlineInputBorder(),
// // // //                   ),
// // // //                   validator: (value) =>
// // // //                       value!.isEmpty ? "Enter your full name" : null,
// // // //                 ),
// // // //                 const SizedBox(height: 16),

// // // //                 // 📞 Phone
// // // //                 TextFormField(
// // // //                   controller: _phoneController,
// // // //                   decoration: const InputDecoration(
// // // //                     labelText: "Phone",
// // // //                     border: OutlineInputBorder(),
// // // //                   ),
// // // //                   keyboardType: TextInputType.phone,
// // // //                   validator: (value) =>
// // // //                       value!.isEmpty ? "Enter your phone number" : null,
// // // //                 ),
// // // //                 const SizedBox(height: 16),

// // // //                 // 📧 Email
// // // //                 TextFormField(
// // // //                   controller: _emailController,
// // // //                   decoration: const InputDecoration(
// // // //                     labelText: "Email",
// // // //                     border: OutlineInputBorder(),
// // // //                   ),
// // // //                   keyboardType: TextInputType.emailAddress,
// // // //                   validator: (value) =>
// // // //                       value!.isEmpty ? "Enter your email" : null,
// // // //                 ),
// // // //                 const SizedBox(height: 16),

// // // //                 // 🏠 Address
// // // //                 TextFormField(
// // // //                   controller: _addressController,
// // // //                   decoration: const InputDecoration(
// // // //                     labelText: "Address",
// // // //                     border: OutlineInputBorder(),
// // // //                   ),
// // // //                   maxLines: 2,
// // // //                   validator: (value) =>
// // // //                       value!.isEmpty ? "Enter your address" : null,
// // // //                 ),
// // // //                 const SizedBox(height: 16),

// // // //                 // 📄 Resume Upload
// // // //                 Row(
// // // //                   children: [
// // // //                     ElevatedButton.icon(
// // // //                       onPressed: _pickResume,
// // // //                       icon: const Icon(Icons.upload_file),
// // // //                       label: const Text("Upload Resume"),
// // // //                     ),
// // // //                     const SizedBox(width: 10),
// // // //                     Expanded(
// // // //                       child: Text(
// // // //                         _resumeFile != null
// // // //                             ? _resumeFile!.path.split('/').last
// // // //                             : "No file selected",
// // // //                         style: const TextStyle(color: Colors.grey),
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //                 const SizedBox(height: 24),

// // // //                 // Buttons Row
// // // //                 Row(
// // // //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                   children: [
// // // //                     OutlinedButton(
// // // //                       style: OutlinedButton.styleFrom(
// // // //                         side: BorderSide(
// // // //                           color: colorScheme.primary,
// // // //                           width: 1.5,
// // // //                         ),
// // // //                       ),
// // // //                       onPressed: () => Navigator.pop(context),
// // // //                       child: Text(
// // // //                         "Cancel",
// // // //                         style: TextStyle(color: colorScheme.primary),
// // // //                       ),
// // // //                     ),
// // // //                     ElevatedButton(
// // // //                       style: ButtonStyle(
// // // //                         backgroundColor: MaterialStateProperty.all(
// // // //                           _isLoading
// // // //                               ? Colors.grey[400]
// // // //                               : colorScheme.primary,
// // // //                         ),
// // // //                       ),
// // // //                       onPressed: _isLoading ? null : _submitForm,
// // // //                       child: _isLoading
// // // //                           ? const SizedBox(
// // // //                               height: 18,
// // // //                               width: 18,
// // // //                               child: CircularProgressIndicator(
// // // //                                 strokeWidth: 2,
// // // //                                 color: Colors.white,
// // // //                               ),
// // // //                             )
// // // //                           : const Text(
// // // //                               "Submit",
// // // //                               style: TextStyle(color: Colors.white),
// // // //                             ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }


////UPI/////
///import 'package:agitha/ControllersFolder/CartController.dart';
// import 'package:agitha/ControllersFolder/OrdersController.dart';
// import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
// import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderSuccessPage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:upi_india/upi_india.dart';

// class FoodPaymentPage extends StatefulWidget {
//   final String latestOrderId;
//   const FoodPaymentPage({
//     super.key,
//     required this.latestOrderId,
//     });

//   @override
//   State<FoodPaymentPage> createState() => _FoodPaymentPageState();
// }

// class _FoodPaymentPageState extends State<FoodPaymentPage> {
// final  UpiIndia _upiIndia = UpiIndia();
// // UpiResponse? _upiResult;
// bool isPaying = false;



//    String? _selectedPayment;
//    String get latestOrderId => widget.latestOrderId;

//    Future<void> initiateUPIPayment(double amount) async {
//   setState(() => isPaying = true);

//   UpiApp selectedApp;

//   if (_selectedPayment == "GooglePay") {
//     selectedApp = UpiApp.googlePay;
//   } else if (_selectedPayment == "Phone Pay") {
//     selectedApp = UpiApp.phonePe;
//   } else if (_selectedPayment == "Paytm") {
//     selectedApp = UpiApp.paytm;
//   } else {
//     return;
//   }

//   try {
//     UpiResponse response = await _upiIndia.startTransaction(
//       app: selectedApp,
//       receiverUpiId: "pattikkadhaji@okhdfcbank", // Enter shop UPI ID
//       receiverName: "Food Store",
//       transactionRefId: "TXN${DateTime.now().millisecondsSinceEpoch}",
//       transactionNote: "Food Order Payment",
//       amount: amount,
//     );

//     handlePaymentResult(response);
//   } catch (e) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text("UPI App not installed")));
//   }

//   setState(() => isPaying = false);
// }

// void handlePaymentResult(UpiResponse result) async {
//   switch (result.status) {
//     case UpiPaymentStatus.SUCCESS:
//       // Mark order as paid in Firestore
//       await Provider.of<OrderController>(context, listen: false)
//           .updatePaymentStatus(latestOrderId, "Paid");

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
//       );
//       break;

//     case UpiPaymentStatus.FAILURE:
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Payment Failed")));
//       break;

//     case UpiPaymentStatus.SUBMITTED:
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Payment Submitted")));
//       break;

//     default:
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Payment cancelled")));
//   }
// }



//   @override
//   Widget build(BuildContext context) {
//     final cartController = Provider.of<CartController>(context);
// final itemCount = cartController.uniqueItemsCount;
// final totalAmount = cartController.totalPrice;
//    final colorScheme = Theme.of(context).colorScheme;
//    final textTheme = Theme.of(context).textTheme;
//     return Scaffold(
//       appBar: AppBar(
//               leading: IconButton(
//              icon: const Icon(Icons.arrow_back),
//          onPressed: () async {
        
         
//            final confirm = await showDialog(
//              context: context,
//              builder: (context) => AlertDialog(
//                title: const Text("Cancel Order"),
//                content: const Text("Are you sure you want to cancel this order?"),
//                actions: [
//                  TextButton(
//                    child: const Text("No"),
//                    onPressed: () => Navigator.pop(context, false),
//                  ),
//                  ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//           backgroundColor:
//               Theme.of(context).colorScheme.primary,
//         ),
//                    child: const Text("Yes", style: TextStyle(color: Colors.white)),
//                    onPressed: () => Navigator.pop(context, true),
//                  ),
//                ],
//              ),
//            );
         
//            if (confirm == true) {
//              final success = await Provider.of<OrderController>(context, listen: false)
//                  .cancelOrder(latestOrderId);
         
//              if (success) {
//                ScaffoldMessenger.of(context).showSnackBar(
//                  const SnackBar(content: Text("Order cancelled successfully")),
//                );
//                Navigator.pushReplacement(
//                  context,
//                  MaterialPageRoute(builder: (context) => const FoodCartPage()),
//                );
//              } else {
//                ScaffoldMessenger.of(context).showSnackBar(
//                  const SnackBar(content: Text("Failed to cancel order")),
//                );
//              }
//            }
//          }




//   ),
       
//       ),
//       body: Column(
       
//         children: [

//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               height: 200,
//               width: double.infinity,
             
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                  color: const Color.fromARGB(255, 75, 2, 2),
            
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [

//                 Padding(
//                   padding: const EdgeInsets.only(left: 26.0,top: 26.0),
//                   child: Text("$itemCount items | To Pay",
//                   style: GoogleFonts.roboto(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white)),
//                 ),

//                 Padding(
//                   padding: const EdgeInsets.only(left: 26.0,),
//                   child: Text(totalAmount.toStringAsFixed(2),
//                   style: GoogleFonts.tinos(
//                   fontSize: 50,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.white)),
//                 )







//               ],),
              
              
              
//               ),
              





//           ),


          
//           Padding(
//             padding: const EdgeInsets.only(left: 16.0, top: 10,bottom: 10),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Select Payment Method",
//                 style: GoogleFonts.tinos(
//                   fontSize: 23,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black
//                   )
//               ),
//             ),
//           ),
      

//         // Google Pay
//           RadioListTile<String>(
//             title: Row(
//               children: [
//                 Image.asset("assets/payicon/gpay.png", height: 40, width: 40),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Google Pay",
//                         style: GoogleFonts.tinos(
//                             fontSize: 20, color: Colors.black)),
//                     Text("Pay using Google Pay",
//                         style: GoogleFonts.tinos(
//                             fontSize: 15, color: Colors.grey)),
//                   ],
//                 ),
//               ],
//             ),
//             value: "GooglePay",
//             groupValue: _selectedPayment,
//             controlAffinity: ListTileControlAffinity.trailing,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPayment = value;
//               });
//             },
//           ),
      
        
        
//           // Paytm
//           RadioListTile<String>(
//             title: Row(
//               children: [
//                 Image.asset("assets/payicon/paytm.png", height: 40, width: 40),
//                 const SizedBox(width: 10),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Paytm",
//                         style: GoogleFonts.tinos(
//                             fontSize: 20, color: Colors.black)),
//                     Text("Pay using Paytm",
//                         style: GoogleFonts.tinos(
//                             fontSize: 15, color: Colors.grey)),
//                   ],
//                 ),
//               ],
//             ),
//             value: "Paytm",
//             groupValue: _selectedPayment,
//             controlAffinity: ListTileControlAffinity.trailing,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPayment = value;
//               });
//             },
//           ),
      
//           // Phone Pay
//           RadioListTile<String>(
//             title: Row(
//               children: [
//                 Image.asset("assets/payicon/phonepay.png", height: 40, width: 40),
//                 const SizedBox(width: 10),
                
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text("Phone Pay", style: GoogleFonts.tinos(
//                         fontSize: 20,
                        
//                         color: Colors.black
//                         )),
//                     ),

//                         Text(" Pay using Phone Pay", style: GoogleFonts.tinos(
//                       fontSize: 15,
                      
//                       color: Colors.grey
//                       )),


//                   ],
//                 ),


//               ],
//             ),
//             value: "Phone Pay",
//             groupValue: _selectedPayment,
//             controlAffinity: ListTileControlAffinity.trailing,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPayment = value;
//               });
//             },
//           ),

//             RadioListTile<String>(
//             title: Row(
//               children: [
//               Image.asset("assets/payicon/cod.png", height: 40, width: 40),
               
//                 const SizedBox(width: 10),
                
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 5.0),
//                       child: Text("COD", style: GoogleFonts.tinos(
//                         fontSize: 20,
                        
//                         color: Colors.black
//                         )),
//                     ),

//                         Text(" Pay using Cash on Delivery", style: GoogleFonts.tinos(
//                       fontSize: 15,
                      
//                       color: Colors.grey
//                       )),


//                   ],
//                 ),


//               ],
//             ),
//             value: "COD",
//             groupValue: _selectedPayment,
//             controlAffinity: ListTileControlAffinity.trailing,
//             onChanged: (value) {
//               setState(() {
//                 _selectedPayment = value;
//               });
//             },
//           ),


          

//               Padding(
//                 padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 60),
//                 child: SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
                                               
//                        backgroundColor: colorScheme.primary,
//                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
//                      ),
//                      onPressed: () {
//                  if (_selectedPayment == null) {
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      const SnackBar(content: Text("Please select a payment method")),
//                    );
//                    return;
//                  }
               
//                  if (_selectedPayment == "COD") {
//                    Provider.of<OrderController>(context, listen: false)
//                        .updatePaymentStatus(latestOrderId, "COD");
               
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(builder: (context) => const OrderSuccessPage()),
//                    );
//                    return;
//                  }
               
//                  // UPI apps
//                  initiateUPIPayment(totalAmount);
//                },
               
//                                         child:  Text("Next",
//                                 style: textTheme.bodyLarge
//                                     ?.copyWith(color: Colors.white)),
//                                                     ),
//                             ),
//               ),
        
          
                                
                                
                              
                              
                               
                                                       
                              
                      



       
//         ],
//       ),
//     );
//   }
// }