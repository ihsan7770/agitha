class DeliveryBoyRatingModel {
  final String docId;
  final dboyId;
  final String userId;
  final String username;
  final double rating;
  final String review;
  String? profileImageUrl;

  DeliveryBoyRatingModel({
    required this.docId,
    required this.dboyId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.review,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "dboyId":dboyId,
      "userId": userId,
      "username": username,
      "rating": rating,
      "review": review,
      'profileImageUrl': profileImageUrl,
    };
  }


  factory DeliveryBoyRatingModel.fromMap(Map<String, dynamic> data, String docId) {
    return DeliveryBoyRatingModel(
      docId: docId,
      dboyId:data["dboyId"] ?? '',
      userId: data["userId"] ?? '',
      username: data["username"] ?? '',
      rating: (data["rating"] as num?)?.toDouble() ?? 0.0,
      review: data["review"] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }


}