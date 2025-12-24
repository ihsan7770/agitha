import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryBoyModel {
  String db_id;
  String db_userId;
  String db_name;
  String db_phone;
  int db_age;
  String db_restaurantname;
  String db_gender;
  String db_vehicle;
  String db_licenceUrl;
  String db_location;
  String order_id;
  double rating;
  String status;
  bool isAvailable;
  bool isOrderCancelled;
  String working_restaurant_docId;
  DateTime createdAt;
  DateTime updatedAt;

  DeliveryBoyModel({
    required this.db_id,
    required this.db_userId,
    required this.db_name,
    required this.db_phone,
    required this.db_age,
    required this.db_restaurantname,
    required this.db_gender,
    required this.db_vehicle,
    required this.db_licenceUrl,
    required this.db_location,
    required this.working_restaurant_docId,
    this.rating = 0,
    this.order_id = '',
    this.status = 'pending',
    this.isAvailable = false,
    this.isOrderCancelled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'db_id': db_id,
      'db_userId': db_userId,
      'db_name': db_name,
      'db_phone': db_phone,
      'db_age': db_age,
      'db_restaurantname': db_restaurantname,
      'db_gender': db_gender,
      'db_vehicle': db_vehicle,
      'db_licenceUrl': db_licenceUrl,
      'db_location': db_location,
      'order_id': order_id,
      'status': status,
      'rating':rating,

      'isAvailable': isAvailable,
      "isOrderCancelled": isOrderCancelled,
      'working_restaurant_docId': working_restaurant_docId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeliveryBoyModel.fromMap(Map<String, dynamic> map) {
    return DeliveryBoyModel(
      db_id: map['db_id'] ?? '',
      db_userId: map['db_userId'] ?? '',
      db_name: map['db_name'] ?? '',
      db_phone: map['db_phone'] ?? '',
      db_age: map['db_age'] is int
          ? map['db_age']
          : int.tryParse(map['db_age'].toString()) ?? 0,
      db_restaurantname: map['db_restaurantname'] ?? '',
      db_gender: map['db_gender'] ?? '',
      db_vehicle: map['db_vehicle'] ?? '',
      db_licenceUrl: map['db_licenceUrl'] ?? '',
      db_location: map['db_location'] ?? 'Unknown',
      isAvailable: map['isAvailable'] ?? false,
      isOrderCancelled: map['isOrderCancelled'] ?? false,
      order_id: map['order_id'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      working_restaurant_docId: map['working_restaurant_docId'] ?? '',
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }

  /// Creates model safely from DocumentSnapshot
  factory DeliveryBoyModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return DeliveryBoyModel(
      db_id: data['db_id']?.toString().isNotEmpty == true
          ? data['db_id']
          : doc.id,
      db_userId: data['db_userId'] ?? '',
      db_name: data['db_name'] ?? '',
      db_phone: data['db_phone'] ?? '',
      db_age: data['db_age'] is int
          ? data['db_age']
          : int.tryParse(data['db_age'].toString()) ?? 0,
      db_restaurantname: data['db_restaurantname'] ?? '',
      db_gender: data['db_gender'] ?? '',
      db_vehicle: data['db_vehicle'] ?? '',
      db_licenceUrl: data['db_licenceUrl'] ?? '',
      db_location: data['db_location'] ?? 'Unknown',
      isAvailable: data['isAvailable'] ?? false,
      isOrderCancelled: data['isOrderCancelled'] ?? false,
      order_id: data['order_id'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      working_restaurant_docId: data['working_restaurant_docId'] ?? '',
      createdAt: _parseDate(data['createdAt']),
      updatedAt: _parseDate(data['updatedAt']),
    );
  }

  factory DeliveryBoyModel.fromQueryDoc(QueryDocumentSnapshot doc) =>
      DeliveryBoyModel.fromDoc(doc);

  /// --- Helper ---
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }
}
