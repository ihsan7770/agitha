import 'package:agitha/ControllersFolder/AddFoodController.dart';
import 'package:agitha/ModelsFoder/AddfoodModel.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/FoodRating_ReviewDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NormalFoodItems extends StatefulWidget {
  
   NormalFoodItems({super.key});

  @override
  State<NormalFoodItems> createState() => _NormalFoodItemsState();
}

class _NormalFoodItemsState extends State<NormalFoodItems> {
  @override
  Widget build(BuildContext context) {

        void fooditemdeleteAlert(){
    
}




    final foodController = Provider.of<Addfoodprovider>(context, listen: false);


     final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
    
      body:StreamBuilder<List<FoodItemModel>>(
        stream: foodController.streamNormalFoodItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No normal food items found"));
          }

          final foodItems = snapshot.data!;

          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return  Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
              
              
              width: double.infinity,
                 decoration:  BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius:BorderRadius.circular(20),
                      
                      
                      
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: const Offset(4,4)
                        )
                      ] ),
             
                      child:Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                                  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                   borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                       food.imageUrl,
                                       fit: BoxFit.cover,
                                       width: 80,
                                       height: 80,
                                     ),
                                  ),
                                    ),

                                   Expanded(
                                     child: Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [


                                           Row(
                                             children: [
                                               Text(
                                                 food.dishName,
                                                 style: GoogleFonts.tinos(
                                                 fontSize: 23,
                                                 fontWeight: FontWeight.bold,
                                                 color: Colors.black,
                                                                       ),
                                                                     ),
                                 const Spacer(),
                   InkWell(
                onTap: ()  {
           Navigator.push(context, MaterialPageRoute(builder: (context) =>  FoodRating_ReviewPage(fooddocId: food.id,)),);
    
                      },

                  child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,  // 🔥 important → wrap content
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        food.rating.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                                ),
                ),
                                                                     
                                                                     
                                             ]
                                           ),
                                       
                                                                   Text(
                                             "Price: ${food.price}",
                                             style: GoogleFonts.tinos(
                                             fontSize: 18,
                                             fontWeight: FontWeight.w400,
                                             color: Colors.black,
                                                                   ),
                                                                 ),
                                                                
  Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
         tilePadding: EdgeInsets.only(left: 0, right: 0),
           childrenPadding: EdgeInsets.only(left: 0),
        title: const Text(
          "More Options",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        children: [
             Text(
        food.describtion,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                /// UPDATE BUTTON
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddFoodItem(
                          isUpdate: true,
                          dishName: food.dishName,
                          price: food.price,
                          category: food.category,
                          imagePath: food.imageUrl,
                          foodid: food.id,
                          describtion: food.describtion,
                        ),
                      ),
                    );
                  },
                  child: const Text("Update"),
                ),
                  
                const SizedBox(width: 20),
                  
                /// DELETE BUTTON
                ElevatedButton(
                  onPressed: () {
                    final parentContext = context;
                  
                    showDialog(
                      context: parentContext,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text('Delete'),
                          content: const Text(
                            'Are you sure you want to delete this food item?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(dialogContext);
                  
                                final provider = Provider.of<Addfoodprovider>(
                                    parentContext,
                                    listen: false);
                  
                                try {
                                  await provider.deleteFoodItem(
                                    food.id,
                                    parentContext,
                                  );
                                } catch (e) {
                                  print("not deleted");
                                }
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text("Delete"),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 10),
        ],
      ),
    ),
  ],
)



                                          
            
                                       
                                         ],
                                       ),
                                     ),
                                   ),
                
                            ],
                          ),
                       


                        ],
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