import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/RatingController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ModelsFoder/RatingModel.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
 double currentRate = 3;
  @override
  Widget build(BuildContext context) {
      final Rating = Provider.of<RatingProvider>(context);
                                                     
     final colorScheme = Theme.of(context).colorScheme;
    

    return  Scaffold(
      appBar: AppBar(),
      body:  Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
           
             
             Image.asset("assets/rating.png"),
              const SizedBox(height: 12),
          
              
           
          
        
              const Text(
     
                "Happy with your experiance? Let us know by rating",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
          
          
                  
                  const SizedBox(height: 20),
               
                 RatingBar.builder(
                 initialRating: currentRate,
                 minRating: 1,
                 direction: Axis.horizontal,
                 allowHalfRating: true,
                 itemCount: 5,
                 itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                 itemBuilder: (context, _) => const Icon(
                   Icons.star,
                   color: Colors.amber,
                 ),
                 onRatingUpdate: (rating) {
                   setState(() {
                     currentRate = rating; // ✅ store as double
                   });
                 },
               ),
               
                         
                            
          
             
           
          
              const SizedBox(height: 20),
          
          
                    Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      hintText: "Every review help us grow and serve you better",
                      hintStyle: TextStyle(color: Colors.grey),
                      
                    
                      alignLabelWithHint: true,
                      
                      border:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey,)
                      ),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter review";
                      }
                      return null;
                    },
                  ),
                ),
              ),
          
          
          
          
             
          
          
          
            
          
             const SizedBox(height: 30),
          
          SizedBox(
            width: double.infinity,  
            height: 40,  
            child: ElevatedButton(
             onPressed: () async {
                               if (_formKey.currentState!.validate()) {
                            // Ensure async login check
                           bool loggedIn = await Provider.of<AuthenticationController>(
                                                          context,
                                   listen: false,
                                 ).checkLogin(context);
                             
                                 if (loggedIn) {
                                   // Check if profile exists
                                   final profileService = Provider.of<UserRegistrationProvider>(context, listen: false);

                                   bool exists = await profileService.checkUserProfileExists();
                             
                                   if (!exists) {
                                     // Navigate to Profile Form Page
                                     Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(builder: (context) => const ProfileFormPage()),
                                     );
                                       ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Complete profile for subscribtion')),
                                     );
                                   } else {

                                     String review = _reviewController.text.trim();
                              final RatingProviders =
                                                      Provider.of<RatingProvider>(context, listen: false);
             RatingModel ratings = RatingModel(
                      docId: '',
                      userId:'',
                      username: '',
                      profileImageUrl: '',
                      review: review,
                          
                      rating:currentRate
                    );
        
      
                        await RatingProviders.AddRating(ratings);
        
     
         
             _reviewController.clear();
              









                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Rating send Successfully')),
                                     );
                                   }
                                 }
                               }
                             },
                
              style: ElevatedButton.styleFrom(
                backgroundColor:Rating.isLoading?Colors.grey[100]:colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.zero, // let SizedBox control size
              ),
            
              child:Rating.isLoading?
              const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ):
              
              
              
              
              
               const Text(
                "Send",
                style: TextStyle(fontSize: 14), // smaller text
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