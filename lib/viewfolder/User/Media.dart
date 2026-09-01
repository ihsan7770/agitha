import 'package:agitha/ControllersFolder/MediaController.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late MediaProvider mediaProvider;

@override
void initState() {
  super.initState();
  mediaProvider = Provider.of<MediaProvider>(context, listen: false);

  WidgetsBinding.instance.addPostFrameCallback((_) {
    mediaProvider.fetchAllMedia();
  });
}

  Future<void> openWebsite(String url) async {
    final colorScheme = Theme.of(context).colorScheme;
    Uri? uri;

    try {
      uri = Uri.parse(url);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid URL")));
      return;
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Cannot open this link"),
        backgroundColor: colorScheme.primary,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/projectimages/4rth.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Heading
            Text(
              "LATEST NEWS",
              style: GoogleFonts.tinos(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 10),

            // Media Container
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 16,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: mediaProvider.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : mediaProvider.mediaList.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(child: Text("No news uploaded yet.")),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: List.generate(
                                  mediaProvider.mediaList.length,
                                  (index) {
                                    final reverseIndex =
                                        mediaProvider.mediaList.length - 1 - index;
                                    final media = mediaProvider.mediaList[reverseIndex];

                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16.0),
                                      child: InkWell(
                                        onTap: () => openWebsite(media.link),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            media.news,
                                            style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18,
                                              color: Colors.blue,
                                              decoration: TextDecoration.underline,
                                               decorationColor: Colors.blue,// makes it look like a link
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
