import 'package:agitha/viewfolder/User/EventBookingFolder/EventPaymentPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:agitha/viewfolder/Widgets/DateCircles.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class EventForm extends StatefulWidget {
  const EventForm ({super.key});

  @override
  State<EventForm> createState() => _ReservationState();
}

class _ReservationState extends State<EventForm> {
String selecteddecoration="";

  final _formKey = GlobalKey<FormState>();

  int? selectedPeople;
  String? selectedevent;
  String? selectedTime;
  String? selectedDuration;
  DateTime? selectedDate;
  bool isTable2Selected = false;
  bool isTable4Selected = false;
  bool isTable6Selected = false;
  bool isTable8Selected = false;
  bool isTable10Selected = false;


 
  final List<int> peopleList = List.generate(19, (index) => index + 2);

  
  final List<String> timeSlots = [
    "6:00 AM",
    "6:30 AM",
    "7:00 AM",
    "7:30 AM",
    "8:00 AM",
    "8:30 AM",
    "9:00 AM",
    "9:30 AM",
    "10:00 AM",
    "10:30 AM",
    "11:00 AM",
    "11:30 AM",
    "12:00 PM",
    "12:30 PM",
    "1:00 PM",
    "1:30 PM",
    "2:00 PM",
    "2:30 PM",
    "3:00 PM",
    "3:30 PM",
    "4:00 PM",
    "4:30 PM",
    "5:00 PM",
    "5:30 PM",
    "6:00 PM",
  ];


  final List<String> events = ["Birthday Parties", "Groom to be", "Bride to be","Mom to be","Reunions","Anniversaries","Farewell","Meetings"];




  


  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),   
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),

      // body



      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
        
                Image.asset('assets/projectimages/beefberbgr.png',width: 300,height: 80,color:Colors.black),
        const SizedBox(height: 16),

                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter Some Basic Details",style: GoogleFonts.tinos(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                      )),
                    ),
                  ),
                
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: "Number of Guests",
                    border: OutlineInputBorder(),
                  ),
                  items: peopleList
                      .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                      .toList(),
                  onChanged: (val) => setState(() => selectedPeople = val),
                  validator: (val) =>
                      val == null ? "Please select number of people" : null,
                ),
                const SizedBox(height: 16),


                      DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Event",
                    border: OutlineInputBorder(),
                  ),
                  items: events
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedevent = val),
                  validator: (val) =>
                      val == null ? "Please select a event" : null,
                ),

                const SizedBox(height: 16),



           
        
                // Time dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Select Time",
                    border: OutlineInputBorder(),
                  ),
                  items: timeSlots
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedTime = val),
                  validator: (val) =>
                      val == null ? "Please select a time" : null,
                ),
                const SizedBox(height: 24),

               


                  
             Row(
  mainAxisAlignment: MainAxisAlignment.start, // or center / spaceEvenly
  mainAxisSize: MainAxisSize.min,
  children: [
    // 30 Minutes
    Transform.scale(
      scale: 1.0,
      child: Radio<String>(
        value: "1 Hour",
        groupValue: selectedTime,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          setState(() => selectedTime = value);
        },
      ),
    ),
     Text("1 Hour",style: GoogleFonts.tinos(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),

    const SizedBox(width: 10), // spacing between options

    // 1 Hour
    Transform.scale(
      scale: 1.0,
      child: Radio<String>(
        value: "2 Hour",
        groupValue: selectedTime,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          setState(() => selectedTime = value);
        },
      ),
    ),
     Text("2 Hour",style: GoogleFonts.tinos(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),

    const SizedBox(width: 10), // spacing

    // 2 Hours
    Transform.scale(
      scale: 1.0,
      child: Radio<String>(
        value: "3 Hour",
        groupValue: selectedTime,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (value) {
          setState(() => selectedTime = value);
        },
      ),
    ),
     Text("3 Hour",style: GoogleFonts.tinos(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
  ],
),



       Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Select the Date",style: GoogleFonts.tinos(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                      )),
                    ),
                  ),

          const DateSelector(),

              Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Decoration",style: GoogleFonts.tinos(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                      )),
                    ),
                  ),

         

                Row(
                  children: [
                    Checkbox(
                      
                      value: selecteddecoration=="No decoration", onChanged:(value){
                      setState(() {



                       selecteddecoration="No decoration";
                      });
                    }),
                    Text("No decoration",style: GoogleFonts.tinos(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
                  ],
                ),

                  Row(
                    children: [
                      Checkbox(value:selecteddecoration == "Decorate by ourselves", onChanged:(value){
                      setState(() {
                       selecteddecoration = "Decorate by ourselves";
                      });
                                      }),
                                      Text("Decorate by ourselves",style: GoogleFonts.tinos(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
                    ],
                  ),

                  Row(
                    children: [
                      Checkbox(value:selecteddecoration =="Decorated by restaurant team", onChanged:(value){
                      setState(() {
                        selecteddecoration ="Decorated by restaurant team";
                      });
                                      }),
                                      Text("Decorated by restaurant team",style: GoogleFonts.tinos(
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black
                    )),
                    ],
                  ),

                

                 const SizedBox(height: 40,),
                 Padding(
                         padding: const EdgeInsets.all(12.0),
                         child: Row(
                        children: [
                        Text("Deposit:₹500",style: GoogleFonts.tinos(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 75, 2, 2),
                        )),
     
                        const Spacer(),
     
     
              

              ElevatedButton(
               onPressed: () {
         Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const   EventPaymentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), 
                ),
                padding: const EdgeInsets.all(16), 
              ),
              child: const Icon(
                Icons.arrow_forward, 
                size: 30,
              ),
            )
                 
     
             
             
               ],
             ),
           ),

   const SizedBox(height: 10,)
                  










                  




        
        
        
              
        
        
        
        
        
        
        
        
        
        
        
        
        
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
