import 'package:agitha/ControllersFolder/RestourentDelivaryBoyController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class DeliveryBoyListPage extends StatefulWidget {
  final String orderId;

  const DeliveryBoyListPage({
    super.key,
    required this.orderId,
  });

  @override
  State<DeliveryBoyListPage> createState() => _DeliveryBoyListPageState();
}

class _DeliveryBoyListPageState extends State<DeliveryBoyListPage> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Available Delivery Boys",
          
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<List<DeliveryBoyModel>>(
        stream: RestaurentDeliveryBoyProvider()
            .streamAvailableDeliveryBoyDetails(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No Delivery Boys Available"));
          }

          final deliveryBoys = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            itemCount: deliveryBoys.length,
            itemBuilder: (context, index) {
              final boy = deliveryBoys[index];

              return Card(
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.008,
                  ),

                  leading: CircleAvatar(
                    radius: screenWidth * 0.06,
                    child: Icon(
                      Icons.delivery_dining,
                      size: screenWidth * 0.07,
                    ),
                  ),

                  title: Text(
                    boy.db_name,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "Number: ${boy.db_phone}",
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                    ),
                  ),

                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.015,
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.04),
                      ),
                    ),

                    child: Text(
                      "Assign",
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Assign Order',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                              ),
                            ),
                            content: Text(
                              'Do you want to assign this order to the delivery boy?',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () async {
                                  final nav = Navigator.of(context);
                                  final provider = context
                                      .read<RestaurentDeliveryBoyProvider>();

                                  await provider.updateDeliveryBoyOrderId(
                                    deliveryBoyDocId: boy.db_id,
                                    orderId: widget.orderId,
                                  );

                                  await provider.assignOrder(widget.orderId);

                                  nav.pop();
                                  nav.pop();
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

