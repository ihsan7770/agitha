class Subscription {
  String documentId;
  String userId;
  String email;
  String username;

  Subscription({
    required this.documentId,
    required this.userId,
    required this.email,
    required this. username,
  });

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'docId': documentId,
      'userId': userId,
      'email': email,
      'username':username,
    };
  }

  // Convert Firestore data to model
  factory Subscription.fromMap(Map<String, dynamic> data, String docId) {
    return Subscription(
      documentId: docId,
      userId: data['userId'] ?? '',
      email: data['email'] ?? '',
      username:data['username'] ?? '',
    );
  }



  
}
