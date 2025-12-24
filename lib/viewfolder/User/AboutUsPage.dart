
import 'package:agitha/ControllersFolder/AboutOusController.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
    bool isExpanded = false;
        @override
  void initState() {
    super.initState();
   
     WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<AboutProvider>().fetchAboutData();
  });
  }
  @override
  Widget build(BuildContext context) {

   
 final aboutProvider = Provider.of<AboutProvider>(context);

    if (aboutProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final about = aboutProvider.aboutData;

    if (about == null) {
      return const Center(child: Text("No data found."));
    }
    
   

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
        
                              Image.asset(
                              "assets/projectimages/Career.png", // your image
                                                         fit: BoxFit.cover,
                                width: double.infinity,
                                height: 240,
                              ),
        
                            
                              
                              Container(
                                color: const Color.fromARGB(255, 253, 10, 10),
                                child: Column(
                                  children: [
                                    Text(
                                       "About Agitha",
                                       style: GoogleFonts.tinos(
                                         fontSize: 40,
                                         fontWeight: FontWeight.bold,
                                         color: Colors.white,
                                       ),
                                     ),
                                            
                                     Padding(
                                       padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                                       child: Text(about.about,
                                                     
                                                    
                                                     style: const TextStyle(
                                                       fontSize: 16,
                                                       color: Colors.white,
                                                       height: 1.5, // line spacing for better readability
                                                     ),
                                                     textAlign: TextAlign.justify,
                                                   ),
                                     ),
                                  ],
                                ),
                              ),
        
        
        
                             
        
                            
                               Padding(
                                 padding: const EdgeInsets.only(left: 16.0,top: 16.0),
                                 child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                     "Our People",
                                     style: GoogleFonts.tinos(
                                       fontSize: 30,
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                     ),
                                   ),
                                                               ),
                               ),
        
                                Padding(
                                 padding: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                                 child: Text(about.ourPeople,
                                               
                                               style: const TextStyle(
                                                 fontSize: 16,
                                                 color: Colors.black,
                                                 height: 1.5, // line spacing for better readability
                                               ),
                                               textAlign: TextAlign.left,
                                             ),
                               ),


                                  
                                  
                                   Container(
                                    color: Colors.white,
                                     child: Column(
                                       children: [
                                         Align(
                                          alignment: Alignment.topLeft,
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 16.0),
                                             child: Text(
                                             "Mission and Vision",
                                             style: GoogleFonts.tinos(
                                             fontSize: 30,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.black,
                                                                              ),
                                                                            ),
                                           ),
                                         ),
                                                 
                                               Padding(
                                                padding:const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 16.0),
                                                child: Text(about.missionAndVision,
                                                    
                                                    
                                                     style: const TextStyle(
                                                       fontSize: 16,
                                                       color: Colors.black,
                                                       height: 1.5, // line spacing for better readability
                                                     ),
                                                     textAlign: TextAlign.left,
                                                   ),
                                                                        ),
                                       ],
                                     ),
                                   ),


                                        
                                         
                                        Align(
                                          alignment: Alignment.topLeft,
                                           child: Padding(
                                             padding: const EdgeInsets.only(left: 16.0),
                                             child: Text(
                                             "Word from Chairman",
                                             style: GoogleFonts.tinos(
                                             fontSize: 30,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.black,
                                                                              ),
                                                                            ),
                                           ),
                                         ),

                                          Padding(
                                         padding:
                                             const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 30.0),
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text(
                                               about.wordFromChairman,
                                               style: const TextStyle(
                                                 fontSize: 16,
                                                 color: Colors.black87,
                                                 height: 1.5,
                                               ),
                                               textAlign: TextAlign.left,
                                               maxLines: isExpanded ? null : 3,
                                               overflow: isExpanded
                                                   ? TextOverflow.visible
                                                   : TextOverflow.ellipsis,
                                             ),
                                             const SizedBox(height: 5),
                                             InkWell(
                                               onTap: () {
                                                 setState(() {
                                                   isExpanded = !isExpanded;
                                                 });
                                               },
                                               child: Text(
                                                 isExpanded ? "Read Less" : "Read More",
                                                 style: const TextStyle(
                                                   fontSize: 14,
                                                   color: Colors.red,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),


                                        
                                            
        
                          
                                   
                               

                              
                               
                   
                   
        
            
        
        
          ],
        ),
      ),
    );
  }
}