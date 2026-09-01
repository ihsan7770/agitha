import 'package:agitha/ControllersFolder/CakeDecorationController.dart';
import 'package:agitha/ControllersFolder/DecorationController.dart';
import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/ModelsFoder/CakeDecorationModel.dart';
import 'package:agitha/ModelsFoder/CompanyRegistrationModel.dart';
import 'package:agitha/ModelsFoder/EventBookingModel.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/BookedEventDetailsFolder/EventConfromationPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/EventPaymentPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:agitha/viewfolder/Widgets/BackeryDetails.dart';
import 'package:agitha/viewfolder/Widgets/CakeDetails.dart';
import 'package:agitha/viewfolder/Widgets/DateCircles.dart';
import 'package:agitha/viewfolder/Widgets/EventFoodSelection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventForm extends StatefulWidget {
  final String imageUrl;
  final String restaurantid;

  final String restaurantName;
  final String restourentLocation;

  const EventForm({
    super.key,
    required this.imageUrl,
    required this.restaurantid,
    required this.restaurantName,
    required this.restourentLocation,
  });
  @override
  State<EventForm> createState() => _ReservationState();
}

class _ReservationState extends State<EventForm> {
  late final Stream<List<FoodItemModel>> cakeStream;

  List<Map<String, dynamic>> selectedCakes = [];
  List<Map<String, dynamic>> selectedBakeryItems = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<UserEventProvider>()
          .fetchDecorationsByRestaurant(widget.restaurantid); // ✅ correct
    });
  }

  String? selectedQuantity; // stores selected value

  final List<String> quantities = ['0.5 kg', '1 kg', '2 kg'];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController decorationsuggestionController =
      TextEditingController();
  final TextEditingController cakesuggestionController =
      TextEditingController();
  final TextEditingController extrafoodsuggestionController =
      TextEditingController();

  int? selectedPeople;
  String? selectedevent;
  String? selectedTime;
  int? selectedDuration;
  DateTime selectedDate = DateTime.now();
  int? depositAmount;
  String? selecteddecoration;
  bool isChecked = false;

  String selectedDecorationName = '';
  String selectedDecorationPrice = '0';

  String? selectedTimeString;
  TimeOfDay? selectedTimeOfDay;
  Timestamp? selectedTimeStamp;

  int? selectedFoodIndex;

  // Example food service options
  final List<String> foodServices = [
    "Buffet",
    "Plated",
    "Family Style",
  ];

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

  // final List<String> events = ["Birthday Parties", "Groom to be", "Bride to be","Mom to be","Reunions","Anniversaries","Farewell","Meetings"];
  List<String> getFilteredTimeSlots(DateTime? selectedDate) {
    if (selectedDate == null) return timeSlots;

    DateTime now = DateTime.now();

    bool isToday = selectedDate.year == now.year &&
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

  CompanyRegistrationModel? cachedCompany;

  bool iscakeSelected = false;
  String cakeChoice = "No";

  bool isCakeDecorationSelected = false;
  String cakeDecorationChoice = "No";

  bool isfoodSelected = false;
  String foodChoice = "No";

  bool isPhotoCakeSelected = false;

//foood

  List<Map<String, dynamic>> selectedFoods = [];

  bool isSelected(String foodId) {
    return selectedFoods.any((e) => e['foodId'] == foodId);
  }

  void toggleFood(food) {
    setState(() {
      if (isSelected(food.id)) {
        selectedFoods.removeWhere((e) => e['foodId'] == food.id);
      } else {
        selectedFoods.add({
          "foodId": food.id,
          "name": food.dishName,
          "price": food.price,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final EventProvider = Provider.of<UserEventProvider>(context);

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
                                MediaQuery.of(context).size.width *
                                    0.07; // base scaling
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
                            double responsiveFontSize =
                                MediaQuery.of(context).size.width * 0.04;

                            responsiveFontSize =
                                responsiveFontSize.clamp(12.0, 18.0);

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
                    child: Text("Enter Some Basic Details",
                        style: GoogleFonts.tinos(
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

                Consumer<UserEventProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const SizedBox.shrink();
                    }

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Select Event",
                        border: OutlineInputBorder(),
                      ),
                      value: provider
                          .selectedDecoration?.docId, // keep provider in sync
                      items: provider.decorations.map((d) {
                        return DropdownMenuItem<String>(
                          value: d.docId, // still use docId as value
                          child: Text(d.eventName),
                        );
                      }).toList(),
                      onChanged: (decorationId) {
                        if (decorationId != null) {
                          // Update provider
                          provider.selectDecorationById(decorationId);

                          // Store event name in local variable
                          setState(() {
                            selectedevent = provider.decorations
                                .firstWhere((d) => d.docId == decorationId)
                                .eventName;
                          });
                        }
                      },
                      validator: (val) =>
                          val == null ? "Please select an event" : null,
                    );
                  },
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Do you want cake ?",
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        )),
                  ),
                ),

                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: cakeChoice,
                      onChanged: (value) {
                        setState(() {
                          cakeChoice = value!;
                          iscakeSelected = true;
                        });
                      },
                    ),
                    const Text("Yes"),
                    Radio<String>(
                      value: "No",
                      groupValue: cakeChoice,
                      onChanged: (value) {
                        setState(() {
                          cakeChoice = value!;
                          iscakeSelected = false;
                        });
                      },
                    ),
                    const Text("No"),
                  ],
                ),

                // Show extra field only if YES selected
                if (iscakeSelected)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      CakeSelectionPage(
                        restaurantid: widget.restaurantid,
                        onSelectionChanged: (cakes) {
                          setState(() {
                            selectedCakes = cakes;
                          });
                        },
                      ),

                      const SizedBox(height: 10),
                      BakerySelectionWidget(
                        restaurantid: widget.restaurantid,
                        onSelectionChanged: (items) {
                          setState(() {
                            selectedBakeryItems = items;
                          });

                          debugPrint("Bakery Selected: $selectedBakeryItems");
                        },
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("Do you want to decorate cake ?",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 75, 2, 2),
                              )),
                        ),
                      ),

                      Row(
                        children: [
                          Radio<String>(
                            value: "Yes",
                            groupValue: cakeDecorationChoice,
                            onChanged: (value) {
                              setState(() {
                                cakeDecorationChoice = value!;
                                isCakeDecorationSelected = true;
                              });
                            },
                          ),
                          const Text("Yes"),
                          Radio<String>(
                            value: "No",
                            groupValue: cakeDecorationChoice,
                            onChanged: (value) {
                              setState(() {
                                cakeDecorationChoice = value!;
                                isCakeDecorationSelected = false;
                              });
                            },
                          ),
                          const Text("No"),
                        ],
                      ),

//backey streme end

//cake decoration details
                      if (isCakeDecorationSelected) ...[
                        Card(
                          surfaceTintColor: Colors.white,
                          margin: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Cake Suggestions",
                                    style: GoogleFonts.tinos(
                                      fontSize: screenWidth * 0.06,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromARGB(255, 75, 2, 2),
                                    ),
                                  ),
                                ),
                              ),

//cake suggestion and amount details
                              StreamBuilder<List<CakeDecorationModel>>(
                                stream: Provider.of<UserEventProvider>(context,
                                        listen: false)
                                    .cakeDecorationsStream(widget.restaurantid),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  final decorations = snapshot.data!;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: List.generate(
                                          decorations.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Row(
                                            children: [
                                              Text("○",
                                                  style: GoogleFonts.tinos(
                                                      fontSize: 16)),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  decorations[index]
                                                      .decorationDetails,
                                                  style: GoogleFonts.tinos(
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                " - ₹${decorations[index].decorationPrice}",
                                                style: GoogleFonts.tinos(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Checkbox(
                                                value: selectedDecorationName ==
                                                    decorations[index]
                                                        .decorationDetails,
                                                onChanged: (v) {
                                                  setState(() {
                                                    if (v == true) {
                                                      selectedDecorationName =
                                                          decorations[index]
                                                              .decorationDetails;
                                                      selectedDecorationPrice =
                                                          decorations[index]
                                                              .decorationPrice;
                                                    } else {
                                                      selectedDecorationName =
                                                          '';
                                                      selectedDecorationPrice =
                                                          "0";
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: cakesuggestionController,
                                  maxLines: 3,
                                  minLines: 3,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Any decoration suggestions or special instructions,color,shape,names etc...",
                                    labelText: "Suggestions...",
                                    alignLabelWithHint:
                                        true, // aligns label at top-left for multiline
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink),
                                    ),
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]
                    ],
                  ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Do you want food ?",
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        )),
                  ),
                ),

                Row(
                  children: [
                    Radio<String>(
                      value: "Yes",
                      groupValue: foodChoice,
                      onChanged: (value) {
                        setState(() {
                          foodChoice = value!;
                          isfoodSelected = true;
                        });
                      },
                    ),
                    const Text("Yes"),
                    Radio<String>(
                      value: "No",
                      groupValue: foodChoice,
                      onChanged: (value) {
                        setState(() {
                          foodChoice = value!;
                          isfoodSelected = false;
                        });
                      },
                    ),
                    const Text("No"),
                  ],
                ),

//food selection
                if (isfoodSelected) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Food service styles",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          )),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(foodServices.length, (index) {
                      final isSelected = selectedFoodIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFoodIndex = index; // select this container
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenWidth *
                                0.015, // responsive vertical padding
                            horizontal: screenWidth *
                                0.05, // responsive horizontal padding
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(
                                screenWidth * 0.03), // responsive
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            foodServices[index],
                            style: GoogleFonts.tinos(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  screenWidth * 0.035, // responsive font size
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("Food items",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          )),
                    ),
                  ),

                  FoodSelectionWidget(
                    restaurantId: widget.restaurantid,
                    onSelectionChanged: (foods) {
                      /// Store the selected food list
                      setState(() {
                        selectedFoods = foods;
                      });
                    },
                  ),

             

                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Extra Food Preferences",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 75, 2, 2),
                          ),
                          children: [
                            TextSpan(
                              text: " (Extra Charge)",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.04, // 👈 smaller text
                                fontWeight: FontWeight.w400,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: TextFormField(
                      controller: extrafoodsuggestionController,
                      maxLines: 3,
                      minLines: 3,
                      decoration: InputDecoration(
                        hintText: "Extra food suggestions",
                        labelText: "Extra Food Suggestions",
                        alignLabelWithHint:
                            true, // aligns label at top-left for multiline
                        border: OutlineInputBorder(),

                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],

                //food selection ends

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Select the Time",
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        )),
                  ),
                ),

                // Time dropdown
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: DropdownButtonFormField<String>(
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
                            selectedTimeStamp = _timeOfDayToTimestamp(
                                selectedTimeOfDay!, selectedDate!);
                          }
                        }
                      });
                    },
                    validator: (val) =>
                        val == null ? "Please select a time" : null,
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // or center / spaceEvenly
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 30 Minutes
                    Transform.scale(
                      scale: 1.0,
                      child: Radio<int>(
                        value: 60,
                        groupValue: selectedDuration,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() => selectedDuration = value);
                        },
                      ),
                    ),
                    Text("1 Hour",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),

                    const SizedBox(width: 10), // spacing between options

                    // 1 Hour
                    Transform.scale(
                      scale: 1.0,
                      child: Radio<int>(
                        value: 120,
                        groupValue: selectedDuration,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() => selectedDuration = value);
                        },
                      ),
                    ),
                    Text("2 Hour",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),

                    const SizedBox(width: 10), // spacing

                    // 2 Hours
                    Transform.scale(
                      scale: 1.0,
                      child: Radio<int>(
                        value: 180,
                        groupValue: selectedDuration,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onChanged: (value) {
                          setState(() => selectedDuration = value);
                        },
                      ),
                    ),
                    Text("3 Hour",
                        style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Select the Date",
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        )),
                  ),
                ),

                DateSelector(
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date; // store in your Reservation state
                    });
                    updateTimeSlots(date, context);
                  },
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text("Decoration",
                        style: GoogleFonts.tinos(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 75, 2, 2),
                        )),
                  ),
                ),

                StreamBuilder<List<CompanyRegistrationModel>>(
                  stream: UserEventProvider()
                      .getDecorationAmountStream(widget.restaurantid),
                  builder: (context, snapshot) {
                    // ✅ Store data once when received
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      cachedCompany = snapshot.data!.first;
                    }

                    // ✅ If cached data exists, use it instead of showing loader
                    if (cachedCompany == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final company = cachedCompany!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// No Decoration
                        Row(
                          children: [
                            Checkbox(
                              value: selecteddecoration == "No decoration",
                              onChanged: (_) {
                                setState(() {
                                  selecteddecoration = "No decoration";
                                  depositAmount = company.noDecorationAmount;
                                });
                              },
                            ),
                            Text(
                              "No decoration  (₹${company.noDecorationAmount})",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),

                        /// Decorate by ourselves

                        Row(
                          children: [
                            Checkbox(
                              value:
                                  selecteddecoration == "Decorate by ourselves",
                              onChanged: (_) {
                                setState(() {
                                  selecteddecoration = "Decorate by ourselves";
                                  depositAmount = company.noDecorationAmount;
                                });
                              },
                            ),
                            Text(
                              "Decorate by ourselves  (₹${company.noDecorationAmount})",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),

                        /// Decorated by restaurant team
                        Row(
                          children: [
                            Checkbox(
                              value: selecteddecoration ==
                                  "Decorated by restaurant team",
                              onChanged: (_) {
                                setState(() {
                                  selecteddecoration =
                                      "Decorated by restaurant team";
                                  depositAmount = company.decorationAmount;
                                });
                              },
                            ),
                            Text(
                              "Decorated by restaurant team  (₹${company.decorationAmount})",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),

                        if (selecteddecoration ==
                            "Decorated by restaurant team")
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 10.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Decoration Details",
                                      style: GoogleFonts.tinos(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 75, 2, 2),
                                      )),
                                ),
                              ),
                              Consumer<UserEventProvider>(
                                builder: (context, provider, _) {
                                  final d = provider.selectedDecoration;

                                  if (d == null) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: BorderSide.strokeAlignCenter),
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.transparent,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "Select event type to view decoration details",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return Card(
                                    surfaceTintColor: Colors.white,
                                    child: ListTile(
                                      title: Text(
                                        d.eventName,
                                        style: GoogleFonts.tinos(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(d.decorationDetails),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "User Preferences ",
                                      style: GoogleFonts.tinos(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 75, 2, 2),
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "(Extra Charge)",
                                          style: GoogleFonts.tinos(
                                            fontSize: 14, // 👈 smaller text
                                            fontWeight: FontWeight.w400,
                                            color: Colors.red.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                  controller: decorationsuggestionController,
                                  maxLines: 3,
                                  minLines: 3,
                                  decoration: const InputDecoration(
                                    hintText:
                                        "Any decoration suggestions or special instructions?\nEg: color theme, flowers, balloons...",
                                    labelText: "Decoration Suggestions",
                                    alignLabelWithHint:
                                        true, // aligns label at top-left for multiline
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink),
                                    ),
                                    contentPadding: EdgeInsets.all(12),
                                  ),
                                ),
                              ),
                            ],
                          ),

                     
                      ],
                    );
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                StreamBuilder<bool>(
                  stream: (selectedDate != null &&
                          selectedTimeOfDay != null &&
                          selectedDuration != null)
                      ? UserEventProvider().checkEventSlotAvailability(
                          eventId: widget.restaurantid,
                          selectedDate: selectedDate!,
                          selectedTime: selectedTimeOfDay!,
                          duration: selectedDuration!,
                        )
                      : const Stream.empty(),
                  builder: (context, snapshot) {
                    // While checking
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      );
                    }

                    final isAvailable = snapshot.data ?? true;

                    // ❌ SLOT BOOKED UI
                    if (!isAvailable) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock_clock, color: Colors.black54),
                              SizedBox(width: 8),
                              Text(
                                "Slot Booked",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // ✅ SHOW BUTTON
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (selectedDuration == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please select a duration")),
                                );
                                return;
                              }

                              if (selectedevent == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please select a event")),
                                );
                                return;
                              }

                              if (selecteddecoration == null ||
                                  selecteddecoration!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please select a decoration")),
                                );
                                return;
                              }

                              if (selectedDate == null ||
                                  selectedTimeOfDay == null ||
                                  selectedDuration == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please select date, time and duration")),
                                );
                                return;
                              }

                              if (selectedCakes.isEmpty &&
                                  cakeChoice == "Yes") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Please select at least one cake"),
                                  ),
                                );
                                return;
                              }

                              if (selectedFoods.isEmpty &&
                                  foodChoice == "Yes") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please select at least one food item"),
                                  ),
                                );
                                return;
                              }

                              if (selectedFoodIndex == null &&
                                  foodChoice == "Yes") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please select food service style"),
                                  ),
                                );
                                return;
                              }

                              // Debug prints for all selected data
                              print("===== DEBUG EVENT DATA =====");
                              print("Restaurant ID: ${widget.restaurantid}");
                              print(
                                  "User ID: ${FirebaseAuth.instance.currentUser!.uid}");
                              print("Event Type: $selectedevent");
                              print("Guests: $selectedPeople");
                              print("Time: $selectedTimeStamp");
                              print("Date: $selectedDate");
                              print("Duration: $selectedDuration");
                              print("Cake Selected: $selectedCakes");
                              print("Bakery Selected: $selectedBakeryItems");
                              print("Decoration: $selecteddecoration");
                              print("Deposit Amount: $depositAmount");
                              print("=============================");

                              final reservationProvider =
                                  Provider.of<UserEventProvider>(context,
                                      listen: false);

                              final userId =
                                  FirebaseAuth.instance.currentUser!.uid;

                              final event = EventModel(
                                restaurantId: widget.restaurantid,
                                userId: userId,
                                eventType: selectedevent.toString(),
                                guests: selectedPeople!,
                                time: selectedTimeStamp!,
                                duration: selectedDuration!,
                                date: selectedDate,
                                decorationType: selecteddecoration!,
                                depositAmount: depositAmount!,
                                paidsuggestioncake: selectedDecorationName,
                                cakeDecorationprice: selectedDecorationPrice,
                                decorationSuggestion:
                                    decorationsuggestionController.text.trim(),
                                cakeData:
                                    selectedCakes.isEmpty ? [] : selectedCakes,
                                bakeryData: selectedBakeryItems.isEmpty
                                    ? []
                                    : selectedBakeryItems,
                                eventFoodData:
                                    selectedFoods.isEmpty ? [] : selectedFoods,
                                foodServiceType: selectedFoodIndex != null
                                    ? foodServices[selectedFoodIndex!]
                                    : "No food service",
                                foodSuggestion: extrafoodsuggestionController
                                        .text
                                        .trim()
                                        .isEmpty
                                    ? "No food details given by user"
                                    : extrafoodsuggestionController.text.trim(),
                                cakesuggestion:
                                    cakesuggestionController.text.trim().isEmpty
                                        ? "No cake details given by user"
                                        : cakesuggestionController.text.trim(),
                                createdAt: Timestamp.now(),
                              );

                              await reservationProvider.addEvent(
                                  event, context);

                              _formKey.currentState?.reset();

                              setState(() {
                                selectedPeople = null;
                                selectedevent = null;
                                selectedDuration = null;
                                depositAmount = null;
                                selecteddecoration = null;
                                selectedCakes = [];
                                selectedBakeryItems = [];
                                cakesuggestionController.clear();
                                decorationsuggestionController.clear();
                                extrafoodsuggestionController.clear();
                                foodChoice = "No";
                                isfoodSelected = false;
                                selectedFoods = [];
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EventConformationPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: EventProvider.isLoading
                                  ? Colors.grey[100]
                                  : Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: EventProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text("Book Event")),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
