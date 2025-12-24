class RatingModel {
  final String docId;
  final String userId;
  final String username;
  final double rating;
  final String review;
  String? profileImageUrl;

  RatingModel({
    required this.docId,
    required this.userId,
    required this.username,
    required this.rating,
    required this.review,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "userId": userId,
      "username": username,
      "rating": rating,
      "review": review,
      'profileImageUrl': profileImageUrl,
    };
  }


  factory RatingModel.fromMap(Map<String, dynamic> data, String docId) {
    return RatingModel(
      docId: docId,
      userId: data["userId"] ?? '',
      username: data["username"] ?? '',
      rating: (data["rating"] as num?)?.toDouble() ?? 0.0,
      review: data["review"] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }


}