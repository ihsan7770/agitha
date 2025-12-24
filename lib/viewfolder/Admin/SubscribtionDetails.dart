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
      appBar: AppBar(),
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
                  return const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Text(
                      "No user details found",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }
      
                final SubscriptionProvider = snapshot.data!;
      
                return Column(
                  children: [
      
                     Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    "Subscriptions",
                    style: GoogleFonts.tinos(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
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