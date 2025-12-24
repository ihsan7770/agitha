import 'package:agitha/ControllersFolder/AddressController.dart';
import 'package:agitha/ModelsFoder/AddressModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _houseController = TextEditingController();
  

      double longitude = 0 ;
      double latitude =0 ;

  bool _isLoadingLocation = false;

  bool isLoadingLocation = false;

   int? selectedIndex;

 
  // Function to check and request location permission
  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission is required to get current address')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied. Please enable them in app settings.')),
      );
      return false;
    }

    return true;
  }

  // Function to check if location services are enabled
  Future<bool> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services on your device')),
      );
      return false;
    }
    return true;
  }

  // Function to fetch current location and convert to address
  Future<void> _pickCurrentAddress() async {
    // Check location service
    if (!await _checkLocationService()) return;
    
    // Check and request permission
    if (!await _checkLocationPermission()) return;

    // setState(() {
    //   _isLoadingLocation = true;
    // });

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 15));

    

      // Convert coordinates to human-readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
        

        
      ).timeout(const Duration(seconds: 10));
  

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        // Build address string with null checks
        List<String> addressComponents = [];
        if (place.name != null && place.name!.isNotEmpty) addressComponents.add(place.name!);
        if (place.street != null && place.street!.isNotEmpty) addressComponents.add(place.street!);
        if (place.locality != null && place.locality!.isNotEmpty) addressComponents.add(place.locality!);
        if (place.postalCode != null && place.postalCode!.isNotEmpty) addressComponents.add(place.postalCode!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressComponents.add(place.administrativeArea!);
        if (place.country != null && place.country!.isNotEmpty) addressComponents.add(place.country!);

        String address = addressComponents.join(", ");

        // Update the TextFormField
        setState(() {
          _addressController.text = address;
          latitude=position.latitude;
          longitude=position.longitude;

        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location fetched successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not find address for current location')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
void initState() {
  super.initState();
  _getLocationOnStart();
}

Future<void> _getLocationOnStart() async {
  if (!await _checkLocationService()) return;
  if (!await _checkLocationPermission()) return;

  setState(() {
    _isLoadingLocation = true;
  });

  try {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

  } catch (e) {
    debugPrint("Error fetching initial location: $e");
  } finally {
    setState(() {
      _isLoadingLocation = false;
    });
  }
}


  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressprovider = Provider.of<AddressProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  "Add New Address",
                  style: GoogleFonts.tinos(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            Form(
              key: _formKey,
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 16.0,right:16.0,top:12.0),
                    child: TextFormField(
                      controller: _houseController,
                      decoration: const InputDecoration(
                        labelText: "Enter your House Name,Flat Number etc",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your house details";
                        }
                        return null;
                      },
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _addressController,
                       decoration: const InputDecoration(
                        labelText: "Enter your address",
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your address";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                  onPressed: _isLoadingLocation ? null : () async {
                  setState(() {
                    isLoadingLocation = true; 
                  });
              
                  try {
                    await _pickCurrentAddress(); 
                  } finally {
                    setState(() {
                      isLoadingLocation = false; 
                    });
                  }
                },
                    icon:
                    isLoadingLocation 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : 
                        
                        const Icon(Icons.location_pin,color: Color.fromARGB(255, 150, 11, 1),),
                    label: 
                    
                    isLoadingLocation 
                        ? const Text("Fetching...")
                        : 
                        
                      const Text("Pick location",style: TextStyle(color: Color.fromARGB(255, 150, 11, 1)),),
                      style: OutlinedButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 150, 11, 1),
                      side: const BorderSide(color: Color.fromARGB(255, 150, 11, 1)),
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),

                  const Spacer(),

                  ElevatedButton(
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                                          
                       final provider = Provider.of<AddressProvider>(context, listen: false);

                       String address = _addressController.text.trim();
                       String house = _houseController.text.trim();

                       AddressModel addAddress =AddressModel(
                         docId: '', 
                         userId: '', 
                         address: address,
                         housename: house, 
                         longitude: longitude, 
                         latitude: latitude );

                          await provider.addAddress(addAddress);


                           
 
     _addressController.clear();
     _houseController.clear();
   

  
  
    FocusScope.of(context).unfocus();
    
   
    if (mounted) {
      setState(() {});
    }
  
                              if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address added successfully'),
          
              ),
            );
          }
                   }
                   
                   
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: addressprovider.isLoading ? Colors.grey[100]:colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:addressprovider.isLoading ?
                    const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ):
                      Text(
                      'Add',
                      style: GoogleFonts.tinos(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            



            //show saved address////////////////////////////////////////









            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 25.0),
                child: Text(
                  "Saved Addresses",
                  style: GoogleFonts.tinos(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),


            StreamBuilder<List<AddressModel>>(
  stream: context.read<AddressProvider>().currentUserAddressStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Padding(
  padding: EdgeInsets.symmetric(vertical: 200),
  child: Center(
    child: Text(
      "Address not added yet",
      style: TextStyle(color: Colors.grey),
      textAlign: TextAlign.center,
    ),
  ),
);








    }

    final addresses = snapshot.data!;

     return SizedBox(
  height: MediaQuery.of(context).size.height * 0.4,
  child: ListView.builder(
    itemCount: addresses.length,
    itemBuilder: (context, index) {
      final addr = addresses[index];
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
        child: GestureDetector(
     onTap: () async {
    Provider.of<AddressProvider>(context, listen: false)
        .setSelectedAddress(addr.docId);
  },
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(color:addr.selectedAddress ?Colors.green: const Color.fromARGB(255, 150, 11, 1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
          
          
              Row(
            children: [
              const SizedBox(width: 20), // instead of padding left
              
              Expanded(
                child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            addr.housename,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
                ),
              ),
          
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 10.0),
                child:addr.selectedAddress ? const Icon(Icons.check_circle, color: Colors.green): IconButton(
          onPressed: () {
            showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Delete Address"),
              content: const Text("Are you sure you want to delete this address?"),
              actions: [
                TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
                ),
                TextButton(
          onPressed: () {
            Provider.of<AddressProvider>(context, listen: false)
                .deleteAddress(addr.docId);
            
              Navigator.pop(context);
            
            
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          
          
           
          
          
          },
          icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ),
            ],
          ),
          
          
             Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10,right: 20.0),
                    child: Text(
                      addr.address,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.tinos(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                       maxLines: 3,
                       overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
           
              ],
            ),
          ),
        ),
      );
    },
  ),
);

  },
),


          
          ],
        ),
      ),
    );
  }
}