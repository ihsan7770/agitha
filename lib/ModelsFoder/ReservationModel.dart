import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String? id;
  final String restaurantId;
  final String status;
  final String tableno;
  final String userId;
  final String? userName;
  final String? phoneNumber;
  final int guests;
  final String paymentStatus;
  final Timestamp time;
  final int duration;
  final DateTime date;
  final List<String> tables;
  List<Map<String, dynamic>> foodData;

  final int depositAmount;
  final Timestamp createdAt;

  ReservationModel({
    this.id,
    required this.restaurantId,
    this.status = 'pending',
    this.tableno = '',
    required this.userId,
    this.userName,
    this.phoneNumber,
    this.guests = 0,
    this.paymentStatus = 'unpaid',
    required this.time,
    this.duration = 0,
    required this.date,
    this.tables = const [],
    this.foodData = const [],
    this.depositAmount = 0,
    required this.createdAt,
  });

  // -------------------- TO FIRESTORE --------------------
  Map<String, dynamic> toMap() {
    return {
      "restaurantId": restaurantId,
      "status": status,
      "tableno": tableno,
      "userId": userId,
      "userName": userName,
      "phoneNumber": phoneNumber,
      "guests": guests,
      "paymentStatus": paymentStatus,
      "time": time,
      "duration": duration,
      "date": Timestamp.fromDate(date),
      "tables": tables,
      "foodData": foodData,
      "depositAmount": depositAmount,
      "createdAt": createdAt,
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  // -------------------- FROM FIRESTORE --------------------
  factory ReservationModel.fromMap(
      Map<String, dynamic> map, String id) {

    /// ✅ Safe conversion for foodData
    final rawFood = map['foodData'];

    List<String> foodList = [];
    if (rawFood is List) {
      foodList = rawFood.map((e) => e.toString()).toList();
    }

    /// ✅ Safe conversion for tables
    final rawTables = map['tables'];
    List<String> tableList = [];
    if (rawTables is List) {
      tableList = rawTables.map((e) => e.toString()).toList();
    }

    return ReservationModel(
      id: id,
      restaurantId: map['restaurantId']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      tableno: map['tableno']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      userName: map['userName']?.toString(),
      phoneNumber: map['phoneNumber']?.toString(),
      guests: (map['guests'] ?? 0) as int,
      paymentStatus: map['paymentStatus']?.toString() ?? 'unpaid',
      time: map['time'] as Timestamp,
      duration: (map['duration'] ?? 0) as int,
      date: (map['date'] as Timestamp).toDate(),
      tables: tableList,
      foodData: List<Map<String, dynamic>>.from(map['foodData'] ?? []),

      depositAmount: (map['depositAmount'] ?? 0) as int,
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
