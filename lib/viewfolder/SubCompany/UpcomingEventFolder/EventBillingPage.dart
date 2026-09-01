import 'package:agitha/ControllersFolder/RestaurentEventBookingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EventBillingPage extends StatefulWidget {
  final String? eventId;
  final String? eventType;
  final String? noGuests;
  final String? amount;
  final String? decorationType;
  final List<dynamic>? cakes;
  final List<dynamic>? bakery;
  final List<dynamic>? eventFoodData;
  final String? docorationsuggestion;
  final String? paidsuggestioncake; 
  final String? cakeDecorationprice;
  final String? userId;


  const EventBillingPage({
    super.key,
    required this.eventId,
    required this.eventType,
    required this.noGuests,
    required this.amount,
    required this.decorationType,
    required this.cakes,
    required this.bakery,
    required this.eventFoodData,
    required this.docorationsuggestion,
    required this.paidsuggestioncake,
    required this.cakeDecorationprice,
    required this.userId,
  
  });

  @override
  State<EventBillingPage> createState() => _EventBillingPageState();
}

class _EventBillingPageState extends State<EventBillingPage> {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController decorationPriceController =
    TextEditingController();
  double totalAmount = 0;

bool showPriceField = true;
int foodPrice = 0;

List<Map<String, dynamic>> addedFoodItems = [];


double totalDecorationAmount = 0;

bool showDecorationPriceField = true;
int decorationPrice = 0;

int safeValue(String? v) => int.tryParse(v ?? '') ?? 0;

// void calculateDecorationTotal(String? value) {
//   final decorations = safeValue(widget.amount);
//   final decorationPrice = safeValue(value);

//   setState(() {
//     totalDecorationAmount =
//         (decorations + decorationPrice).toDouble();
//   });
// }



void calculateTotalFood() {
  double total = 0;

  for (var food in addedFoodItems) {
    total += (food['price'] * food['qty']);
  }

  setState(() {
    totalAmount = total;
  });
}



 double getGrandTotal() {
  // ✅ 1. Food total (already calculated correctly)
  final foodTotal = totalAmount;

  // ✅ 2. Decoration total
  final decorationTotal = totalDecorationAmount;

  // ✅ 3. Cake total
  double cakeTotal = 0;
  if (widget.cakes != null) {
    for (var cake in widget.cakes!) {
      cakeTotal += double.tryParse(
            cake["calculatedPrice"]?.toString() ?? '0',
          ) ??
          0;
    }

    cakeTotal += double.tryParse(
          widget.cakeDecorationprice ?? '0',
        ) ??
        0;
  }

  // ✅ 4. Bakery total
  double bakeryTotal = 0;
  if (widget.bakery != null) {
    for (var bakery in widget.bakery!) {
      bakeryTotal += double.tryParse(
            bakery["price"]?.toString() ?? '0',
          ) ??
          0;
    }
  }

  // ✅ 5. FINAL GRAND TOTAL
  return foodTotal + decorationTotal + cakeTotal + bakeryTotal  ;
}





  void calculateTotal(String value) {
    final guests = int.tryParse(widget.noGuests ?? '0') ?? 0;
    final foodPrice= double.tryParse(value) ?? 0;
    setState(() {
      totalAmount = guests * foodPrice;
    });
  }




Future<Map<String, dynamic>?> showFoodAutocompleteAlert(BuildContext context, String noguests) {
  final TextEditingController foodController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController(text: noguests);

  // Create a map for food name → price
  final Map<String, double> foodPriceMap = {
    for (var food in widget.eventFoodData!)
      (food['name']?.toString() ?? ''): double.tryParse(food['price']?.toString() ?? '0') ?? 0
  };

  final List<String> foodNames = foodPriceMap.keys.toList();

  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        surfaceTintColor: Colors.white,
        title: const Text("Add Food Item"),
        content: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🍔 FOOD AUTOCOMPLETE
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue value) {
                    // Show all options if nothing typed
                    return foodNames.where(
                      (e) => value.text.isEmpty ||
                          e.toLowerCase().contains(value.text.toLowerCase()),
                    );
                  },

                  onSelected: (selection) {
                    foodController.text = selection;

                    // ✅ Fill price automatically if exists
                    if (foodPriceMap.containsKey(selection)) {
                      priceController.text = foodPriceMap[selection]!.toString();
                    }
                  },

                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    controller.text = foodController.text;

                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        labelText: "Food Name",
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            focusNode.requestFocus();
                          },
                        ),
                      ),
                      onChanged: (val) {
                        foodController.text = val;
                        // Optional: Clear price if user types a new food
                        if (!foodPriceMap.containsKey(val)) {
                          priceController.text = '';
                        }
                      },
                    );
                  },

                  optionsViewBuilder: (context, onSelected, options) {
                    const double itemHeight = 48;
                    const double maxHeight = 200;
                    final double height = (options.length * itemHeight).clamp(0, maxHeight).toDouble();

                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.67,
                          height: height,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);
                              return SizedBox(
                                height: itemHeight,
                                child: ListTile(
                                  dense: true,
                                  title: Text(option),
                                  onTap: () => onSelected(option),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                /// 💰 PRICE & 🔢 QTY IN A ROW
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Price",
                          prefixText: "₹ ",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: qtyController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Qty",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white
        ),
            onPressed: () {
              if (foodController.text.isEmpty ||
                  priceController.text.isEmpty ||
                  qtyController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              final selectedFood = {
                "name": foodController.text,
                "price": double.parse(priceController.text),
                "qty": int.parse(qtyController.text),
              };

              print("Food Added: $selectedFood");

              Navigator.pop(context, selectedFood);
            },
            child: const Text("ADD"),
          ),
        ],
      );
    },
  );
}



@override
void initState() {
  super.initState();

  // ✅ Default decoration total = base amount
  totalDecorationAmount =
      double.tryParse(widget.amount ?? '0') ?? 0;
}

void calculateDecorationTotal(String? value) {
  final baseDecoration = safeValue(widget.amount);
  final extraDecoration = safeValue(value);

  setState(() {
    totalDecorationAmount =
        (baseDecoration + extraDecoration).toDouble();
  });
}




  @override
  void dispose() {
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Billing"),
        centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Card(
                surfaceTintColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              
                      /// Guests
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Guests",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600)),
                          Text(widget.noGuests ?? "0",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05, color: Colors.grey[700])),
                        ],
                      ),
              
                      const SizedBox(height: 10),
              
                      /// Event Type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Event Type",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600)),
                          Text(widget.eventType ?? "-",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05, color: Colors.grey[700])),
                        ],
                      ),
              
                      const SizedBox(height: 10),
              
                      const Divider(height: 30, thickness: 1),
              
                      /// Decoration Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Decoration Amount",
                              style: GoogleFonts.tinos(
                                  fontSize: screenWidth * 0.05, fontWeight: FontWeight.w600)),
                          Text("₹ ${widget.amount ?? '0'}",
                              style: TextStyle(
                                  fontSize: screenWidth * 0.05, color: Colors.grey[700])),
                        ],
                      ),
              
              
              
                 //docration extra price feild
                 if(widget.docorationsuggestion != null && widget.docorationsuggestion!.isNotEmpty) ...[
                      const SizedBox(height: 15),
              
                      /// One Person Price Input
                   showDecorationPriceField
                  ? TextField(
                      controller: decorationPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: calculateDecorationTotal,
                      decoration: InputDecoration(
              hintText: "Extra Decoration Price",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              
              // ➕ PLUS BUTTON
              suffixIcon: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  int currentValue =
                      int.tryParse(decorationPriceController.text) ?? 0;
                 
              
                  setState(() {
                    decorationPrice = currentValue;
                    decorationPriceController.text =
                        currentValue.toString();
                    showDecorationPriceField = false;
                  });
              
                  calculateDecorationTotal(
                      decorationPriceController.text);
                  FocusScope.of(context).unfocus();
                },
              ),
                      ),
                    )
                  : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
               Text(
                " Extra Decoration Price",
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    "₹ $decorationPrice",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                   SizedBox(width: screenWidth * 0.02),
                  IconButton(
                    icon:  Icon(Icons.edit, size: screenWidth * 0.06),
                    onPressed: () {
                      setState(() {
                        showDecorationPriceField = true;
                        decorationPriceController.text =
                            decorationPrice.toString();
                      });
                    },
                  ),
                ],
              ),
                      ],
                    ),
                  ),
              
                  const Divider(thickness: 1),
                          Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Decoration Price",
                    style: GoogleFonts.tinos(
                      fontSize:  screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹ ${totalDecorationAmount.toStringAsFixed(2)}",
                    style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),  
               const Divider(thickness: 1),
                 ],
                       
              
                      
              
                      const SizedBox(height: 15),
              
                      /// ---------------- CAKES ----------------
                  if (widget.cakes != null && widget.cakes!.isNotEmpty) ...[
                Text(
                  "Cakes",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
                const SizedBox(height: 8),
              
                // ---------------- TOTAL CALCULATION ----------------
                Builder(
                  builder: (context) {
                    double totalCakePrice = 0;
              
                    // Sum cake prices
                    for (var cake in widget.cakes!) {
                      final price = double.tryParse(
                  cake["calculatedPrice"]?.toString() ?? "0",
                ) ??
                0;
                      totalCakePrice += price;
                    }
              
                    // Add cake decoration / type price
                    final cakeDecorationPrice = double.tryParse(
                widget.cakeDecorationprice?.toString() ?? "0",
              ) ??
              0;
              
                    totalCakePrice += cakeDecorationPrice;
              
                    return Column(
                      children: [
              // ---------------- CAKE LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cakes!.length,
                itemBuilder: (context, index) {
                  final cake = widget.cakes![index];
                  final name = cake["name"] ?? "Cake";
                  final price = cake["calculatedPrice"] ?? "0";
                  final cakeDecorationPriceText =
                      widget.cakeDecorationprice ?? "0";
              
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(name,style: TextStyle(fontSize: screenWidth * 0.04),),
                            Text("₹ $price",style: TextStyle(fontSize: screenWidth * 0.04)),
                          ],
                        ),
                      ),
              
                      // Cake Type Row
                     
                            ],
                          );
                        },
                      ),

                       if (widget.paidsuggestioncake != null && widget.paidsuggestioncake!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Cake Type: ",
                                  style: GoogleFonts.tinos(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: widget.paidsuggestioncake ?? "No Cake Type",
                                      style: GoogleFonts.tinos(
                                        fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text("₹ ${cakeDecorationPrice}",style: TextStyle(fontSize: screenWidth * 0.04)),
                                    ],
                                  ),
                                ),
              
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              
              // ---------------- TOTAL ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Cake Price",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "₹ ${totalCakePrice.toStringAsFixed(0)}",
                          style: GoogleFonts.tinos(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        
                      ],
                    ),
                    const Divider(thickness: 1),
                  ],
                );
              },
                      ),
                    
                      const SizedBox(height: 8),
                    ],
              
              
              
              
                      /// ---------------- CAKES ----------------
                     if (widget.bakery != null && widget.bakery!.isNotEmpty) ...[
                Text(
                  "Bakery Items",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              
                const SizedBox(height: 8),
              
                // ---------------- TOTAL CALCULATION ----------------
                Builder(
                  builder: (context) {
                    double totalBakeryPrice = 0;
              
                    // Sum all bakery item prices
                    for (var bakery in widget.bakery!) {
                      final price = double.tryParse(
                  bakery["price"]?.toString() ?? "0",
                ) ??
                0;
              
                      totalBakeryPrice += price;
                    }
              
                    return Column(
                      children: [
              // ---------------- BAKERY LIST ----------------
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.bakery!.length,
                itemBuilder: (context, index) {
                  final bakery = widget.bakery![index];
                  final name = bakery["name"] ?? "Bakery Item";
                  final price = bakery["price"] ?? "0";
              
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name,style: TextStyle(fontSize: screenWidth * 0.04)   ),
                        Text("₹ $price",style: TextStyle(fontSize: screenWidth * 0.04)),
                      ],
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              
              // ---------------- TOTAL ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Bakery Price",
                    style: GoogleFonts.tinos(
                      fontSize:  screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "₹ ${totalBakeryPrice.toStringAsFixed(0)}",
                    style: GoogleFonts.tinos(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
               const Divider(thickness: 1),
                      ],
                    );
                  },
                ),
              
                   
                      
                      
                        ],
              
              
                      /// One Person Price Input
                    
     if (widget.eventFoodData != null && widget.eventFoodData!.isNotEmpty) ...[

  const SizedBox(height: 10),

  Text(
    "Food Items",
    style: GoogleFonts.tinos(
      fontSize: screenWidth * 0.05,
      fontWeight: FontWeight.bold,
    ),
  ),

  const SizedBox(height: 8),

  /// ---------------- ADDED FOOD LIST ----------------
  if (addedFoodItems.isNotEmpty) ...[
    ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addedFoodItems.length,
      itemBuilder: (context, index) {
        final food = addedFoodItems[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Food name & qty
              Text(
                "${food['name']} x${food['qty']}",
                style: GoogleFonts.tinos(fontSize: screenWidth * 0.045),
              ),

              /// Price & delete
              Row(
                children: [
                  Text(
                    "₹ ${(food['price'] * food['qty']).toStringAsFixed(0)}",
                    style: GoogleFonts.tinos(fontSize:  screenWidth * 0.045),
                  ),
                  const SizedBox(width: 8),

                  InkWell(
                    onTap: () {
                      setState(() {
                        addedFoodItems.removeAt(index);
                        calculateTotalFood();
                      });
                    },
                    child:  Icon(
                      Icons.delete,
                      color: Colors.red,
                      size:  screenWidth * 0.06,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
     
     const SizedBox(height: 8.0,)
    // const Divider(thickness: 1),
  ],

  /// ---------------- ADD BUTTON ----------------
  InkWell(
    onTap: () async {
      final result = await showFoodAutocompleteAlert(
        context,
        widget.noGuests ?? "0",
      );

      if (result != null) {
        setState(() {
          /// Ensure correct data types
          addedFoodItems.add({
            'name': result['name'],
            'price': double.parse(result['price'].toString()),
            'qty': int.parse(result['qty'].toString()),
          });

          calculateTotalFood();
        });
      }
    },
    borderRadius: BorderRadius.circular(8),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child:  Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, color: Colors.white, size:  screenWidth * 0.06),
          SizedBox(width: 6),
          Text(
            "Add",
            style: TextStyle(
              color: Colors.white,
              fontSize:  screenWidth * 0.035,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  ),

  const Divider(thickness: 1),

  /// ---------------- TOTAL ----------------
  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Total Food Price",
        style: GoogleFonts.tinos(
          fontSize:  screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        "₹ ${totalAmount.toStringAsFixed(2)}",
        style: GoogleFonts.tinos(
          fontSize:  screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  ),
  const Divider(thickness: 1),

],

              
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Bill Amount",
                                        style: GoogleFonts.tinos(
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                        
                                      Text(
                                        "₹ ${getGrandTotal().toStringAsFixed(2)}",
                                        style: GoogleFonts.tinos(
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),  
              
              
                       
                    ],
                  ),
                ),
              ),

              
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Consumer<RestaurantEventController>(
  builder: (context, provider, _) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.isLoading
            ? Colors.grey
            : Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),

      // ❌ Disable button while loading
      onPressed: provider.isLoading
          ? null
          : () async {

             await provider.conformEndEvent(widget.eventId.toString());


              await provider.sendEventBill(
                userId: widget.userId,
                eventId: widget.eventId,
                eventType: widget.eventType,
                noGuests: widget.noGuests,

                baseDecorationAmount: widget.amount,
                extraDecorationPrice: decorationPrice,
                totalDecorationAmount: totalDecorationAmount,

                foodItems: addedFoodItems,
                totalFoodAmount: totalAmount,

                cakes: widget.cakes,
                cakeType: widget.paidsuggestioncake,
                cakeDecorationPrice: widget.cakeDecorationprice,

                bakery: widget.bakery,
                grandTotal: getGrandTotal(),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bill Sent Successfully")),
              );

              Navigator.pop(context);
            },

      child: provider.isLoading
          ? SizedBox(
              height: screenWidth * 0.06,
              width: screenWidth * 0.06,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text("Send Bill",style: TextStyle(fontSize: screenWidth * 0.04),),
    );
  },
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
