import 'package:agitha/ControllersFolder/MediaController.dart';
import 'package:agitha/ModelsFoder/MediaModel.dart';
import 'package:agitha/viewfolder/Admin/MediaFolder/Mediafromfeild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CurrentNewsUploaded extends StatefulWidget {
  const CurrentNewsUploaded({super.key});

  @override
  State<CurrentNewsUploaded> createState() => _CurrentNewsUploadedState();
}

class _CurrentNewsUploadedState extends State<CurrentNewsUploaded> {
  late MediaProvider mediaProvider;



  @override
  void initState() {
    super.initState();
    mediaProvider = Provider.of<MediaProvider>(context, listen: false);

    // Fetch media on page load
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await mediaProvider.fetchAllMedia();
      setState(() {});
    });
  }

Future<void> openWebsite(String url) async {
  final colorScheme = Theme.of(context).colorScheme;

  if (!url.startsWith('http')) {
    url = 'https://$url'; // Ensure valid format
  }

  final uri = Uri.parse(url);

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Cannot open this link"),
          backgroundColor: colorScheme.primary,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Invalid link"),
        backgroundColor: colorScheme.primary,
      ),
    );
  }
}


  void mediadeleteAlert(String docId) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete'),
        content: const Text('Are you sure you want to delete this news?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white
        ),
            onPressed: () async {
              await mediaProvider.deleteMedia(docId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text("News deleted successfully"),
                backgroundColor: colorScheme.primary,
              ));
              setState(() {}); // Refresh UI
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
                  "Current News",),
                  centerTitle: true,
      ),
      body: Consumer<MediaProvider>(
        builder: (context, mediaProvider, _) {
          final List<MediaModel> mediaList = mediaProvider.mediaList;

          if (mediaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (mediaList.isEmpty) {
            return const Center(child: Text("No news uploaded yet."));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // News List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: mediaList.length,
                  itemBuilder: (context, index) {
                    final media = mediaList[index];
                

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 16,
                            offset: const Offset(4, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // News text with hover effect
                          InkWell(
                            onTap: () => openWebsite(media.link),
                            child: Text(
                              media.news,
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                   decorationColor: Colors.blue,
                                     
                                    
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Row with Edit & Delete buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MediaFormField(
                                        news: media.news,
                                        link: media.link,
                                        id: media.id,
                                      ),
                                    ),
                                  );
                                },
                                icon:
                                    const Icon(Icons.edit, color: Colors.black),
                              ),
                              IconButton(
                                onPressed: () =>
                                    mediadeleteAlert(media.id!),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
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
