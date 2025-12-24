import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/HelpAndSupport.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/Languagepage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/RatingPage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/ReferAndEarn.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/TermsAndConditon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSettings extends StatelessWidget {
  const UserSettings({super.key});

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [

          
           Padding(
             padding: const EdgeInsets.only(left: 16.0,right: 8.0,bottom:8.0,top: 8.0 ),
             child: Text('Settings',
              
              style: GoogleFonts.tinos(
                    fontSize: 40,
                     fontWeight: FontWeight.bold,
                   
                    color:Colors.black
                                ),
                                
                                ),
           ),
        



           
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading:  Icon(Icons.language, color:colorScheme.primary,size: 30,),
              title:  Text('Language Selection',
               style: GoogleFonts.tinos(
                    fontSize: 23,
                    color:Colors.black
                                ), ),
               trailing: Icon(Icons.arrow_forward_ios, color:colorScheme.primary,size: 25,),                 
                                
                              
                   
                    
             
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder:(context)=> const LanguagePage()));
              },
            ),
          ),

         

          

         //for notifieing something
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading:  Icon(Icons.reviews, color:colorScheme.primary,size: 30),
              trailing: Icon(Icons.arrow_forward_ios, color:colorScheme.primary,size: 25,), 
              title:  Text('Ratings and Reviews', style: GoogleFonts.tinos(
                    fontSize: 23,
                   
                    color:Colors.black
                                ),),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder:(context)=> const RatingPage()));
              },
            ),
          ),

         

        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading:  Icon(Icons.redeem, color:colorScheme.primary,size: 30),
              trailing: Icon(Icons.arrow_forward_ios, color:colorScheme.primary,size: 25,), 
              title:  Text('Refer & Earn', style: GoogleFonts.tinos(
                    fontSize: 23,
                   
                    color:Colors.black
                                ),),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder:(context)=> const ReferEarnPage()));
              },
            ),
          ),

          

          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading:  Icon(Icons.contact_support,color:colorScheme.primary,size: 30),
              trailing: Icon(Icons.arrow_forward_ios, color:colorScheme.primary,size: 25,), 
              title:  Text('Help & Support', style: GoogleFonts.tinos(
                    fontSize: 23,
                   
                    color:Colors.black
                                ),),
              onTap: () {
            
                 Navigator.push(context, MaterialPageRoute(builder:(context)=> const HelpSupportPage()));
                
            
            
              },
            ),
          ),

       



             Padding(
               padding: const EdgeInsets.all(8.0),
               child: ListTile(
                           leading: Icon(Icons.description, color:colorScheme.primary,size: 30),
                            trailing: Icon(Icons.arrow_forward_ios, color:colorScheme.primary,size: 25,), 
                           title: Text('Terms & Conditions', style: GoogleFonts.tinos(
                    fontSize: 23,
                   
                    color:Colors.black
                                ),),
                           onTap: () {
               
                 Navigator.push(context, MaterialPageRoute(builder:(context)=> const TermsAndConditionsPage()));
                
               
               
                           },
                         ),
             ),

          

            



        ],
      ), 
    );
  }
}