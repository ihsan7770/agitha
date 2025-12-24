import 'package:agitha/ControllersFolder/AuthenticationContoller.dart';
import 'package:agitha/ControllersFolder/MessageController.dart';
import 'package:agitha/ModelsFoder/MessageModel.dart';
import 'package:agitha/viewfolder/User/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactTextFromContainer extends StatefulWidget {
  const ContactTextFromContainer({super.key});

  @override
  State<ContactTextFromContainer> createState() =>
      _ContactTextFromContainerState();
}

class _ContactTextFromContainerState extends State<ContactTextFromContainer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ✅ Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    // ✅ Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

 void _clearAllFields() {
    // Method 1: Clear controllers individually
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _phoneController.clear();
    _messageController.clear();

  
    // Remove focus
    FocusScope.of(context).unfocus();
    
    // Force UI update
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
     
       final logprovider =  Provider.of<Messageprovider>(context);
   




    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
     
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Subject
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Subject is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone number is required";
                  }
                  if (value.length < 7 || value.length > 15) {
                    return "Enter a valid phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: "Message",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Message cannot be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ✅ buttons with validation check
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: 
                          MaterialStateProperty.all(
                            logprovider.isLoading ? Colors.grey[100]:colorScheme.primary)),
                      
                      onPressed: ()async {
                        if (_formKey.currentState!.validate()) {
                           bool loggedIn =
                                          Provider.of<AuthenticationController>(
                                                  context,
                                                  listen: false)
                                              .checkLogin(context);

                                      if (loggedIn) {
                                         final provider =
                      Provider.of<Messageprovider>(context, listen: false);
                         
                        
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String subject = _subjectController.text.trim();
                          String phone = _phoneController.text.trim();
                          String message = _messageController.text.trim();

                           MessageModel messageadd = MessageModel(
                            docId: '',
                            userId: '',
                            username:name ,
                            email: email,
                            message: message,
                            subject:subject,
                            phone: phone,   
                            );
                        await provider.addMessage(messageadd);
                     
                        
                        
                      
                        
                        
                         

                                     _clearAllFields();

                                     if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Message sent successfully'),
          
              ),
            );
          }
                                        



                                      }

          
                         }
                      },
                      child:  logprovider.isLoading?
                      const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ):
                      
                      
                      const Text("Send",
                      
                      
                      style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:     OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                      ).copyWith(
                        overlayColor: MaterialStateProperty.all(colorScheme.primary),
                      ),
                      onPressed: () {
                        // Navigator.pop(context); // Cancel and go back
                      },
                      child:  Text("Cancel",style: TextStyle(color:colorScheme.primary),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
