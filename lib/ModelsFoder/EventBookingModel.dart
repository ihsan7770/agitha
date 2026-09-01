import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String? id; // Document ID from Firestore
  final String restaurantId;
  final String status; 
  final String decorationType;
  final String userId;
  final String? userName;
  final String? phoneNumber;
  final int guests;
  String paymentStatus;
  final Timestamp time;
  final String eventType;

  final int duration;
  final DateTime date;
 
  final int depositAmount;
  final Timestamp createdAt;

  final String cakesuggestion;
  final String paidsuggestioncake;
  final String? cakeDecorationprice;
  final String decorationSuggestion;
  final String foodServiceType;
  final String foodSuggestion;
  List<Map<String, dynamic>> cakeData;
  List<Map<String, dynamic>>  bakeryData;
  List<Map<String, dynamic>>  eventFoodData;

  EventModel ({
    this.id,
    required this.restaurantId,
    this.status = 'pending',
    
    required this.userId,
    this.userName,
    this.phoneNumber,
    required this.eventType,

    required this.guests,
    this.paymentStatus = 'unpaid',
    required this.time,
    required this.duration,
    required this.date,
    required this.decorationType,
    required this.depositAmount,
    required this.createdAt,
    this.paidsuggestioncake='',
    this.cakeDecorationprice='',

    this.cakesuggestion='',
    this.decorationSuggestion='',
    this.foodServiceType='',
    this.foodSuggestion='',

    this.cakeData = const [],
    this.bakeryData = const [],
    this.eventFoodData = const [],
  });

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      "restaurantId": restaurantId,
      'status': status,
      'decorationType': decorationType,
      "userId": userId,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "guests": guests,
      "paymentStatus": paymentStatus,
      "time": time,
      "duration": duration,
      "date": Timestamp.fromDate(date),
      "eventType":eventType,
      "depositAmount": depositAmount,
      "paidsuggestioncake": paidsuggestioncake,
      "cakeDecorationprice": cakeDecorationprice,
      "foodSuggestion": foodSuggestion,

      "cakesuggestion": cakesuggestion,
      "decorationSuggestion": decorationSuggestion,
      "foodServiceType": foodServiceType,
      "cakeData": cakeData,
      "bakeryData": bakeryData,
      "eventFoodData": eventFoodData,
      "createdAt": createdAt,
      // Optional: Add timestamp for when the document was created/updated
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore Document
factory EventModel .fromMap(Map<String, dynamic> map, String id) {
  return EventModel (
    id: id,
    restaurantId: map['restaurantId'] as String,
    status: map['status'] as String? ?? 'pending',
    decorationType: map['decorationType'] as String? ?? '',
    userId: map['userId'] as String,
    eventType: map['eventType'] as String,
     
    cakesuggestion: map['cakesuggestion'] as String? ?? '',
    paidsuggestioncake: map['paidsuggestioncake'] as String? ?? '',
    decorationSuggestion: map['decorationSuggestion'] as String? ?? '',
    cakeDecorationprice: map['cakeDecorationprice'] as String? ?? '',
    foodServiceType: map['foodServiceType'] as String? ?? '',
    foodSuggestion: map['foodSuggestion'] as String? ?? '',

    cakeData: List<Map<String, dynamic>>.from(map['cakeData'] as List<dynamic>),
    bakeryData: List<Map<String, dynamic>>.from(map['bakeryData'] as List<dynamic>),
    eventFoodData: List<Map<String, dynamic>>.from(map['eventFoodData'] as List<dynamic>),

    // ✅ FIX HERE
    userName: map['userName'] as String?,
    phoneNumber: map['phoneNumber'] as String?,

    guests: map['guests'] as int,
    paymentStatus: map['paymentStatus'] as String? ?? 'unpaid',
    time: map['time'] as Timestamp,

    duration: map['duration'] as int,
    date: (map['date'] as Timestamp).toDate(),
   
    depositAmount: map['depositAmount'] as int,
    createdAt: map['createdAt'] as Timestamp,
  );
}



}