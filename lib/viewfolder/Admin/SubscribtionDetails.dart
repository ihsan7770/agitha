import 'package:agitha/ControllersFolder/SubscribtionController.dart';
import 'package:agitha/ModelsFoder/SubscribtionModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubscribtionDetails extends StatelessWidget {
  const SubscribtionDetails({super.key});

  @override
  Widget build(BuildContext context) {
     final SubscriptionProvider = Provider.of<SubscriptionController>(context, listen: false);
    return  Scaffold(
      appBar: AppBar(
        title: const Text( "Subscriptions"),
        centerTitle: true,
      ),
      body:  StreamBuilder<List<Subscription>>(
              stream: SubscriptionProvider.subscriptionStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: CircularProgressIndicator(),
                  ));
                }



                       if (!snapshot.hasData || snapshot.data!.isEmpty) {
       return const Center(
         child: Text(
           "No subscriptions found",
           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
         ),
       );
     }
              
                final SubscriptionProvider = snapshot.data!;
      
                return Column(
                  children: [
      
                
                    ListView.builder(
                      shrinkWrap: true,
                                  itemCount:SubscriptionProvider.length,
                                 
                                  itemBuilder: (context, index) {
                              final sub = SubscriptionProvider[index] ;
                              
                               
                          
                          return ListTile(
                            leading: Text("${index + 1}.",style: GoogleFonts.tinos(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                            title: Text(sub.username, style: GoogleFonts.tinos(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),
                            subtitle: Text(sub.email, style: GoogleFonts.tinos(
                      fontSize: 16,
                      
                      color: Colors.black,
                    ),),
                          );
                    
                    
                          
                          
                          
                                   } ),
                  ],
                );
        
              }
      )

      );
  }
}