
import 'package:agitha/ControllersFolder/RestourentDelivaryBoyController.dart';
import 'package:agitha/ModelsFoder/DeliveryBoyModel.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyDeliveryBoyFolder/CompanyDeliveryBoyDetails.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CompanyViewDeliveryBoys extends StatelessWidget {
  const CompanyViewDeliveryBoys({super.key,});

  @override
  Widget build(BuildContext context) {
    final restaurantController = Provider.of<RestaurentDeliveryBoyProvider>(context);
    //  final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: restaurantController.streamApprovedDeliveryBoysForCompany(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final deliveryBoys = snapshot.data ?? [];

          if (deliveryBoys.isEmpty) {
            return const Center(child: Text("No approved delivery boys found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: deliveryBoys.length,
            itemBuilder: (context, index) {
              final boy = deliveryBoys[index];

              return  InkWell(
            onTap: () {
              

              Navigator.push(
                context,
                 MaterialPageRoute(builder: (context) => CompanyDeliveryBoyDetails(

                  deliverboyemail:boy['email']  ,
                  deliveryboyId: boy['userId'],


                  
                 )),
              );
              },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                
                width: double.infinity,
                decoration:  BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 16,
                          offset: const Offset(4,4)
                        )
                      ] ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                           
                            Align(
                              alignment: Alignment.topRight,
                              child: Text("${index+1}", style: GoogleFonts.tinos(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),),
                            ),
                            const SizedBox(width: 20,),
              
              
                            Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                            
                             children: [ 
                              
                               Text(
                               boy['db_name'] ?? 'Unknown Delivery Boy',
                               style: GoogleFonts.tinos(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 75, 2, 2),
                                                      ),
                                                    ),
                              
              
              
                                                       Text(
                              "${boy['email'] ?? 'No email'}",
                               style: GoogleFonts.tinos(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                
                                                      ),
                               softWrap:true,
                               overflow: TextOverflow.visible,
                                                     
                                                  ),
              
              
                              //  const SizedBox(height: 10,),
              
              
                   
              
                     ],),
                          ],
                        ),
                      ),
              
              
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
                            
                             
                             
                             
                             
                          
                          
                     
                                                
                          
                   
                          
                            
                          
                          
                                            
                          
                          
                          
                            
                          
                          
                          
                          
                          
                                  
                             
                             
                             
          