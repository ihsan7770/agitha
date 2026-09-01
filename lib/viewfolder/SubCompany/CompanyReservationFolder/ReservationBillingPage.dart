import 'package:agitha/ControllersFolder/RestaurantReservationController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ReservationBillPage extends StatefulWidget {
  final String? reservationId;

  const ReservationBillPage({super.key, required this.reservationId});

  @override
  State<ReservationBillPage> createState() => _ReservationBillPageState();
}

class _ReservationBillPageState extends State<ReservationBillPage> {
  String? selectedDishId; // store selected dish's ID
  final qtyController = TextEditingController(text: "1");
  bool _isDialogSending = false;

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  Future<void> _sendBill(BuildContext context) async {
    final provider = context.read<RestaurantReservationController>();
    setState(() => _isDialogSending = true);

    try {
      await provider.sendBill(reservationId: widget.reservationId!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Bill sent successfully")),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isDialogSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantReservationController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;  

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bill"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: provider.billItems.isEmpty || _isDialogSending
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text("Send Bill"),
                          content: const Text(
                              "Are you sure you want to send this bill?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (!_isDialogSending) Navigator.pop(dialogContext);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: _isDialogSending
                                  ? null
                                  : () async {
                                      Navigator.pop(dialogContext);
                                      await _sendBill(context);
                                    },
                              child: _isDialogSending
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text("Send",style: TextStyle(color: Colors.white),)
                            ),
                          ],
                        ),
                      );
                    },
              child: const Text("Send",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// BILL ITEMS LIST
            Expanded(
              child: provider.billItems.isEmpty
                  ? const Center(child: Text("No items added"))
                  : ListView.builder(
  itemCount: provider.billItems.length,
  itemBuilder: (context, index) {
    final item = provider.billItems[index];

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenHeight * 0.008,
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.015),
        child: ListTile(
          contentPadding: EdgeInsets.zero,

          /// Dish name
          title: Text(
            item["dish"],
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),

          /// Qty + price
          subtitle: Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.005),
            child: Text(
              "Qty: ${item["qty"]}  |  Price: ₹${item["price"]}",
              style: TextStyle(
                fontSize: screenWidth * 0.038,
                color: Colors.grey[700],
              ),
            ),
          ),

          /// Total price
          trailing: Text(
            "₹${item["qty"] * item["price"]}",
            style: TextStyle(
              fontSize: screenWidth * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Delete button
          leading: IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: screenWidth * 0.055,
            ),
            onPressed: () => provider.removeItem(index),
          ),
        ),
      ),
    );
  },
)
            ),

            const Divider(),

            /// DISH SELECT + QUANTITY + TOTAL
            StreamBuilder<List<FoodItemModel>>(
              stream: provider.getFoodItemsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final foodList = snapshot.data!;
                if (foodList.isEmpty) return const Text("No dishes found");

                // Update provider.latestFoodItems automatically
                provider.latestFoodItems = foodList;

                final selectedDish = selectedDishId != null
                    ? foodList.firstWhere((f) => f.id == selectedDishId)
                    : null;

                final quantity = int.tryParse(qtyController.text) ?? 0;
                final totalPrice = selectedDish != null
    ? (selectedDish.price is num
        ? (selectedDish.price as num) * quantity
        : double.tryParse(selectedDish.price.toString())! * quantity)
    : 0;


                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Dish Name",
                        border: OutlineInputBorder(),
                      ),
                      value: selectedDishId,
                      items: foodList.map((food) {
                        return DropdownMenuItem<String>(
                          value: food.id,
                          child: Text(food.dishName ?? 'Unknown'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDishId = value;
                          qtyController.text = "1"; // reset quantity
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: qtyController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Quantity",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (_) {
                              setState(() {}); // recalc total
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Price: ${selectedDish != null ? selectedDish.price.toString() : '0'}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Total: ₹$totalPrice",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 12),

            /// ADD ITEM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Item",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (selectedDishId == null ||
                      qtyController.text.isEmpty ||
                      int.tryParse(qtyController.text) == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fill all fields properly")),
                    );
                    return;
                  }

                  final selectedDish = provider.latestFoodItems
                      .firstWhere((f) => f.id == selectedDishId);

                  provider.addItem(
                    dish: selectedDish.dishName ?? '',
                    qty: int.parse(qtyController.text),
                    price: double.tryParse(selectedDish.price.toString()) ?? 0,
                  );

                  setState(() {
                    selectedDishId = null;
                    qtyController.text = "1";
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
