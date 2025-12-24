import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/viewfolder/Admin/RestorentFolder/VeiwExtraRestourentDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlockedRestourents extends StatefulWidget {
  const BlockedRestourents({super.key});

  @override
  State<BlockedRestourents> createState() => _BlockedRestourentsState();
}

class _BlockedRestourentsState extends State<BlockedRestourents> {
    @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<RestaurantViewProvider>(context, listen: false)
    //       .fetchCompaniesWithEmails();
    // });
  }



  void restaurantApproveAlert(
    BuildContext context, String docId, String restaurantName) {
  final colorScheme = Theme.of(context).colorScheme;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Approve Restaurant'),
      content: Text('Are you sure you want to approve $restaurantName?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
           style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
        ),
          onPressed: () async {
            try {
              await Provider.of<RestaurantViewProvider>(context, listen: false)
                  .approveRestaurant(docId);

              Navigator.pop(context); // Close dialog first ✅

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$restaurantName approved successfully'),
                  backgroundColor: colorScheme.primary,
                ),
              );

            } catch (e) {
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          },
          child: const Text(
            'Approve',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}


 @override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;

  return Scaffold(
    body:StreamBuilder<List<Map<String, dynamic>>>(
  stream: Provider.of<RestaurantViewProvider>(context, listen: false)
      .getRejectedRestaurantsStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text("No rejected restaurants found"));
    }

    final companies = snapshot.data!;

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: companies.length,
      itemBuilder: (context, index) {
        final data = companies[index];
        final docId = data['docId'];
        final restaurantName = data['restaurantName'] ?? 'Unknown Restaurant';
        final email = data['email'] ?? 'No Email';
        final userId = data['userId'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(4, 4),
                ),
              ],
            ),
            child: ListTile(
              onTap: () {
                if (userId != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewExtraRestourentDetails(companyId: userId),
                    ),
                  );
                }
              },
              title: Text(
                "${index + 1}. $restaurantName",
                style: GoogleFonts.tinos(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              subtitle: Text( "$email",
                  style: GoogleFonts.tinos(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),),

              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
               onPressed: () {
               restaurantApproveAlert(context, docId, restaurantName);
                  },


                child: const Text("Approve", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        );
      },
    );
  },
)

  



  );
}

  }
