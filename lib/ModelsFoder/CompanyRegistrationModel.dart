class CompanyRegistrationModel {
  String id;
  String userId;
  String restaurantName;
  String brandType;
  String instagramUrl;
  String facebookUrl;
  String twitterUrl;
  String description;
  String logoUrl;
  String restaurantImageUrl;
  String location;
  String phone;
  double rating;
  int twoSeat;
  int fourSeat;
  int sixSeat;
  int eightSeat;
  int tenSeat;
  int decorationAmount;
  int noDecorationAmount;
  int reservationAmount;
  DateTime createdAt;
  String status; // <-- changed from isApproved to status

  CompanyRegistrationModel({
    required this.id,
    required this.userId,
    required this.restaurantName,
    required this.brandType,
    required this.instagramUrl,
    required this.location,
    required this.phone,
     this. rating = 0,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.description,
    required this.logoUrl,
    required this.restaurantImageUrl,
    required this.twoSeat,
    required this.fourSeat,
    required this.sixSeat,
    required this.eightSeat,
    required this.tenSeat,
    required this.decorationAmount,
    required this.noDecorationAmount,
    required this.reservationAmount,
    required this.createdAt,
    this.status = 'pending', // default initial status
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantName': restaurantName,
      'brandType': brandType,
      'instagramUrl': instagramUrl,
      'facebookUrl': facebookUrl,
      'twitterUrl': twitterUrl,
      'description': description,
      'logoUrl': logoUrl,
      'restaurantImageUrl': restaurantImageUrl,
      'location':location,
      'phone':phone,
      'rating':rating,
      'twoSeat': twoSeat,
      'fourSeat': fourSeat,
      'sixSeat': sixSeat,
      'eightSeat': eightSeat,
      'tenSeat': tenSeat,
      'decorationAmount': decorationAmount,
      'noDecorationAmount': noDecorationAmount,
      'reservationAmount': reservationAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status, // <-- changed here
    };
  }

  factory CompanyRegistrationModel.fromMap(Map<String, dynamic> map) {
    return CompanyRegistrationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      brandType: map['brandType'] ?? '',
      instagramUrl: map['instagramUrl'] ?? '',
      facebookUrl: map['facebookUrl'] ?? '',
      twitterUrl: map['twitterUrl'] ?? '',
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      restaurantImageUrl: map['restaurantImageUrl'] ?? '',
      location:map['location'] ?? '',
      phone:map['phone'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),

      twoSeat: map['twoSeat'] ?? 0,
      fourSeat: map['fourSeat'] ?? 0,
      sixSeat: map['sixSeat'] ?? 0,
      eightSeat: map['eightSeat'] ?? 0,
      tenSeat: map['tenSeat'] ?? 0,
      decorationAmount: map['decorationAmount'] ?? 0,
      noDecorationAmount: map['noDecorationAmount'] ?? 0,
      reservationAmount: map['reservationAmount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'] ?? 'pending', // <-- changed here
    );
  }
}
