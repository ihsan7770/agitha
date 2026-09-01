import 'dart:io';
import 'package:agitha/ControllersFolder/DeliveryBoyController.dart';
import 'package:agitha/viewfolder/DeliveryBoy/ApproveDeliveryBoy.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyHomePage.dart';
import 'package:agitha/viewfolder/DeliveryBoy/DeliveryBoyProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DeliveryBoyRegistration extends StatefulWidget {
  final String? db_id;
  final String? db_name;
  final String? db_age;
  final String? db_phone;
  final String? db_location;
  final String? db_restaurantname;
  final String? db_vehicle;
  final String? db_gender;
  final String? db_licenceUrl;
  final String? working_restaurant_docId;
  const DeliveryBoyRegistration(
      {super.key,
      this.db_id,
      this.db_name,
      this.db_age,
      this.db_location,
      this.db_phone,
      this.db_restaurantname,
      this.db_gender,
      this.db_vehicle,
      this.db_licenceUrl,
      this.working_restaurant_docId});

  @override
  State<DeliveryBoyRegistration> createState() =>
      _DeliveryBoyRegistrationState();
}

class _DeliveryBoyRegistrationState extends State<DeliveryBoyRegistration> {
  bool get isEditMode => widget.db_id != null;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectedGender;
  String? selectedVehicle;

  String? selectedRestaurantId;
  String? selectedRestaurantName;

  File? idProofImage;
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      // Pre-fill values during Update
      nameController.text = widget.db_name ?? "";
      phoneController.text = widget.db_phone ?? "";
      ageController.text = widget.db_age ?? "";
      locationController.text = widget.db_location ?? "";
      selectedVehicle = widget.db_vehicle;
      selectedRestaurantName = widget.db_restaurantname;
      selectedGender = widget.db_gender;
      existingImageUrl = widget.db_licenceUrl;
      selectedRestaurantId = widget.working_restaurant_docId;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        idProofImage = File(image.path);
      });
    }
  }

  void _showSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Future<void> submitDbDetails() async {
    final provider = Provider.of<DeliveryBoyProvider>(context, listen: false);

    if (!_formKey.currentState!.validate()) return;

    if (selectedGender == null) {
      _showSnackBar("Please select gender");
      return;
    }
    if (selectedVehicle == null) {
      _showSnackBar("Please select vehicle");
      return;
    }
    if (!isEditMode && idProofImage == null) {
      _showSnackBar("Please upload driving license");
      return;
    }

    try {
      String responseMessage = "";

      if (isEditMode) {
        // 🔹 UPDATE MODE
        responseMessage = await provider.updateDeliveryBoy(
          db_id: widget.db_id!,
          db_name: nameController.text.trim(),
          db_phone: phoneController.text.trim(),
          db_age: int.parse(ageController.text.trim()),
          db_restaurantname: selectedRestaurantName.toString(),
          db_gender: selectedGender!,
          db_vehicle: selectedVehicle!,
          db_location: locationController.text.trim(),
          working_restaurant_docId: selectedRestaurantId.toString(),
          newDbLicenceImage: idProofImage, // 🚨 only new image if selected
        );
      } else {
        // 🟢 SUBMIT MODE
        responseMessage = await provider.registerDeliveryBoy(
          db_name: nameController.text.trim(),
          db_phone: phoneController.text.trim(),
          db_age: int.parse(ageController.text.trim()),
          db_restaurantname: selectedRestaurantName.toString(),
          db_gender: selectedGender!,
          db_vehicle: selectedVehicle!,
          db_licenceUrl: idProofImage!,
          working_restaurant_docId: selectedRestaurantId.toString(),
          db_location: locationController.text.trim(),
        );
      }

      _showSnackBar(responseMessage);

      if (responseMessage.toLowerCase().contains("success")) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => isEditMode
                ? const DeliveryBoyProfile()
                : const ApproveDeliveryBoy(),
          ),
        );
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryboyProvider =
        Provider.of<DeliveryBoyProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;
    // final height = size.height;
    final width = size.width;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEditMode)
                Center(
                  child: Text(
                    "Become a Delivery Partner",
                    style: GoogleFonts.tinos(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              if (!isEditMode) const SizedBox(height: 10),
              if (!isEditMode)
                Center(
                  child: Image.asset(
                    "assets/deliveryboy.png",
                    fit: BoxFit.cover,
                    width: width * 0.5,
                    height: width * 0.5,
                  ),
                ),
              if (!isEditMode) const SizedBox(height: 20),

              Text(
                isEditMode ? 'Update Details' : "Enter Some Basic Details",
                style: GoogleFonts.tinos(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
              const SizedBox(height: 15),
              // Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your name" : null,
              ),
              const SizedBox(height: 12),
              // Phone
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your phone number" : null,
              ),
              const SizedBox(height: 12),
              // Age
              TextFormField(
                controller: ageController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Age",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your age" : null,
              ),
              const SizedBox(height: 12),

              // Restaurant Dropdown
              StreamBuilder<List<Map<String, dynamic>>>(
                stream:
                    context.read<DeliveryBoyProvider>().fetchCompaniesStream(),
                builder: (context, snapshot) {
                  // 🌀 Loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  // ❌ No data
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No restaurants found");
                  }

                  final companies = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: "Restaurant Name",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedRestaurantId,
                    items: companies.map((company) {
                      return DropdownMenuItem<String>(
                        value: company['id'], // ✅ Store the document ID
                        child: Text(company['restaurantName'] ?? 'Unknown'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRestaurantId = value;
                        selectedRestaurantName = companies.firstWhere(
                            (c) => c['id'] == value)['restaurantName'];
                      });

                      debugPrint(
                          "Selected Restaurant ID: $selectedRestaurantId");
                      debugPrint(
                          "Selected Restaurant Name: $selectedRestaurantName");
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select your Restaurant Name";
                      }
                      return null;
                    },
                  );
                },
              ),

              const SizedBox(height: 20),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Please enter your Location" : null,
              ),
              const SizedBox(height: 12),

              // Gender
              Text(
                "Gender",
                style: GoogleFonts.tinos(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
              RadioListTile<String>(
                title: const Text("Male"),
                value: "Male",
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              RadioListTile<String>(
                title: const Text("Female"),
                value: "Female",
                groupValue: selectedGender,
                onChanged: (value) => setState(() => selectedGender = value),
              ),
              const SizedBox(height: 20),
              // Vehicle
              Text(
                "Vehicle Type",
                style: GoogleFonts.tinos(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
              RadioListTile<String>(
                title: const Text("Petrol Bike"),
                value: "Petrol Bike",
                groupValue: selectedVehicle,
                onChanged: (value) => setState(() => selectedVehicle = value),
              ),
              RadioListTile<String>(
                title: const Text("Electric Bicycle"),
                value: "Electric Bicycle",
                groupValue: selectedVehicle,
                onChanged: (value) => setState(() => selectedVehicle = value),
              ),
              const SizedBox(height: 20),
              // License Upload
              Text(
                "Upload Driving License",
                style: GoogleFonts.tinos(
                  fontSize: width * 0.065,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 75, 2, 2),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: idProofImage != null
                      ? Image.file(idProofImage!, fit: BoxFit.cover)
                      : (isEditMode && existingImageUrl != null)
                          ? Image.network(existingImageUrl!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.upload_file, size: 40),
                                SizedBox(height: 5),
                                Text("Tap to upload Driving License"),
                              ],
                            ),
                ),
              ),

              const SizedBox(height: 25),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      deliveryboyProvider.isLoading ? null : submitDbDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deliveryboyProvider.isLoading
                        ? Colors.grey
                        : colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: deliveryboyProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          isEditMode ? "Update" : "Submit",
                          style: textTheme.bodyLarge
                              ?.copyWith(color: Colors.white),
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
