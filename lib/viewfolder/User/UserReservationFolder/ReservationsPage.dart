import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ControllersFolder/UserReservationController.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/ReservationModel.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationConformationPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:agitha/viewfolder/Widgets/DateCircles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Reservation extends StatefulWidget {
  final String imageUrl;
  final String restaurantid;
  
  final String restaurantName;
  final String restourentLocation;

  
  
  const Reservation({
    super.key,
    required this.imageUrl,
    required this.restaurantid,
    required this.restaurantName,
    required this.restourentLocation,
    });

  @override
  State<Reservation> createState() => _ReservationState();
}

class _ReservationState extends State<Reservation> {

  final _formKey = GlobalKey<FormState>();

  int? selectedPeople;

String? selectedTimeString;
TimeOfDay? selectedTimeOfDay;
Timestamp? selectedTimeStamp;


  int? selectedDuration;
  DateTime selectedDate = DateTime.now();

  bool isTable2Selected = false;
  bool isTable4Selected = false;
  bool isTable6Selected = false;
  bool isTable8Selected = false;
  bool isTable10Selected = false;

  Stream<bool>? availabilityStream;
bool? isSlotAvailable;

  
  /// 🔹 STREAM (important fix)
late final Stream<List<CompanyRegistrationModel>> seatsStream =
    UserReservationProvider().getSeatsStream(widget.restaurantid);

  //   @override
  // void initState() {
  //   super.initState();
  //   seatsStream =
  //       ReservationController().getSeatsStream(widget.restaurantid);
  // }


 
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


  final List<String> events = ["Casual Reservation","Birthday Parties", "Groom to be", "Bride to be","Mom to be","Reunions","Anniversaries","Farewell","Meetings"];




  
  final List<String> durations = ["30 Minutes", "1 Hour", "2 Hours"];

   TimeOfDay _stringToTimeOfDay(String time) {
    final parsed = DateFormat("h:mm a").parse(time);
    return TimeOfDay(
      hour: parsed.hour,
      minute: parsed.minute,
    );
  }

 Timestamp _timeOfDayToTimestamp(TimeOfDay time, DateTime date) {
  final dateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
  return Timestamp.fromDate(dateTime);
}

List<String> getFilteredTimeSlots(DateTime? selectedDate) {
  if (selectedDate == null) return timeSlots;

  DateTime now = DateTime.now();

  bool isToday =
      selectedDate.year == now.year &&
      selectedDate.month == now.month &&
      selectedDate.day == now.day;

  if (!isToday) {
    return timeSlots; // show all if not today
  }

  return timeSlots.where((slot) {
    TimeOfDay slotTime = _stringToTimeOfDay(slot);

    DateTime slotDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      slotTime.hour,
      slotTime.minute,
    );

    return slotDateTime.isAfter(now); // only future times
  }).toList();
}


// String? selectedTime;
List<String> filteredSlots = [];
void updateTimeSlots(DateTime selectedDate, BuildContext context) {
  filteredSlots = getFilteredTimeSlots(selectedDate);

  // ✅ Only show snackbar if selected time is NOT in filtered list
  if (selectedTimeString != null &&
      !filteredSlots.contains(selectedTimeString)) {

    setState(() {
      selectedTimeString = null;
      selectedTimeOfDay = null;
      selectedTimeStamp = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Selected time is no longer available. Please choose another time.",
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final reservationProvider =
      Provider.of<UserReservationProvider>(context);

   final colorScheme = Theme.of(context).colorScheme;
   final textTheme = Theme.of(context).textTheme;
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

                  Row(
              children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
             child: CircleAvatar(
             radius: 60,
             backgroundColor: Colors.grey.shade300,
            foregroundImage: NetworkImage(widget.imageUrl),
          ),
        ),
        
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
        
        
                         LayoutBuilder(
            builder: (context, constraints) {
              double nameFontSize =
                  MediaQuery.of(context).size.width * 0.07; // base scaling
              nameFontSize = nameFontSize.clamp(16.0, 24.0);
              return Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                widget.restaurantName,
                  style: GoogleFonts.tinos(
                    fontSize: nameFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              );
            },
          ),
        
                                
        
                   LayoutBuilder(
                     builder: (context, constraints) {
                       double responsiveFontSize = MediaQuery.of(context).size.width * 0.04;
                       
                       responsiveFontSize = responsiveFontSize.clamp(12.0, 18.0);
                   
                       return Padding(
                         padding: const EdgeInsets.only(left: 3.0),
                         child: Text(
                            widget.restourentLocation,
                           style: GoogleFonts.tinos(
                             fontSize: responsiveFontSize,
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                           ),
                           softWrap: true,
                           overflow: TextOverflow.visible,
                         ),
                       );
                     },
                   ),
        
               
                  ],
                )
              ],
            ),
        
              
                
                
                
                
                
                
                const SizedBox(height: 16),

                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter Some Basic Details",style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.06,
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


            


           
        
                // Time dropdown
   DropdownButtonFormField<String>(
     decoration: const InputDecoration(
       labelText: "Select Time",
       border: OutlineInputBorder(),
     ),
     items: timeSlots
         .map((e) => DropdownMenuItem(value: e, child: Text(e)))
         .toList(),
     onChanged: (val) {
       setState(() {
         selectedTimeString = val;
   
         if (val != null) {
           selectedTimeOfDay = _stringToTimeOfDay(val);
   
           // ⬇️ convert to Firestore Timestamp (requires date)
           if (selectedDate != null) {
   selectedTimeStamp =
       _timeOfDayToTimestamp(selectedTimeOfDay!, selectedDate!);
           }
         }
       });
     },
     validator: (val) => val == null ? "Please select a time" : null,
   ),




                const SizedBox(height: 24),

               


                  
 Wrap(
  spacing: screenWidth * 0.03,
  runSpacing: 8,
  children: [
    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: 30,
          groupValue: selectedDuration,
          onChanged: (value) {
            setState(() => selectedDuration = value);
          },
        ),
        Text(
          "30 Minutes",
          style: TextStyle(
            fontSize: screenWidth * 0.035, // responsive
          ),
        ),
      ],
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: 60,
          groupValue: selectedDuration,
          onChanged: (value) {
            setState(() => selectedDuration = value);
          },
        ),
        Text(
          "1 Hour",
          style: TextStyle(
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<int>(
          value: 120,
          groupValue: selectedDuration,
          onChanged: (value) {
            setState(() => selectedDuration = value);
          },
        ),
        Text(
          "2 Hours",
          style: TextStyle(
            fontSize: screenWidth * 0.035,
          ),
        ),
      ],
    ),
  ],
),




       Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Select the Date",style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                      )),
                    ),
                  ),
               
               //date i taken from other page
                   DateSelector(
                   onDateSelected: (date) {
                     setState(() {
                       selectedDate = date; // store in your Reservation state
                     });
                         updateTimeSlots(date,context); 
                   },
                 ),










               Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Available Tables",style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                      )),
                    ),
                  ),





/////

if (selectedDate == null || selectedTimeOfDay == null || selectedDuration == null)
//show empty table number
  Column(
    children: [

        Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    //table 2 people


  Image.asset(
    "assets/tables/t2r.png",
    width: screenWidth * 0.27,
    height: screenWidth * 0.27,
  ),
  
  

    const SizedBox(width: 10),

     //table 4 people
   
  Image.asset(
    "assets/tables/t4r.png",
    width: screenWidth * 0.27,
    height: screenWidth * 0.27,
  ),
  
 
    const SizedBox(width: 10),
    

    //table 6 people
    Image.asset(
      "assets/tables/t6r.png",
      width: screenWidth * 0.30,
      height: screenWidth * 0.30,
    ),
    
    
  ],
),

//Row1 table ends

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [


    //table 8 people
    Image.asset(
      "assets/tables/t8r.png",
      width: screenWidth * 0.40,
      height: screenWidth * 0.40,
    ),
    




    const SizedBox(width: 10),
     //table 10 people

       Image.asset(
         "assets/tables/t10r.png",
         width: screenWidth * 0.45,
         height: screenWidth * 0.45,
       ),
       
    
  ],
),





    ],
  )




else
 StreamBuilder<Map<int, int>>(
  stream: reservationProvider.checkSlotAvailabilityWithSeats(
    restaurantId: widget.restaurantid,
    selectedDate: selectedDate!,
    selectedTime: selectedTimeOfDay!,
    duration: selectedDuration!,
  ),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: Text("Checking availability..."));
    }

    final seats = snapshot.data!;

    final table2Seats  = seats[2]  ?? 0;
    final table4Seats  = seats[4]  ?? 0;
    final table6Seats  = seats[6]  ?? 0;
    final table8Seats  = seats[8]  ?? 0;
    final table10Seats = seats[10] ?? 0;

    return Column(
      children: [
        const SizedBox(height: 10),

        /// ================= ROW 1 =================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// -------- TABLE 2 --------
            GestureDetector(
              onTap: table2Seats > 0
                  ? () => setState(() => isTable2Selected = !isTable2Selected)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: table2Seats == 0
                        ? 0.3
                        : (isTable2Selected ? 0.4 : 1.0),
                    child: Image.asset(
                      "assets/tables/t2r.png",
                      width: screenWidth * 0.27,
                      height: screenWidth * 0.27,
                    ),
                  ),
                  Text(
                    table2Seats == 0
                        ? "Not Available"
                        : (isTable2Selected ? "Selected" : table2Seats.toString()),
                    style: GoogleFonts.tinos(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: table2Seats == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// -------- TABLE 4 --------
            GestureDetector(
              onTap: table4Seats > 0
                  ? () => setState(() => isTable4Selected = !isTable4Selected)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: table4Seats == 0
                        ? 0.3
                        : (isTable4Selected ? 0.4 : 1.0),
                    child: Image.asset(
                      "assets/tables/t4r.png",
                      width: screenWidth * 0.27,
                      height: screenWidth * 0.27,
                    ),
                  ),
                  Text(
                    table4Seats == 0
                        ? "Not Available"
                        : (isTable4Selected ? "Selected" : table4Seats.toString()),
                    style: GoogleFonts.tinos(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: table4Seats == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// -------- TABLE 6 --------
            GestureDetector(
              onTap: table6Seats > 0
                  ? () => setState(() => isTable6Selected = !isTable6Selected)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: table6Seats == 0
                        ? 0.3
                        : (isTable6Selected ? 0.4 : 1.0),
                    child: Image.asset(
                      "assets/tables/t6r.png",
                      width: screenWidth * 0.30,
                      height: screenWidth * 0.30,
                    ),
                  ),
                  Text(
                    table6Seats == 0
                        ? "Not Available"
                        : (isTable6Selected ? "Selected" : table6Seats.toString()),
                    style: GoogleFonts.tinos(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: table6Seats == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// ================= ROW 2 =================
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// -------- TABLE 8 --------
            GestureDetector(
              onTap: table8Seats > 0
                  ? () => setState(() => isTable8Selected = !isTable8Selected)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: table8Seats == 0
                        ? 0.3
                        : (isTable8Selected ? 0.4 : 1.0),
                    child: Image.asset(
                      "assets/tables/t8r.png",
                      width: screenWidth * 0.40,
                      height: screenWidth * 0.40,
                    ),
                  ),
                  Text(
                    table8Seats == 0
                        ? "Not Available"
                        : (isTable8Selected ? "Selected" : table8Seats.toString()),
                    style: GoogleFonts.tinos(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: table8Seats == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            /// -------- TABLE 10 --------
            GestureDetector(
              onTap: table10Seats > 0
                  ? () => setState(() => isTable10Selected = !isTable10Selected)
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: table10Seats == 0
                        ? 0.3
                        : (isTable10Selected ? 0.4 : 1.0),
                    child: Image.asset(
                      "assets/tables/t10r.png",
                      width: screenWidth * 0.45,
                      height: screenWidth * 0.45,
                    ),
                  ),
                  Text(
                    table10Seats == 0
                        ? "Not Available"
                        : (isTable10Selected ? "Selected" : table10Seats.toString()),
                    style: GoogleFonts.tinos(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: table10Seats == 0
                          ? Colors.black
                          : const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  },
),

/////
                  
        
                  
                  // Table .....................


         StreamBuilder<List<CompanyRegistrationModel>>(
  stream: seatsStream,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }

    final companySeats = snapshot.data ?? [];

    // // Example: assume each CompanyRegistrationModel has `table2Seats`, `table4Seats`, etc.
    // int table2Seats = companySeats.isNotEmpty ? companySeats[0].twoSeat : 0;
    // // int table2Seats = 0;
    // int table4Seats = companySeats.isNotEmpty ? companySeats[0].fourSeat : 0;
    // int table6Seats = companySeats.isNotEmpty ? companySeats[0].sixSeat : 0;
    // int table8Seats = companySeats.isNotEmpty ? companySeats[0].eightSeat : 0;
    
    // int table10Seats = companySeats.isNotEmpty ? companySeats[0].tenSeat : 0;
    int depositAmount = companySeats.isNotEmpty ? companySeats[0].reservationAmount : 0;

    //     int totalSeats =
    // (table2Seats * 2) +
    // (table4Seats * 4) +
    // (table6Seats * 6) +
    // (table8Seats * 8) +
    // (table10Seats * 10);

    return Column(
      children: [
      


   Padding(
     padding: const EdgeInsets.all(12.0),
     child: Row(
       children: [

       Text("Reservation fee: $depositAmount",style: GoogleFonts.tinos(
       fontSize: screenWidth * 0.05,
       fontWeight: FontWeight.bold,
       color: const Color.fromARGB(255, 75, 2, 2),
       )),

       
     
                        const Spacer(),

ElevatedButton(
  onPressed: () async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a duration")),
      );
      return;
    }

    if (selectedDate == null ||
        selectedTimeOfDay == null ||
        selectedDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date, time and duration")),
      );
      return;
    }

    if (selectedDate == null) {
      final now = DateTime.now();
      selectedDate = DateTime(now.year, now.month, now.day);
    }

    final selectedTables = [
      if (isTable2Selected) "2",
      if (isTable4Selected) "4",
      if (isTable6Selected) "6",
      if (isTable8Selected) "8",
      if (isTable10Selected) "10",
    ];

    if (selectedTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a table")),
      );
      return;
    }

    final reservationProvider =
        Provider.of<UserReservationProvider>(context, listen: false);

    final userId = FirebaseAuth.instance.currentUser!.uid;

    final reservation = ReservationModel(
      restaurantId: widget.restaurantid,
      userId: userId,
      guests: selectedPeople!,
      time: selectedTimeStamp!,
      duration: selectedDuration ?? 30,
      date: selectedDate!,
      tables: selectedTables,
      depositAmount: depositAmount,
      createdAt: Timestamp.now(),
    );

    await reservationProvider.addReservation(reservation, context);

    _formKey.currentState?.reset();

    setState(() {
      selectedPeople = null;
      selectedDuration = null;
      isTable2Selected = false;
      isTable4Selected = false;
      isTable6Selected = false;
      isTable8Selected = false;
      isTable10Selected = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ReservationConformationPage(),
      ),
    );
  },

  style: ElevatedButton.styleFrom(
    backgroundColor: reservationProvider.isLoading
        ? Colors.grey[100]
        : Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(screenWidth * 0.03),
    ),
    padding: EdgeInsets.all(screenWidth * 0.04),
  ),

  child: reservationProvider.isLoading
      ? SizedBox(
          width: screenWidth * 0.05,
          height: screenWidth * 0.05,
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : Icon(
          Icons.arrow_forward,
          size: screenWidth * 0.08,
        ),
)


      
       ],
     ),
   ),
    
      ],
    );
  },
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
