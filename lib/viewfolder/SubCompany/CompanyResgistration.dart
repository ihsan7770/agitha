import 'dart:io';
import 'package:agitha/ControllersFolder/CompanyRegistrationController.dart';

import 'package:agitha/viewfolder/SubCompany/CompanyHomePage.dart';
import 'package:agitha/viewfolder/SubCompany/RestuarantApprovalpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompanyResgistration extends StatefulWidget {
  const CompanyResgistration({super.key});

  @override
  State<CompanyResgistration> createState() => _CompanyResgistrationState();
}

class _CompanyResgistrationState extends State<CompanyResgistration> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _restorentNameController =
      TextEditingController();
 
  final TextEditingController _instagramUrlController = TextEditingController();
  final TextEditingController _facebookUrlController = TextEditingController();
  final TextEditingController _twitterUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _twoSeatController = TextEditingController();
  final TextEditingController _fourSeatController = TextEditingController();
  final TextEditingController _sixSeatController = TextEditingController();
  final TextEditingController _eightSeatController = TextEditingController();
  final TextEditingController _tenSeatController = TextEditingController();

  final TextEditingController _reservationPriceController = TextEditingController();
  final TextEditingController _eventBookingPriceController = TextEditingController();
  final TextEditingController _eventDecoratingPriceController = TextEditingController();


  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  final List<String> _brandType = ["Local brand", "International brand"];
  String? _selectedBrand;

  File? _logoImage;
  File? _restaurantImage;

  Future<void> _pickLogoImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickRestaurantImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _restaurantImage = File(pickedFile.path);
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Future<void> submitCompanyDetails() async {
  if (!_formKey.currentState!.validate()) return;

  if (_logoImage == null) {
    _showSnackBar(context, "Please upload a logo image");
    return;
  }
  if (_restaurantImage == null) {
    _showSnackBar(context, "Please upload a restaurant image");
    return;
  }

  final provider = Provider.of<CompanyRegistrationProvider>(context, listen: false);

final message = await provider.registerCompany(
  location: _locationController.text.trim(),
  phone: _phoneController.text.trim(),
  restaurantName: _restorentNameController.text.trim(),
  brandType: _selectedBrand!,
  instagramUrl: _instagramUrlController.text.trim(),
  facebookUrl: _facebookUrlController.text.trim(),
  twitterUrl: _twitterUrlController.text.trim(),
  description: _descriptionController.text.trim(),
  twoSeat: int.parse(_twoSeatController.text.trim()),
  fourSeat: int.parse(_fourSeatController.text.trim()),
  sixSeat: int.parse(_sixSeatController.text.trim()),
  eightSeat: int.parse(_eightSeatController.text.trim()),
  tenSeat: int.parse(_tenSeatController.text.trim()),
  decorationAmount: int.parse(_eventBookingPriceController.text.trim()), // Add this
  noDecorationAmount: int.parse(_eventDecoratingPriceController.text.trim()), // Add this
  reservationAmount: int.parse( _reservationPriceController.text.trim()), // Add this
  logoImage: _logoImage!,
  restaurantImage: _restaurantImage!,
);

  _showSnackBar(context, message);

  if (message == "Company registered successfully!") {
    _formKey.currentState!.reset();
    setState(() {
      _logoImage = null;
      _restaurantImage = null;
      _selectedBrand = null;
    });
      // final currentUserId = FirebaseAuth.instance.currentUser!.uid;
     Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RestaurantRegistrationStatus(
        
        
        ),)
    );
  }
}







  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authProvider = Provider.of<CompanyRegistrationProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                  ),
                  child: Text(
                    "Be a part of Agitha",
                    style: GoogleFonts.tinos(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "assets/shakehand.png",
                  fit: BoxFit.cover,
                ),
              ),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter Some Basic Details",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Restaurant Name
              TextFormField(
                controller: _restorentNameController,
                decoration: const InputDecoration(
                  labelText: "Restaurant Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Restaurant Name" : null,
              ),
              const SizedBox(height: 10),
                  ///location
                  TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Location " : null,
              ),

                const SizedBox(height: 10),
                  ///phone
                  TextFormField(
                controller: _phoneController,
                keyboardType:TextInputType.number,
                decoration: const InputDecoration(
                  
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Phone Number" : null,
              ),
              const SizedBox(height: 10),
              // Brand Type
              DropdownButtonFormField<String>(
                value: _selectedBrand,
                decoration: const InputDecoration(
                  labelText: "Select Brand",
                  border: OutlineInputBorder(),
                ),
                items: _brandType
                    .map((role) =>
                        DropdownMenuItem(value: role, child: Text(role)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedBrand = value),
                validator: (value) =>
                    value == null ? "Please select a Brand" : null,
              ),
              const SizedBox(height: 10),


                   Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Enter Table Details",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),


                const SizedBox(height: 10),





              // Table Details ..............
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _twoSeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "2 Seater",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Fill The feild" : null,
                    ),
                  ),
                   const SizedBox(width: 10),
                  
                     Expanded(
                    child: TextFormField(
                      controller: _fourSeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "4 Seater",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Fill The feild" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                     Expanded(
                    child: TextFormField(
                      controller: _sixSeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "6 Seater",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Fill The feild" : null,
                    ),
                  ),
                ],
              ),

               const SizedBox(height: 10),



               Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _eightSeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "8 Seater",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Fill The feild" : null,
                    ),
                  ),
                   const SizedBox(width: 10),
                  
                     Expanded(
                    child: TextFormField(
                      controller: _tenSeatController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "10 Seater",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Fill The feild" : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  
                ],
              ),


   const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Price Details",
                              style: GoogleFonts.tinos(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                             TextFormField(
                      controller: _reservationPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Reservation Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _eventBookingPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Event Booking Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _eventDecoratingPriceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Event Decorating Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),





           

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Social Media Details",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Social Media
              TextFormField(
                controller: _instagramUrlController,
                decoration: const InputDecoration(
                  labelText: "Instagram URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Instagram URL" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _facebookUrlController,
                decoration: const InputDecoration(
                  labelText: "Facebook URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Facebook URL" : null,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: _twitterUrlController,
                decoration: const InputDecoration(
                  labelText: "Twitter URL",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Twitter URL" : null,
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Description",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                  minLines: 2,      // 👈 user can type only 2 lines
   
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Enter Description" : null,
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Upload Restaurant Logo",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Logo Upload
              InkWell(
                onTap: _pickLogoImage,
                child: Container(
                  height: 280,
                  width:double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                    image: _logoImage != null
                        ? DecorationImage(
                            image: FileImage(_logoImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _logoImage == null
                      ? const Center(
                          child: Text("Upload Logo Image"),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Upload Restaurant Image",
                  style: GoogleFonts.tinos(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 75, 2, 2),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Restaurant Image Upload
              InkWell(
                onTap: _pickRestaurantImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.black54),
                    borderRadius: BorderRadius.circular(8),
                    image: _restaurantImage != null
                        ? DecorationImage(
                            image: FileImage(_restaurantImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _restaurantImage == null
                      ? const Center(
                          child: Text("Upload Restaurant Image"),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10),

             
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:authProvider.isLoading
                   ? Colors.grey[100] 
                   : colorScheme.primary, 
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: submitCompanyDetails,
                  child: authProvider.isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
