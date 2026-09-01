import 'dart:io';
import 'package:agitha/ControllersFolder/RestourentHomeController.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyProfileFolder/CompanyProfile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CompanyProfileUpdate extends StatefulWidget {
  final String docid;
  final String restorentName;
  final String twoseat;
  final String fourseat;
  final String sixseat;
  final String eightseat;
  final String tenseat;



  final String? brandType;
  final String instagramUrl;
  final String facebookUrl;
  final String twitterUrl;
  final String description;
  final String? imagePath; 
  final String? imagePathlogo; 

  final String? location;
  final String? phone;
 

   final  String reservationAmount;  
   final  String noDecorationAmount;
   final  String decorationAmount;

  const CompanyProfileUpdate({
    super.key,
    required this.docid,
    required this.restorentName,
    required this.twoseat,
    required this.fourseat,
    required this.sixseat,
    required this.eightseat,
    required this.tenseat,

    
  required this. reservationAmount,
  required this. noDecorationAmount,
  required this. decorationAmount,
  
   required this.location,
   required this.phone, 


    this.brandType,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.description,
    this.imagePath,
    this.imagePathlogo,
  });

  @override
  State<CompanyProfileUpdate> createState() => _EditRestorentDetailsState();
}

class _EditRestorentDetailsState extends State<CompanyProfileUpdate> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _restorentNameController;
  
  late TextEditingController _instagramUrlController;
  late TextEditingController _facebookUrlController;
  late TextEditingController _twitterUrlController;
  late TextEditingController _descriptionController;
  
  late TextEditingController _twoSeatController;
  late TextEditingController _fourSeatController;
  late TextEditingController _sixSeatController;
  late TextEditingController _eightSeatController;
  late TextEditingController _tenSeatController;
  
  late TextEditingController _reservationPriceController;
  late TextEditingController _eventBookingPriceController;
  late TextEditingController _eventDecoratingPriceController;

  
 late TextEditingController _locationController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();

 
  final List<String> _brandType = ["Local brand", "International brand"];
  String? _selectedBrand;

  File? _logoImage;
  File? _restaurantImage;

  @override
  void initState() {
    super.initState();

    _restorentNameController =TextEditingController(text: widget.restorentName);
      
    _twoSeatController = TextEditingController(text: widget.twoseat);
    _fourSeatController = TextEditingController(text: widget.fourseat);
    _sixSeatController = TextEditingController(text: widget.sixseat);
    _eightSeatController = TextEditingController(text: widget.eightseat);
    _tenSeatController = TextEditingController(text: widget.tenseat);


    _reservationPriceController = TextEditingController(text: widget.reservationAmount);
    _eventBookingPriceController = TextEditingController(text: widget.noDecorationAmount);
    _eventDecoratingPriceController = TextEditingController(text: widget.decorationAmount);

   _locationController=TextEditingController(text: widget.location);
   _phoneController =TextEditingController(text: widget.phone);



    _instagramUrlController = TextEditingController(text: widget.instagramUrl);
    _facebookUrlController = TextEditingController(text: widget.facebookUrl);
    _twitterUrlController = TextEditingController(text: widget.twitterUrl);
    _descriptionController = TextEditingController(text: widget.description);

    
    if (_brandType.contains(widget.brandType)) {
      _selectedBrand = widget.brandType;
    }
  }

  Future<void> _pickLogo() async {
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

 
  DecorationImage? _buildImage(String? path, File? file) {
    if (file != null) {
      return DecorationImage(image: FileImage(file), fit: BoxFit.cover);
    } else if (path != null && path.isNotEmpty) {
      if (path.startsWith('http')) {
        return DecorationImage(image: NetworkImage(path), fit: BoxFit.cover);
      } else if (path.startsWith('assets/')) {
        return DecorationImage(image: AssetImage(path), fit: BoxFit.cover);
      } else {
        return DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover);
      }
    }
    return null;
  }

  

  @override
  Widget build(BuildContext context) {
       final provider =
        Provider.of<RestaurantHomeProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
     final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(

     title:  const Text(
                  "Edit Restaurant",
                ),
                centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

             

            Center(
              child: InkWell(
                onTap: _pickLogo,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 280,
                    
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      border: Border.all(color: Colors.black, width: 1),
                      image: _buildImage(widget.imagePathlogo, _logoImage),
                    ),
                    child: _logoImage == null &&
                            (widget.imagePathlogo == null ||
                                widget.imagePathlogo!.isEmpty)
                        ? Center(
                            child: Text(
                              "Upload Logo",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Basic Details",
                  style: GoogleFonts.tinos(
                    fontSize: screenWidth * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),


            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
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





                    DropdownButtonFormField<String>(
                      value: _brandType.contains(_selectedBrand)
                          ? _selectedBrand
                          : null,
                      decoration: const InputDecoration(
                        labelText: "Select Brand",
                        border: OutlineInputBorder(),
                      ),
                      items: _brandType
                          .map((role) =>
                              DropdownMenuItem(value: role, child: Text(role)))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedBrand = value;
                      }),
                      validator: (value) =>
                          value == null ? "Please select a Brand" : null,
                    ),
                    const SizedBox(height: 10),

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
       //price details.////////////////////////////////////////////////////////////////////////////
         const SizedBox(height: 10),
                  Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Price Details",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                             TextFormField(
                      controller: _reservationPriceController,
                      decoration: const InputDecoration(
                        labelText: "Reservation Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _eventBookingPriceController,
                      decoration: const InputDecoration(
                        labelText: "Event Booking Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _eventDecoratingPriceController,
                      decoration: const InputDecoration(
                        labelText: "Event Decorating Price",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),







                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Social Media",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                    TextFormField(
                      controller: _instagramUrlController,
                      decoration: const InputDecoration(
                        labelText: "Instagram URL",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _facebookUrlController,
                      decoration: const InputDecoration(
                        labelText: "Facebook URL",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    TextFormField(
                      controller: _twitterUrlController,
                      decoration: const InputDecoration(
                        labelText: "Twitter URL",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                         Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Restaurant Image",
                              style: GoogleFonts.tinos(
                                fontSize: screenWidth * 0.055,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                    InkWell(
                      onTap: _pickRestaurantImage,
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          image: _buildImage(widget.imagePath, _restaurantImage),
                        ),
                        child: _restaurantImage == null &&
                                (widget.imagePath == null ||
                                    widget.imagePath!.isEmpty)
                            ? Center(
                                child: Text(
                                  "Upload Restaurant Image",
                                  style: GoogleFonts.roboto(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),

                     const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Description",
                              style: GoogleFonts.tinos(
                                fontSize:screenWidth * 0.055,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                            const SizedBox(height: 10),

                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 2,
                      minLines: 2,
                      decoration: const InputDecoration(
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                         
                          backgroundColor:provider.isLoading? Colors.grey[100]: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                       onPressed: () async {
  if (_formKey.currentState!.validate()) {
    final provider =
        Provider.of<RestaurantHomeProvider>(context, listen: false);

    await provider.updateCompany(
      location: _locationController.text.trim(),
      phone: _phoneController.text.trim(),
  companyId: widget.docid,
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
  logoImage: _logoImage,
  restaurantImage: _restaurantImage,
    );
 Navigator.of(context).pop(); 
 
  }


  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Restaurant Updated Successfully", style: TextStyle(color: Colors.white)),
       
      ),
    );
},

                        child: provider.isLoading? 
                        SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                               ) :Text(
                          "Save Changes",
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                      const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
