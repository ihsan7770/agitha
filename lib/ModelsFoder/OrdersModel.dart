import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String id; // optional unique id (e.g., doc id)
  final String userId; // current user
  final String username;
  final String userphone;
  final String userimg;
 
  final String address;
  final String housename;
  final double longitude;
  final double latitude;

  final String restaurantId; // new field for restaurant
  final String companyName;
  final String dishPhoto; // url or local path
  final String dishName;
  final String dishId;
  final double price;
  double tip;
  final int quantity;
  String deliveryBoyId;
  String deliverytime;
  String paymentStatus;
  String status; 
  String deliverystatous;
  String cancelReason;
  DateTime createdAt;

  OrderItem ({
    this.id = '',
    this.userId = '', // default empty
    required this.username,
    required this.userphone,
    required this.userimg,

    required this.address,
    required this.housename,
    required this.longitude,
    required this.latitude,
    
    required this.restaurantId, // default empty
    required this.companyName,
    required this.dishPhoto,
    required this.dishName,
    required this.dishId,
    required this.price,
    required this.quantity,
    required this.createdAt,
    this.tip = 0 ,
    this.deliverytime='',
    this.cancelReason='',
    this.deliveryBoyId='',
    this.paymentStatus = 'unpaid',
    this.status = 'pending',
    this.deliverystatous='pending',
  });


  // serialization (for Firestore / JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,

      'username':username,
      'userphone':userphone,
      'userimg':userimg,
      'cancelReason':cancelReason,

      'address':address,
      'housename':housename,
      'longitude':longitude,
      'latitude':latitude,
      'deliveryBoyId':deliveryBoyId,

      'restaurantId': restaurantId,
      'companyName': companyName,
      'dishPhoto': dishPhoto,
      'dishName': dishName,
      'dishId':dishId,
      'price': price,
      'tip':tip,
      'quantity': quantity,
       'deliverytime':deliverytime,
      'paymentStatus':paymentStatus,
      'status':status,
      'deliverystatous':deliverystatous,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
  return OrderItem(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',

    username: map['username'] ?? '',
    userphone: map['userphone'] ?? '',
    cancelReason: map['cancelReason'] ?? '',
    userimg:map['userimg'] ?? '',

    address: map['address'] ?? '',
    housename: map['housename'] ?? '',
    longitude: (map['longitude'] as num).toDouble(),
    latitude: (map['latitude'] as num).toDouble(),
    
    deliveryBoyId:map['deliveryBoyId']??'',
    restaurantId: map['restaurantId'] ?? '',
    companyName: map['companyName'] ?? '',
    dishPhoto: map['dishPhoto'] ?? '',
    dishName: map['dishName'] ?? '',
    dishId: map['dishId'] ?? '',

    price: (map['price'] as num).toDouble(),
    tip: (map['tip'] as num).toDouble(),
    quantity: map['quantity'] as int,
    deliverytime:map['deliverytime']?? '',
    createdAt: (map['createdAt'] as Timestamp).toDate(),
    paymentStatus: map['paymentStatus'] ?? 'unpaid',
    status: map['status'] ?? 'pending',
    deliverystatous: map['deliverystatous'] ?? 'pending',
  );
}



}
