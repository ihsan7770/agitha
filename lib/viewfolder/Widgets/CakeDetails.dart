import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';

class CakeSelectionPage extends StatefulWidget {
  final String restaurantid;

  /// ✅ sends selected cakes to parent (EventForm)
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

  const CakeSelectionPage({
    super.key,
    required this.restaurantid,
    required this.onSelectionChanged,
  });

  @override
  State<CakeSelectionPage> createState() => _CakeSelectionPageState();
}

class _CakeSelectionPageState extends State<CakeSelectionPage> {
  late final Stream<List<FoodItemModel>> cakeStream;

  /// stores selected cake details
  List<Map<String, dynamic>> selectedCakes = [];

  final List<String> weights = ["0.5 Kg", "1 Kg", "2 Kg"];
  final List<String> quantities = ["1", "2", "3"];

  @override
  void initState() {
    super.initState();
    cakeStream =
        UserEventProvider().streamUserCakeItems(widget.restaurantid);
  }

  /// notify parent page
  void _notifyParent() {
    widget.onSelectionChanged(List.from(selectedCakes));
  }

  bool isCakeChecked(String id) {
    return selectedCakes.any((c) => c["id"] == id);
  }

  Map<String, dynamic>? getCake(String id) {
    try {
      return selectedCakes.firstWhere((c) => c["id"] == id);
    } catch (_) {
      return null;
    }
  }

  /// ✅ calculate price based on weight and quantity
  double calculatePrice(FoodItemModel cake, String weight, String quantity) {
    double multiplier = 1;
    if (weight == "0.5 Kg") {
      multiplier = 0.5;
    } else if (weight == "2 Kg") {
      multiplier = 2;
    }
    return double.parse(cake.price.toString()) * multiplier * int.parse(quantity);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FoodItemModel>>(
      stream: cakeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final cakes = snapshot.data!;

        if (cakes.isEmpty) {
          return const Center(child: Text("No cakes found"));
        }

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cakes.length,
            itemBuilder: (context, index) {
              final cake = cakes[index];

              final isChecked = isCakeChecked(cake.id);
              final selectedCake = getCake(cake.id);

              final selectedWeight = selectedCake?["weight"] ?? "1 Kg";
              final selectedQty = selectedCake?["quantity"] ?? "1";

              return InkWell(
                onTap: () => _showCakeDialog(cake),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    width: 180,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Image only if not selected
                        if (!isChecked)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              cake.imageUrl,
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                               errorBuilder: (context, error, stackTrace) =>
                                const NoInternetWidget(
                                width: double.infinity,
                                height: 90,
                                iconSize: 30,
                                textSize: 14,
     
                                )

                              
                            ),
                          ),

                        /// Name + checkbox
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  cake.dishName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Checkbox(
                                value: isChecked,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (v) {
                                  setState(() {
                                    if (v == true) {
                                      selectedCakes.add({
                                        "id": cake.id,
                                        "name": cake.dishName,
                                        "price": double.parse(cake.price.toString()), // ✅ double
                                        "weight": "1 Kg",
                                        "quantity": "1",
                                        "calculatedPrice": double.parse(cake.price.toString()), // ✅ double
                                      });
                                    } else {
                                      selectedCakes.removeWhere(
                                          (c) => c["id"] == cake.id);
                                    }
                                  });
                                  _notifyParent();
                                },
                              ),
                            ],
                          ),
                        ),

                        /// Show base price if not selected
                        if (!isChecked)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "₹${cake.price}",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600,
                                  color: Colors.grey
                                  ),
                            ),
                          ),

                        /// Selections
                        if (isChecked)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Weight
                              const Padding(
                                padding: EdgeInsets.only(left: 8, bottom: 5),
                                child: Text(
                                  "Select Weight",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, top: 4),
                                child: Row(
                                  children: weights.map((w) {
                                    final isSel = selectedWeight == w;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          final i = selectedCakes.indexWhere(
                                              (c) => c["id"] == cake.id);
                                          selectedCakes[i]["weight"] = w;
                                          // ✅ Update calculatedPrice
                                          selectedCakes[i]["calculatedPrice"] =
                                              calculatePrice(cake, w,
                                                  selectedCakes[i]["quantity"]);
                                        });
                                        _notifyParent();
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: isSel
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.grey.shade200,
                                        ),
                                        child: Text(
                                          w,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: isSel
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              /// Quantity
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 8, top: 10, bottom: 6),
                                child: Text(
                                  "Select Quantity",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 6, bottom: 4),
                                child: Row(
                                  children: quantities.map((q) {
                                    final isSel = selectedQty == q;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          final i = selectedCakes.indexWhere(
                                              (c) => c["id"] == cake.id);
                                          selectedCakes[i]["quantity"] = q;
                                          // ✅ Update calculatedPrice
                                          selectedCakes[i]["calculatedPrice"] =
                                              calculatePrice(cake,
                                                  selectedCakes[i]["weight"], q);
                                        });
                                        _notifyParent();
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 6),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: isSel
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey),
                                          color: isSel
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.white,
                                        ),
                                        child: Text(
                                          q,
                                          style: TextStyle(
                                              color:
                                                  isSel ? Colors.white : Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                              /// Calculated Price
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 4, top: 10),
                                child: Text(
                                  "Price: ₹${getCake(cake.id)?["calculatedPrice"].toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  /// Details dialog
  void _showCakeDialog(FoodItemModel cake) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        surfaceTintColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 360,
          width: 280,
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  cake.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) =>
                                const NoInternetWidget(
                                width:double.infinity,
                                height: 160,
                                iconSize: 30,
                                textSize: 8,
                               )




                  
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cake.dishName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("Price: ₹${cake.price}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            cake.describtion ?? "No description available",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed:  () => Navigator.pop(context),
                          child: const Text("Close"),
                        ),
                      )
                    ],
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
