class RestaurantReviewModel {
  final String docId;

  final String restaurantId;
  final String username;
  final double rating;
  final String review;
  String? profileImageUrl;

 RestaurantReviewModel({
    required this.docId,
    required this. restaurantId,
   
    required this.username,
    required this.rating,
    required this.review,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "restaurantId":  restaurantId,
 
      "username": username,
      "rating": rating,
      "review": review,
      'profileImageUrl': profileImageUrl,
    };
  }


  factory RestaurantReviewModel.fromMap(Map<String, dynamic> data, String docId) {
    return RestaurantReviewModel(
      docId: docId,
      restaurantId: data[" restaurantId"] ?? '',

      username: data["username"] ?? '',
      rating: (data["rating"] as num?)?.toDouble() ?? 0.0,
      review: data["review"] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }


}