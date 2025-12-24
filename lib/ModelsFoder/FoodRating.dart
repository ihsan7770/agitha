class FoodRatingModel {
  final String docId;
  final String foodname;
  final String dishid;
  final String restaurantId;
  final String username;
  final double rating;
  final String review;
  String? profileImageUrl;

  FoodRatingModel({
    required this.docId,
    required this. restaurantId,
    required this.dishid,
    required this.foodname,
    required this.username,
    required this.rating,
    required this.review,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "restaurantId":  restaurantId,
      "dishid":dishid,
      "foodname":foodname,
      "username": username,
      "rating": rating,
      "review": review,
      'profileImageUrl': profileImageUrl,
    };
  }


  factory FoodRatingModel.fromMap(Map<String, dynamic> data, String docId) {
    return FoodRatingModel(
      docId: docId,
      restaurantId: data[" restaurantId"] ?? '',
      dishid:data["dishid"] ?? '',
      
      foodname:data["foodname"]?? '',
      username: data["username"] ?? '',
      rating: (data["rating"] as num?)?.toDouble() ?? 0.0,
      review: data["review"] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }


}