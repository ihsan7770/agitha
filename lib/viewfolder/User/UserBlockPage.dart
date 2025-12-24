import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserBlockPage extends StatelessWidget {
  const UserBlockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      
      appBar:AppBar(

  leading: IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: ()  {
     AuthenticationController().logout(context);
     

     
    },
  ),
),


          body: Center(
            child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: 100,
                           ),
                        ),


                Text(
                  "Your account has been blocked!",
                  style:  GoogleFonts.tinos(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ],
            ),
          ),
        );
      }
  }
