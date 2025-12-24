import 'package:agitha/ControllersFolder/MessageController.dart';
import 'package:agitha/ModelsFoder/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContactMessages extends StatelessWidget {
  const ContactMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Messageprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        
      ),
      body: StreamBuilder<List<MessageModel>>(
        stream: provider.messageStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No messages received yet"),
            );
          }

          final messages = snapshot.data!;

          return Column(
            children: [
                Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    "Messages",
                    style: GoogleFonts.tinos(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),




              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 16,
                            offset: const Offset(4, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(msg.subject,
                              style: GoogleFonts.tinos(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 75, 2, 2),
                              )),
                          const SizedBox(height: 4),
                          Text(msg.username,
                              style: GoogleFonts.tinos(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(msg.email,
                              style: GoogleFonts.tinos(
                                fontSize: 17,
                              )),
                          Text(msg.phone,
                              style: GoogleFonts.tinos(
                                fontSize: 17,
                              )),
                          const SizedBox(height: 8),
                          Text("Message:",
                              style: GoogleFonts.tinos(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(
                            msg.message,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
