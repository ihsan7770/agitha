import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationImage extends StatelessWidget {
  final double destLat ;
  final double destLng ;

  const LocationImage({super.key,required this.destLat,required this.destLng})  ;

  @override
  Widget build(BuildContext context) {
   
    const String apiKey = "AIzaSyBgNAFiD87u2L9GX9pCgOytVy16qh3PuD8";  

    final String mapUrl =
        "https://maps.googleapis.com/maps/api/staticmap"
        "?center=$destLat,$destLng"
        "&zoom=15"
        "&size=600x300"
        "&markers=color:red%7C$destLat,$destLng"
        "&key=$apiKey";

    return GestureDetector(
      onTap: () {
        openGoogleMap(destLat, destLng);
      },
      child: Padding(
        padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 8.0,bottom: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            mapUrl,
            height: 290,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) =>
                progress == null ? child : const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error, color: Colors.red),
          ),
        ),
      ),
    );
  }
}

Future<void> openGoogleMap(double destLat, double destLng) async {
  final Uri googleMapUrl = Uri.parse(
    "https://www.google.com/maps/dir/?api=1&destination=$destLat,$destLng&travelmode=driving",
  );

  if (await canLaunchUrl(googleMapUrl)) {
    await launchUrl(googleMapUrl, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not open Google Maps.";
  }
}
