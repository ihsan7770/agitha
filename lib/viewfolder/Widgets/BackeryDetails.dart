import 'package:agitha/ControllersFolder/UserEventBookingController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/viewfolder/Widgets/ImageErrorContainer.dart';
import 'package:flutter/material.dart';

class BakerySelectionWidget extends StatefulWidget {
  final String restaurantid;

  /// ✅ callback to parent (EventForm)
  final Function(List<Map<String, dynamic>>) onSelectionChanged;

  const BakerySelectionWidget({
    super.key,
    required this.restaurantid,
    required this.onSelectionChanged,
  });

  @override
  State<BakerySelectionWidget> createState() => _BakerySelectionWidgetState();
}

class _BakerySelectionWidgetState extends State<BakerySelectionWidget> {
  late final Stream<List<FoodItemModel>> bakeryStream;

  /// stores selected bakery items
  List<Map<String, dynamic>> selectedItems = [];

  @override
  void initState() {
    super.initState();
    bakeryStream =
        UserEventProvider().streamUserbakeryItems(widget.restaurantid);
  }

  void _notifyParent() {
    widget.onSelectionChanged(List.from(selectedItems));
  }

  bool isChecked(String id) {
    return selectedItems.any((e) => e["id"] == id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(8),
      child: StreamBuilder<List<FoodItemModel>>(
        stream: bakeryStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Center(child: Text("No bakery items found")),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final checked = isChecked(item.id);

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,

                    errorBuilder: (context, error, stackTrace) =>
                                const NoInternetWidget(
                                width: 50,
                                height: 50,
                                iconSize: 20,
                                textSize: 8,
                               )





                  ),
                ),
                title: Text(item.dishName, maxLines: 1),
                subtitle: Text("₹${item.price}"),
                trailing: Checkbox(
                  value: checked,
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        selectedItems.add({
                          "id": item.id,
                          "name": item.dishName,
                          "price": item.price,
                        });
                      } else {
                        selectedItems
                            .removeWhere((e) => e["id"] == item.id);
                      }
                    });

                    _notifyParent(); // ✅ send to EventForm
                  },
                ),
                onTap: () => _showItemDialog(item),
              );
            },
          );
        },
      ),
    );
  }

  /// popup dialog
  void _showItemDialog(FoodItemModel item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          height: 360,
          width: 280,
          child: Column(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  item.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) =>
                                const NoInternetWidget(
                                width: double.infinity,
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
                      Text(item.dishName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text("Price: ₹${item.price}"),
                      const SizedBox(height: 8),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            item.describtion ?? "No description available",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
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
