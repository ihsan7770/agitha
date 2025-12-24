import 'package:agitha/viewfolder/Widgets/ContactTextFormContainer.dart';
import 'package:agitha/viewfolder/Widgets/Drawer.dart';
import 'package:agitha/viewfolder/Widgets/SocialMediaIcons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:google_fonts/google_fonts.dart';


class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  
  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      
      body: SingleChildScrollView(
        
        child: Column(
          children: [
              Image.asset(
           "assets/projectimages/Career.png", // your image
            fit: BoxFit.cover,
               width: double.infinity,
               height: 200,
             ),
            
             Container(
              height: 480,
              width: double.infinity,
              color: Colors.white,
              child: Column(
                children: [ 
        
        
        
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,top: 16),
                        child: Text(
                                    "Contacts Information",
                                    style: GoogleFonts.tinos(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                      color:  Colors.black,
                                    ),
                                  ),
                      ),
                    ),
        
                     const Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 16.0,top: 8),
                    child: Text(
                      "We're here to answer any questions you may have "
                      "about our products, services, or company. Reach"
                      "out to us and we'll respond as soon as we can. ",
                      
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5, // line spacing for better readability
                      ),
                      textAlign: TextAlign.left,
                    ),
                      ) ,
                      const SizedBox(height: 26,),
        
                       Padding(
                        padding:const EdgeInsets.only(left: 20.0, right: 16.0,top: 12),
                        child: Row(children: [
        
                          CircleAvatar(
                            backgroundColor: Colors.red[100],
                            radius: 25,
                            child: Icon(Icons.location_on_outlined, color: colorScheme.primary,size: 25),
                          ),
        
                          const SizedBox(width: 10,),
        
                          Text(
                                    "AL SHARQIA TOWER",
                                    style: GoogleFonts.tinos(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color:  Colors.black,
                                    ),
                                  )],),
                      ),
        
                      //second row
        
                        Padding(
                        padding:const EdgeInsets.only(left: 20.0, right: 16.0,top: 12),
                        child: Row(children: [
        
                               CircleAvatar(
                             backgroundColor: Colors.red[100],
                            radius: 25,
                            child:  Icon(Icons.mail_outline, color: colorScheme.primary ,size: 25),
                          ),
        
                          const SizedBox(width: 15,),
        
                          Text(
                                    "INFO@AGTHIA.FOOD.COM.KW",
                                    style: GoogleFonts.tinos(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color:  Colors.black,
                                    ),
                                  )],),
                      ),
        
                      //third row
        
                        Padding(
                        padding:const EdgeInsets.only(left: 20.0, right: 16.0,top: 12),
                        child: Row(children: [
                              CircleAvatar(
                            backgroundColor: Colors.red[100],
                            radius: 25,
                            child:  Icon(Icons.phone_outlined, color: colorScheme.primary, size: 25),
                          ),
        
                          const SizedBox(width: 15,),
        
                          Text(
                                    "22260445",
                                    style: GoogleFonts.tinos(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      color:  Colors.black,
                                    ),
                                  )],),
                      ),
                      const SizedBox(height: 30,),
                      const SocialMediaIcons(),
                     
                  ], 
              ),
             ),

                             Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20,top: 16),
                        child: Text(
                                    "Have a Question?",
                                    style: GoogleFonts.tinos(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                      color:  Colors.black,
                                    ),
                                  ),
                      ),
                    ),
                 



            const ContactTextFromContainer()
        
          
        
        
        
        ],),
      ),




    );
  }
}