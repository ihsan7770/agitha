import 'dart:io';
import 'package:agitha/ControllersFolder/UserRegistrationController.dart';
import 'package:agitha/viewfolder/Screens/HomePage.dart';
import 'package:agitha/viewfolder/User/ProfileDetails/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProfileFormPage extends StatefulWidget {

  final String? username;
  final String? phonenumber ;
  final String? dob;
  final String? gender;
  final String? imageurl;
  final String? id;
 
 
 
 
  const ProfileFormPage({
  super.key,
  this.username,
  this.phonenumber,
  this.dob,
  this.gender,
  this.imageurl,
  this.id,
  
  
  });
  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? _gender;
  File? _image;
  String? _imageUrl; 
   bool get isEditMode => widget.id != null;
 

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

   Future<void> _pickImagecamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<File> getLocalFileFromAsset(String assetPath, String fileName) async {
  // Load asset as bytes
  final byteData = await rootBundle.load(assetPath);

  // Get temporary directory path
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/$fileName');

  // Write bytes to the file
  await file.writeAsBytes(byteData.buffer.asUint8List());

  return file;
}


DateTime? selectedDate;

Future<void> _pickDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    // Calculate age
    int age = _calculateAge(picked);

    if (age < 18) {
      // Show alert if under 18
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Age Restriction"),
          content: const Text("You must be at least 18 years old to continue."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
      return; // Don't set the date if under 18
    }

    // Set date if valid
    selectedDate = picked;
   _dobController.text =
        "${picked.day}/${picked.month}/${picked.year}";
  }
}

// Helper function to calculate age
int _calculateAge(DateTime birthDate) {
  DateTime today = DateTime.now();
  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

  void _showSnackBar(String message) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: colorScheme.primary,
      ),
    );
  }

  Future<void> submitUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) return _showSnackBar("Select gender!");

    final provider =
        Provider.of<UserRegistrationProvider>(context, listen: false);

    final message = isEditMode
        ? await provider.updateUser(
            username: _nameController.text.trim(),
            phonenumber: _phoneController.text.trim(),
            dob: _dobController.text.trim(),
            gender: _gender!,
            profileImageFile: _image,
            oldImageUrl: widget.imageurl,
            docId: widget.id!,
          )
        : await provider.registerUser(
            username: _nameController.text.trim(),
            phonenumber: _phoneController.text.trim(),
            dob: _dobController.text.trim(),
            gender: _gender!,
            profileImageUrl: _image,
          );

    _showSnackBar(message);

    if (message.contains("success")) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const UserProfile()));
    }
  }
 
void profileAlert() {
    final primary = Theme.of(context).colorScheme.primary;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title:  Align(
        alignment: Alignment.center,
        child: Text('Choose Profile Picture',style: GoogleFonts.tinos(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              ),
        
        
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red[100],
                  child: IconButton(
                    icon:  Icon(Icons.photo_library, color: primary),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(); // pick from gallery
                    },
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.red[100],
                  child: IconButton(
                    icon:  Icon(Icons.camera_alt, color: primary),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImagecamera(); // pick from camera
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                 onTap: () async {
                  Navigator.pop(context);
                  try {
                    final file = await getLocalFileFromAsset('assets/avatarwomen.png', 'avatarwomen.png');
                    if (mounted) {
                      setState(() {
                        _image = file; // now a real File you can upload
                      });
                    }
                  } catch (e) {
                    // handle error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to set image: $e')),
                    );
                  }
                },

                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage("assets/avatarwomen.png"),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                 onTap: () async {
                 Navigator.pop(context);
                 try {
                   final file = await getLocalFileFromAsset('assets/avatarmen.png', 'avatarmen.png');
                   if (mounted) {
                     setState(() {
                       _image = file; // now a real File you can upload
                     });
                   }
                 } catch (e) {
                   // handle error
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Failed to set image: $e')),
                   );
                 }
               },
               
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage("assets/avatarmen.png"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  /////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    _nameController.text = widget.username ?? "";
    _phoneController.text = widget.phonenumber ?? "";
    _dobController.text=widget.dob ?? "";
       _gender=widget.gender?? " ";
     _imageUrl = widget.imageurl ?? ""; 

  }





  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
      
      final provider = Provider.of<UserRegistrationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
         
onPressed: isEditMode
    ? () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        )
    : () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ),

          
          
          
           )
        ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                   CircleAvatar(
  radius: 70,
  backgroundColor: Colors.grey[300],
  backgroundImage: _image != null
      ? FileImage(_image!) as ImageProvider
      : (_imageUrl != null && _imageUrl!.isNotEmpty
          ? NetworkImage(_imageUrl!)
          : null),
  child: (_image == null && (_imageUrl == null || _imageUrl!.isEmpty))
      ? const Icon(Icons.person, size: 70, color: Colors.white)
      : null,
),

                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: InkWell(
                        onTap:profileAlert,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: primary,
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Please enter your name"
                    : null,
              ),
              const SizedBox(height: 16),

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your phone number";
                  }
                  if (value.length < 10) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date of Birth Field
              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date of Birth",
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                  onTap: () async {
                    await _pickDate(context); // 👈 Wrap it in an async callback
                     }, 
                validator: (value) => value == null || value.isEmpty
                    ? "Please select your date of birth"
                    : null,
              ),
              const SizedBox(height: 16),

              // Gender Selection
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gender",
                  style: GoogleFonts.tinos(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("Male"),
                    selected: _gender == "Male",
                    onSelected: (value) => setState(() => _gender = "Male"),
                    selectedColor: primary.withOpacity(0.2),
                    avatar: const Icon(Icons.male),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text("Female"),
                    selected: _gender == "Female",
                    onSelected: (value) => setState(() => _gender = "Female"),
                    selectedColor: primary.withOpacity(0.2),
                    avatar: const Icon(Icons.female),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:provider.isLoading ? null : submitUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: provider.isLoading
                                  ? Colors.grey
                                  : primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child:provider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : 
                        Text( isEditMode ? "Update Profile":"Save Profile", style: const TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
