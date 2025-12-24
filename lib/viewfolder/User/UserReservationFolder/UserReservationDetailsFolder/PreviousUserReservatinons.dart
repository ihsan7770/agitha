import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviousUserReservations extends StatelessWidget {
  const PreviousUserReservations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: [

          

          Card(
            color: Colors.white,

                  margin: const EdgeInsets.all(10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [

                        Row(
                          
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         ClipRRect(
                         borderRadius: BorderRadius.circular(20), 
                         child: Image.asset(
                           "assets/projectimages/2nd.jpg",
                           fit: BoxFit.cover, 
                           width: 60,        
                           height: 60,       
                         ),
                        )  ,     
                          const SizedBox(width: 16),            
                        
                        
                            
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Beefbar Restuarant",
                                    style: GoogleFonts.tinos(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(255, 75, 2, 2),
                                    ),
                                  ),
                        
                                   Text(
                                    "Kuwaith, Salmiya",
                                    style: GoogleFonts.tinos(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey
                                    ),
                                  ),

                                   
                               
                               
                           
                             
                                 


                                  
                              
                        
                        
                        
                        
                        
                        
                        
                                           
                        
                                ],
                              ),
                            ),
                        
                            
                                         
                        
                        
                        
                        
                        
                        
                        
                          ],
                        ),

                        const SizedBox(height: 15),


                        Align(
                          alignment: Alignment.topLeft,
                           child: Padding(
                             padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8),
                             child: Text("Booked Details", style: GoogleFonts.tinos(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey,
                                              ),),
                           ),
                         ),



                       

                          Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Icon(
                                     Icons.circle,
                                     size: 18,          
                                     color: Color.fromARGB(255, 75, 2, 2),
                                   ),
                                   const SizedBox(width: 6,),
                                Text("Party of 2", style: GoogleFonts.tinos(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),),
                              ],
                            ),
                          ),
                        ),



                          Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Icon(
                                     Icons.circle,
                                     size: 18,          
                                     color:  Color.fromARGB(255, 75, 2, 2),
                                   ),
                                   const SizedBox(width: 6,),
                                Text("Friday,September 19,2025", style: GoogleFonts.tinos(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),),
                              ],
                            ),
                          ),
                        ),


                                 Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Icon(
                                     Icons.circle,
                                     size: 18,          
                                     color:  Color.fromARGB(255, 75, 2, 2),
                                   ),
                                   const SizedBox(width: 6,),
                                Text("2:00 PM to 3:00 PM", style: GoogleFonts.tinos(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),),
                              ],
                            ),
                          ),
                        ),

                               Padding(
                          padding: const EdgeInsets.only(left:20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                const Icon(
                                     Icons.circle,
                                     size: 18,          
                                     color:  Color.fromARGB(255, 75, 2, 2),
                                   ),
                                   const SizedBox(width: 6,),
                                Text(" Table Number T4P4", style: GoogleFonts.tinos(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),),
                              ],
                            ),
                          ),
                        ),




                                         
                         
                      
                           
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text("Advance paid: ₹255", style: GoogleFonts.tinos(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                                  ),),
                            ),                    
                           
                           
                           
                           
                           
                           
                                                
                           
                           
                        
                           




                      ],
                    ),




                  ),
                ),


          
        ],
      )
    );
    
  }
}