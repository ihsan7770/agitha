import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> getTimeFromCurrentLocation({
  required double destLat,
  required double destLng,
}) async {
  // 1️⃣ Get user current location
  Position pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  double startLat = pos.latitude;
  double startLng = pos.longitude;

  print("Current Location: $startLat , $startLng");

  // 2️⃣ Call Distance Matrix API
  final apiKey = "AIzaSyCrflwq1OFx_mQa10pNLQl5fepBmrKVadg"; // security: restrict your key

  final url = Uri.parse(
    "https://maps.googleapis.com/maps/api/distancematrix/json"
    "?origins=$startLat,$startLng"
    "&destinations=$destLat,$destLng"
    "&mode=driving"
    "&key=$apiKey",
  );

  final response = await http.get(url);
  final data = jsonDecode(response.body);

  if (data["status"] == "OK") {
    final element = data["rows"][0]["elements"][0];

    final String duration = element["duration"]["text"];
    // final String distance = element["distance"]["text"];

    print("Travel Time: $duration");
    // print("Distance: $distance");

    // You can show inside your UI later:
    // setState(() => travelTime = duration);
    // setState(() => travelDistance = distance);

  } else {
    print("Error: ${data["status"]}");
  }
}
