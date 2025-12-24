import 'package:agitha/ControllersFolder/RestourentDelivaryBoyController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DeliveryBoyListPage extends StatefulWidget {
  final String orderId;

  DeliveryBoyListPage({
    required this.orderId,
  });

  @override
  State<DeliveryBoyListPage> createState() => _DeliveryBoyListPageState();
}

class _DeliveryBoyListPageState extends State<DeliveryBoyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Delivery Boys"),
      ),

      body: StreamBuilder<List<DeliveryBoyModel>>(
        stream: RestaurentDeliveryBoyProvider().streamAvailableDeliveryBoyDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Delivery Boys Available"));
          }

          List<DeliveryBoyModel> deliveryBoys = snapshot.data!;

          return ListView.builder(
            itemCount: deliveryBoys.length,
            itemBuilder: (context, index) {
              final boy = deliveryBoys[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.delivery_dining),
                  ),

                  title: Text(
                    boy.db_name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text("Number: ${boy.db_phone}"),

                  trailing:ElevatedButton(
 onPressed: () async {

  showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text('Assign Order'),
      content: Text('Do you want to assign this order to the delivery boy?'),
      actions: [
           TextButton(
        
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog without doing anything
          },
          child: const Text('No'),
        ),

        ElevatedButton(
             style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
          onPressed: () async {
            // Store the Navigator BEFORE the widget disappears
            final nav = Navigator.of(context);

            final provider = context.read<RestaurentDeliveryBoyProvider>();

            await provider.updateDeliveryBoyOrderId(
              deliveryBoyDocId: boy.db_id,
              orderId: widget.orderId,
            );

            await provider.assignOrder(widget.orderId);

            // Close the alert dialog safely
            nav.pop();

             nav.pop();
          },
          child: const Text('Yes',style: TextStyle(color: Colors.white),),
        ),
     
      ],
    );
  },
);

  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  child: const Text("Assign"),
)

                ),
              );
            },
          );
        },
      ),
    );
  }
}
