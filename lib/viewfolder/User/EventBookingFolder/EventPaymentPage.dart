import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPaymentPage extends StatefulWidget {
  const EventPaymentPage({super.key});

  @override
  State<EventPaymentPage> createState() => _ReservationPaymentPageState();
}

class _ReservationPaymentPageState extends State<EventPaymentPage> {
  String? _selectedPayment;

  @override
  Widget build(BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
   final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
               Image.asset('assets/projectimages/beefberbgr.png',width: 300,height: 80,color:Colors.black),
            Container(
              width: double.infinity,
              // color: Color.fromARGB(255, 254, 242, 243),
              child:  Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  children: [
                
                    Text("John Doe", style: GoogleFonts.tinos(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                    ),),

                     Text("Event: Meeting",style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),

                        Text("Decoration: No Decoration",style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),



                    
                    Text("Date: 25 Sep 2025",style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
                    
                    Text("Time: 7:00 PM to 8:00 PM",style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
        
                    Text("Number of Guests: 4",style: GoogleFonts.tinos(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
        
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text("Total Amount: ₹200",style: GoogleFonts.tinos(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                        )),
                      ),
                    ),
                
                ],),
              ),
            ),
            
          
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10,bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Payment Method",
                  style: GoogleFonts.tinos(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )
                ),
              ),
            ),
        
        // Google Pay
          // Google Pay
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset("assets/payicon/gpay.png", height: 40, width: 40),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Google Pay",
                          style: GoogleFonts.tinos(
                              fontSize: 20, color: Colors.black)),
                      Text("Pay using Google Pay",
                          style: GoogleFonts.tinos(
                              fontSize: 15, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              value: "GooglePay",
              groupValue: _selectedPayment,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
            ),
        
          
          
            // Paytm
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset("assets/payicon/paytm.png", height: 40, width: 40),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Paytm",
                          style: GoogleFonts.tinos(
                              fontSize: 20, color: Colors.black)),
                      Text("Pay using Paytm",
                          style: GoogleFonts.tinos(
                              fontSize: 15, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              value: "Paytm",
              groupValue: _selectedPayment,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
            ),
        
            // Phone Pay
            RadioListTile<String>(
              title: Row(
                children: [
                  Image.asset("assets/payicon/phonepay.png", height: 40, width: 40),
                  const SizedBox(width: 10),
                  
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text("Phone Pay", style: GoogleFonts.tinos(
                          fontSize: 20,
                          
                          color: Colors.black
                          )),
                      ),
        
                          Text(" Pay using Phone Pay", style: GoogleFonts.tinos(
                        fontSize: 15,
                        
                        color: Colors.grey
                        )),
        
        
                    ],
                  ),
        
        
                ],
              ),
              value: "Phone Pay",
              groupValue: _selectedPayment,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (value) {
                setState(() {
                  _selectedPayment = value;
                });
              },
            ),
        
        
            
        
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  
                                  backgroundColor: colorScheme.primary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                ),
                                  onPressed: () {
                                    
                                  },
                                  
                                  
                                
                                
                                 
                                                         
                                
                                child:  Text("Next",
                                  style: textTheme.bodyLarge
                                      ?.copyWith(color: Colors.white)),
                                                      ),
                              ),
                ),
        
            
        
          
          ],
        ),
      ),
    );
  }
}
