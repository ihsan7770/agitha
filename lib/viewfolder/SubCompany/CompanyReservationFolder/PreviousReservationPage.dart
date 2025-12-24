import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviousReservationPage extends StatelessWidget {
  const PreviousReservationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                     
                        
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mohammed ihsan",
                                  style: GoogleFonts.tinos(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(255, 75, 2, 2),
                                  ),
                                ),


                                
                                                Text(
                                                  "Casual Booking",
                                                  style: GoogleFonts.tinos(
                                                    fontSize: 23,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                  ),
                                                ),
                             
                                          
                            
                                        Text("● Friday,September 19,2025",  
                                        
                                        style: GoogleFonts.tinos(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:Colors.black,
                                        ),),
                            
                                           Text("● Party of 2",  
                                           
                                           style: GoogleFonts.tinos(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color:Colors.black,
                                           ),),

                                            Text("● 2:00 PM",  
                                           
                                           style: GoogleFonts.tinos(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color:Colors.black,
                                           ),),

                                             Text("● 1 hour",  
                                           
                                           style: GoogleFonts.tinos(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color:Colors.black,
                                           ),),

                                      const SizedBox(height: 10),
                                             
                                              Row(
                                                children: [
                                              

                                                 const Spacer(),

                                                      Text("Amount: 500₹",

                                                                                             
                                                 style: GoogleFonts.tinos(
                                                 fontSize: 20,
                                                 fontWeight: FontWeight.bold,
                                                 color:Colors.black,
                                                 ),),
                                                ],
                                              ),





                                           
                       


                            
                            
                            
                            
                            
                            
                             
                            
                                const SizedBox(height: 10),
                            
                            
                               
                              ],
                            ),
                          ),
                        ),


                  
                      ],
                    ),
                  ),
                ),
              ],
            );
  }
}