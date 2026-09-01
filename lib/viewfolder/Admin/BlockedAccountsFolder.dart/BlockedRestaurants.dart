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

  final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;

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

    return 
    
   ListView.builder(
  padding: EdgeInsets.all(screenWidth * 0.04), // responsive padding
  itemCount: companies.length,
  itemBuilder: (context, index) {
    final data = companies[index];
    final docId = data['docId'];
    final restaurantName = data['restaurantName'] ?? 'Unknown Restaurant';
    final email = data['email'] ?? 'No Email';
    final userId = data['userId'];

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.015), // responsive spacing
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
              fontSize: screenWidth * 0.05, // responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            "$email",
            style: GoogleFonts.tinos(
              fontSize: screenWidth * 0.04, // responsive font size
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.015,
              ),
            ),
            onPressed: () {
              restaurantApproveAlert(context, docId, restaurantName);
            },
            child: Text(
              "Approve",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
              ),
            ),
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
