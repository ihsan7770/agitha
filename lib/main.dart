import 'package:agitha/ControllersFolder/AboutOusController.dart';
import 'package:agitha/ControllersFolder/AddFoodController.dart';
import 'package:agitha/ControllersFolder/AddViewJobVaccancyController.dart';
import 'package:agitha/ControllersFolder/AddressController.dart';
import 'package:agitha/ControllersFolder/AdminHomeController.dart';
import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/CartController.dart';
import 'package:agitha/ControllersFolder/CompanyRegistrationController.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyController.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyHomeController.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyRatingController.dart';
import 'package:agitha/ControllersFolder/DeliveryBoyViewController.dart';
import 'package:agitha/ControllersFolder/FoodRatingController.dart';
import 'package:agitha/ControllersFolder/HomeViewCompanyController.dart';
import 'package:agitha/ControllersFolder/InstructionController.dart';
import 'package:agitha/ControllersFolder/JobApplicationController.dart';
import 'package:agitha/ControllersFolder/MediaController.dart';
import 'package:agitha/ControllersFolder/MessageController.dart';
import 'package:agitha/ControllersFolder/OrdersController.dart';
import 'package:agitha/ControllersFolder/RatingController.dart';
import 'package:agitha/ControllersFolder/RestaurantRatingController.dart';
import 'package:agitha/ControllersFolder/RestouarntVeiwController.dart';
import 'package:agitha/ControllersFolder/RestourentDelivaryBoyController.dart';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/ControllersFolder/SubscribtionController.dart';
import 'package:agitha/ControllersFolder/UserAdminsideController.dart';
import 'package:agitha/ControllersFolder/UserOrderStatusController.dart';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/ControllersFolder/ViewDishesController.dart';
import 'package:agitha/ModelsFoder/StripePaymentClass.dart';
import 'package:agitha/viewfolder/Admin/AboutFolder/AboutFormFeild.dart';
import 'package:agitha/viewfolder/Admin/AboutFolder/AdminAboutMainpage.dart';
import 'package:agitha/viewfolder/Admin/BlockedAccountsFolder.dart/BlockedUsers.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AddJobVaccancy.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/AdminViewJobVaccancy.dart';
import 'package:agitha/viewfolder/Admin/CareerFolder_Admin/JobApplications.dart';
import 'package:agitha/viewfolder/Admin/ContactMessages.dart';
import 'package:agitha/viewfolder/Admin/AdminHomePage.dart';
import 'package:agitha/viewfolder/Admin/DeliveryBoyFolder/ViewDeliveyBoys.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/Addinstructions.dart';
import 'package:agitha/viewfolder/Admin/InstructionFolder/InstructionTabBar.dart';


import 'package:agitha/viewfolder/Admin/RestorentFolder/ViewRestorents.dart';
import 'package:agitha/viewfolder/Admin/SubscribtionDetails.dart';
import 'package:agitha/viewfolder/Admin/UserDetails.dart';
import 'package:agitha/viewfolder/Admin/MediaFolder/CurrentNewsUploaded.dart';
import 'package:agitha/viewfolder/Admin/MediaFolder/Mediafromfeild.dart';
import 'package:agitha/viewfolder/DeliveryBoy/AcceptedOrderPage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyHomePage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyInstructionUser.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyMainPage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyRegistration.dart';
import 'package:agitha/viewfolder/DeliveryBoy/PreviousOrderPage.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/Screens/SplashScreen.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/AddFoodItem.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/NormalFoodItems.dart';

import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyInstruction.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfile.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationTabBarPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyResgistration.dart';
import 'package:agitha/viewfolder/SubCompany/FoodOrdersFolder/FoodOrdersTapBarPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationDetailsPage.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyReservationFolder/ReservationPaymentDetails.dart';
import 'package:agitha/viewfolder/SubCompany/RestuarantApprovalpage.dart';
import 'package:agitha/viewfolder/User/AboutUsPage.dart';
import 'package:agitha/viewfolder/User/BookEventAndReservationPage.dart';
import 'package:agitha/viewfolder/User/EventBookingFolder/EventForm.dart';
// import 'package:agitha/User/ProfileDetails/AddAddressPage.dart';

import 'package:agitha/viewfolder/User/FoodOrderingFolder/CartFood.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/FoodPaymentPage.dart';
import 'package:agitha/viewfolder/User/FoodOrderingFolder/OrderStatusPage.dart';

// import 'package:agitha/User/FoodOrderingFolder/MyOrdersFolder/OrderedFoodDetails.dart';

import 'package:agitha/viewfolder/User/CareersFolder/Careers.dart';
import 'package:agitha/viewfolder/User/CareersFolder/Job_DetailsPage.dart';
import 'package:agitha/viewfolder/User/Forgot_password/CodeGettingPage.dart';
import 'package:agitha/viewfolder/User/ContactUsPage.dart';
import 'package:agitha/viewfolder/User/Forgot_password/ForgotPasswordFirst.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:agitha/viewfolder/User/Media.dart';
import 'package:agitha/viewfolder/User/Forgot_password/ResetPassword.dart';
import 'package:agitha/viewfolder/User/MyOrdersFolder/TotalFoodOrderDetails.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/ProfileCreate.dart';
import 'package:agitha/viewfolder/User/UserBlockPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationPaymentPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/PendingReservationUserPage.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/ReservationsPage.dart';
import 'package:agitha/viewfolder/User/SubscribtionPage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/UserProfile.dart';
import 'package:agitha/viewfolder/User/UserReservationFolder/UserReservationDetailsFolder/UserResrvationDetailsTapBar.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/Languagepage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/RatingPage.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/TermsAndConditon.dart';
import 'package:agitha/viewfolder/User/UserSettingsFolder/UserSettings.dart';
import 'package:agitha/check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51SXIihPNgXcEyktDNYFLSVoTj8ghAcw4uJH0mlCXVk1n3iA1Kik4SVHSygU1GlJBEObmTukWI5hCikXFo8K0Tem800y05mdwZp";
  // // For Android AppCompat theme compatibility
  // Stripe.merchantIdentifier = 'merchant.com.example.agitha';
  
  // // URL scheme for 3D Secure redirects
  // Stripe.urlScheme = 'flutterstripe';
  
  
  
  // await Stripe.instance.applySettings();
  //   // PaymentService.initialize();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB-46S9A8l4wGkFXvxtx85DcJFjO9ZYRwY",
        appId: "1:679751784709:android:ea82afb8b5f47386933f6c",
        messagingSenderId: "679751784709",
        projectId: "agitha-ec69a",
        storageBucket: 'agitha-ec69a.firebasestorage.app'
        ),

      );
      print(  "Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
    return;
  }


  



  runApp(
    MultiProvider(providers: [
       ChangeNotifierProvider(create: (_)=>AuthenticationController()),
       ChangeNotifierProvider(create: (_) => CompanyRegistrationProvider()),
       ChangeNotifierProvider(create: (_) => DeliveryBoyProvider()),
       ChangeNotifierProvider(create: (_) => RestaurantViewProvider()),
       ChangeNotifierProvider(create: (_) => DeliveryBoyViewProvider()),
       ChangeNotifierProvider(create: (_) => AboutProvider()),
       ChangeNotifierProvider(create: (_) => MediaProvider()),
       ChangeNotifierProvider(create: (_) => InstructionProvider()),
       ChangeNotifierProvider(create: (_) =>UserRegistrationProvider()),
       ChangeNotifierProvider(create: (_) =>JobApplicationController()),
       ChangeNotifierProvider(create: (_) =>AddJobVaccancyProvider()),
       ChangeNotifierProvider(create: (_) =>SubscriptionController ()),
       ChangeNotifierProvider(create: (_) =>RatingProvider()), 
       ChangeNotifierProvider(create: (_) =>Messageprovider()), 
       ChangeNotifierProvider(create: (_) =>AddressProvider ()),  
       ChangeNotifierProvider(create: (_) =>UserAdminSideProvider ()),
       ChangeNotifierProvider(create: (_) => DashboardStreamProvider()),
       ChangeNotifierProvider(create: (_) =>  RestaurantHomeProvider()),  
       ChangeNotifierProvider(create: (_) =>  RestaurentDeliveryBoyProvider()), 
       ChangeNotifierProvider(create: (_) =>  Addfoodprovider()), 
       ChangeNotifierProvider(create: (_) =>  HomeCompanyViewProvider()),
       ChangeNotifierProvider(create: (_) =>  ViewDishesController ()), 
       ChangeNotifierProvider(create: (_) =>  FoodRatingProvider()),  
       ChangeNotifierProvider(create: (_) =>  RestaurantRatingProvider()), 
        ChangeNotifierProvider(create: (_) =>  CartController()), 
        ChangeNotifierProvider(create: (_) =>  OrderController()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),  
        ChangeNotifierProvider(create: (_) => DeliveryBoyHomeController()),
        ChangeNotifierProvider(create: (_) => UserOrderStatusProvider()),  
        ChangeNotifierProvider(create: (_) => DeliveryBoyRatingProvider()),
        
    ],
      child: const MyApp())
    );
    
    
    
    
    
    
 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    
      theme: ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 150, 11, 1), // Main brand color
      onPrimary: Colors.white,       // Text/Icon color on primary
      secondary: Colors.amber,       // Accent color
      onSecondary: Colors.black,     // Text/Icon color on secondary
      error: Colors.red,             // Error color
      onError: Colors.white,         // Text/Icon color on error
      background: Colors.white,      // Background color
      onBackground: Colors.black,    // Text/Icon color on background
      surface: Colors.white,         // Surface color
      onSurface: Colors.black,       // Text/Icon color on surface
    ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      backgroundColor: Color.fromARGB(255, 150, 11, 1),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),),

     textTheme: TextTheme(
       bodySmall: GoogleFonts.tinos(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),  
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
          bodyLarge: GoogleFonts.tinos(fontSize: 16, color: Colors.black87)

         
        ),

        
       

    // const AdminHomePage
    //const HomePage
    // DeliveryBoyResgistration
    // DeliveryBoyMainPage
    // CompanyMainPage
    // Reservation
    // OrderStatousPage
      
      ),
      
      home:HomePage()
      ,
    );
  }
}
