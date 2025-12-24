import 'package:agitha/ControllersFolder/UserAdminsideController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/UserRegistratioModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminBlockedUserDetails extends StatelessWidget {
  const AdminBlockedUserDetails ({super.key});

  @override
  Widget build(BuildContext context) {

 final ProfileProvider = Provider.of<UserAdminSideProvider>(context);


    // ✅ Responsive size variables
    final colorScheme = Theme.of(context).colorScheme;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Scaled values
    double padding = screenWidth * 0.03;
    double avatarRadius = screenWidth * 0.12;
    double titleSize = screenWidth * 0.05;
    double subtitleSize = screenWidth * 0.035;
    double smallTextSize = screenWidth * 0.03;
  

    return Scaffold(
    
      body: StreamBuilder<List< UserRegistrationModel>>(
              stream: ProfileProvider.getBlockedProfileStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: CircularProgressIndicator(),
                  ));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No user details found",
                      style: TextStyle(fontSize: 18,color: Colors.grey),
                    ),
                  );
                }

                final profiledata = snapshot.data!;

                return
      
       ListView.builder(
        shrinkWrap: true,
        itemCount:profiledata.length,
       
        itemBuilder: (context, index) {
                    final profiles = profiledata[index];
         return Theme(
           data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: ExpansionTile(
              
              leading: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade300,
              
                // ✅ foregroundImage handles null safely
                foregroundImage: (profiles.profileImageUrl != null &&
               profiles.profileImageUrl!.isNotEmpty)
         ? NetworkImage(profiles.profileImageUrl!)
         : null,
              
                child: (profiles.profileImageUrl == null ||
               profiles.profileImageUrl!.isEmpty)
         ? Icon(
               Icons.person,
               size: 45,
               color: Colors.grey,
           )
         : null,
              ),
              
              
           
           title:       Text(
              profiles.username,
              style: GoogleFonts.tinos(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 75, 2, 2),
              ),
            ),
                   
           
           children: [
           Center(
             child: SizedBox(
               width: screenWidth * 0.8, // 👈 control total width of the centered block
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.start, // 👈 aligns text to same start
                 children: [
                   SizedBox(height: screenHeight * 0.01),
           
           
           
                      RichText(
                     text: TextSpan(
           style: GoogleFonts.tinos(
             fontSize: subtitleSize,
             color: Colors.black,
           ),
           children: [
             const TextSpan(
               text: "Phone: ",
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
             TextSpan(text:profiles.phonenumber ),
           ],
                     ),
                   ),
           
                   // Phone
                 
           
                   SizedBox(height: screenHeight * 0.008),
           
                      RichText(
                     text: TextSpan(
           style: GoogleFonts.tinos(
             fontSize: subtitleSize,
             color: Colors.black,
           ),
           children: [
             const TextSpan(
               text: "Email: ",
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
              TextSpan(text: profiles.email),
           ],
                     ),
                   ),
           
                  
           
                   SizedBox(height: screenHeight * 0.008),
           
                   // Gender & DOB Row
                   Row(
                     children: [
             RichText(
                     text: TextSpan(
           style: GoogleFonts.tinos(
             fontSize: subtitleSize,
             color: Colors.black,
           ),
           children: [
             const TextSpan(
               text: "Gender: ",
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
              TextSpan(text: profiles.gender),
           ],
                     ),
                   ),
           
             
           
                      
           SizedBox(width: screenWidth * 0.05),
            RichText(
                     text: TextSpan(
           style: GoogleFonts.tinos(
             fontSize: subtitleSize,
             color: Colors.black,
           ),
           children: [
             const TextSpan(
               text: "DOB: ",
               style: TextStyle(fontWeight: FontWeight.bold),
             ),
              TextSpan(text: profiles.dob),
           ],
                     ),
                   ),
           
           
                     ],
                   ),
              
                   
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
       onPressed: () async {
         bool? confirm = await showDialog(
           context: context,
           builder: (context) => AlertDialog(
               title: const Text("Unblock User"),
               content:
         Text("Are you sure you want to Unblock this ${profiles.username}?"),
               actions: [
                 TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text("Cancel"),
                 ),
                 ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
        child: const Text("Unblock",
            style: TextStyle(color: Colors.white)),
                 ),
               ],
           ),
         );
              
         if (confirm == true) {
           await Provider.of<UserAdminSideProvider>(
               context,
               listen: false,
           ).UnblockUser(profiles.documentid, context);
         }
       },
       style: ElevatedButton.styleFrom(
         backgroundColor: Theme.of(context).colorScheme.primary,
         foregroundColor: Colors.white,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(20),
         ),
       ),
       child: const Text(
         "Unblock",
         style: TextStyle(color: Colors.white),
       ),
                ),
              )
              
              
              
              
              
              
              
                 ],
               ),
             ),
           )
           
                    
                      
                   
           ],
                     ),
         ),
                   );
       
       
        }
       );

              }) 
    );
  }
}
