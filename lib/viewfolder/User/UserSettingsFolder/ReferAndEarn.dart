import 'package:agitha/viewfolder/Widgets/ReferCode.dart';
import 'package:agitha/check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class ReferEarnPage extends StatefulWidget {

  const ReferEarnPage({super.key});

  @override
  State<ReferEarnPage> createState() => _ReferEarnPageState();
}

class _ReferEarnPageState extends State<ReferEarnPage> {
  final String referImage =
      "assets/refer.png"; 
 // Replace with user image
  final String appLink =
      "https://play.google.com/store/apps/details?id=com.flipkart.android&hl=en_IN"; 
  
  
  
  void _shareApp(BuildContext context) {
    Share.share(
      "Hey! 👋 Check out this app I’m using. Download it here: $appLink",
      subject: "Join me on this app!",
    );
  }

  

  @override
  Widget build(BuildContext context) {

     final colorScheme = Theme.of(context).colorScheme;
      final size = MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
        title: const Text("Refer & Earn"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
           
              const SizedBox(height: 40),
             Image.asset(referImage),
              const SizedBox(height: 12),
        
              
           
        
              const SizedBox(height: 24),
        
              
               Text(
                "Invite your friends & earn rewards when they join using your link.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: size.width * 0.045, color: Colors.grey),
              ),
        
             
        
             
           
        
              const SizedBox(height: 20),
        
             
          
        
        
            const ReferCodeWidget(),
        
             const SizedBox(height: 30),
        
        SizedBox(
          width: double.infinity,  
          height: 40,  
          child: ElevatedButton.icon(
            onPressed: () => _shareApp(context),
            icon: const Icon(Icons.share, size: 18), // smaller icon
            label: const Text(
        "Share",
        style: TextStyle(fontSize: 14), // smaller text
            ),
            style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.zero, // let SizedBox control size
            ),
          ),
        ),
        
        
        
            ],
          ),
        ),
      ),
    );
  }
}
