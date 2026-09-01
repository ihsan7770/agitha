import 'dart:io';

import 'package:agitha/ControllersFolder/AddFoodController.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/FoodItemTabBar.dart';
import 'package:agitha/viewfolder/SubCompany/AddFoodFolder.dart/NormalFoodItems.dart';
import 'package:agitha/viewfolder/SubCompany/CompanyMainPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddFoodItem extends StatefulWidget {
  final bool isUpdate;
  final String? dishName;
  final String? price;
  final String? category ;
  final String? imagePath; 
  final String? foodid;
  final String? describtion;

  const AddFoodItem({
    super.key,
    this.isUpdate = false,
    this.dishName,
    this.price,
    this.category,
    this.imagePath,
    this.foodid,
    this.describtion,
  });

  @override
  State<AddFoodItem> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dishNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _describtionController = TextEditingController();

  File? _logoImage;

    String? selectedcategory;
    final List<String> category = ["Special", "Normal","Cake","Bakery","Drinks"];

@override
void initState() {
  super.initState();

  if (widget.isUpdate) {
    _dishNameController.text = widget.dishName ?? "";
    _priceController.text = widget.price ?? "";
    _describtionController.text=widget.describtion?? "";
    selectedcategory = widget.category; 
    
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      if (widget.imagePath!.startsWith('http')) {
   
        _logoImage = null;
      } else {
        _logoImage = File(widget.imagePath!);
      }
    }
  }
}


  Future<void> _pickFoodImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoImage = File(pickedFile.path);
      });
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        
      ),
    );
  }

void submitFoodItemss() async {
  if (_formKey.currentState!.validate()) {
    if (_logoImage == null && !widget.isUpdate) {
      _showSnackBar(context, "Please upload a Food Item image");
      return;
    }

    try {
      final foodProvider =
          Provider.of<Addfoodprovider>(context, listen: false);

      if (widget.isUpdate) {
        // 🔹 Update existing food item
        await foodProvider.updateFoodItem(
           describtion: _describtionController.text.trim(),
          foodItemId: widget.foodid.toString(), // make sure you pass this when navigating
          dishName: _dishNameController.text.trim(),
          price: _priceController.text.trim(),
          category: selectedcategory.toString(),
          newImageFile: _logoImage, // null means keep old image
        );

        _showSnackBar(context, "Food Item Updated Successfully!");
      } else {
        // 🔹 Add new food item
        await foodProvider.addFoodItem(
          describtion: _describtionController.text.trim(),
          dishName: _dishNameController.text.trim(),
          price: _priceController.text.trim(),
          category: selectedcategory.toString(),
          imageFile: _logoImage!,
        );

        _showSnackBar(context, "Food Item Added Successfully!");
      }

      // ✅ Clear form
      _dishNameController.clear();
      _priceController.clear();
      setState(() {
        selectedcategory = null;
        _logoImage = null;
      });

      // ✅ Navigate back or to food list
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodItemTabBar()),
      );
    } catch (e) {
      _showSnackBar(context, "Failed to process food item: $e");
    }
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
    final colorScheme = Theme.of(context).colorScheme;
     final foodprovider = Provider.of<Addfoodprovider>(context);
    return Scaffold(
      appBar: AppBar(
        title:   Text(
                      widget.isUpdate ? "Update Food Item" : "Add Food Item",
                     
                    ),
        centerTitle: true,
        leading: IconButton(icon:Icon(Icons.arrow_back),onPressed: (){

              Navigator.push(context, MaterialPageRoute(builder: (context) => const   CompanyMainPage()),);
          }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
               
              InkWell(
                  onTap: _pickFoodImage,
                  child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.black, width: 1),
                    image: _buildImage(widget.imagePath, _logoImage),
                  ),
                  child: (_logoImage == null && (widget.imagePath == null || widget.imagePath!.isEmpty))
                      ? Center(
                          child: Text(
                            "Upload Image",
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
                const SizedBox(height: 10),
            
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Enter Details",
                    style: GoogleFonts.tinos(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 75, 2, 2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
            
                TextFormField(
                  controller: _dishNameController,
                  decoration: const InputDecoration(
                    labelText: "Food/Cake/Bakery/Drinks",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Dish Name" : null,
                ),
                const SizedBox(height: 10),
            
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter Price" : null,
                ),
                const SizedBox(height: 10),

                   DropdownButtonFormField<String>(
                        value:selectedcategory,
                        decoration: const InputDecoration(
                          labelText: "Select Category",
                          border: OutlineInputBorder(),
                        ),
                        items: category
                            .map((role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedcategory = value;
                          });
                        },
                        validator: (value) {
                        
                          if (value == null || value.isEmpty) {
                            return "Please select a Category";
                          }
                        
                          return null;
                        },

            
                   ),

                         const SizedBox(height: 10),
            
                TextFormField(
                  controller: _describtionController,
                  maxLines: 3,
                  minLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Describtion",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? "Enter Describtion" : null,
                ),
                const SizedBox(height: 10),



                    const SizedBox(height: 10),
            
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:foodprovider.isLoading?Colors.grey[100]: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: submitFoodItemss,
                    child: foodprovider.isLoading?
                    SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ):
                    
                    
                    
                    
                    
                    Text(
                      widget.isUpdate ? "Update" : "Add",
                      style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
            
                if (!widget.isUpdate)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>   FoodItemTabBar ()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "View all Food Items",
                            style: GoogleFonts.tinos(
                              fontSize: 15,
                              color: colorScheme.primary,
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              color: colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

