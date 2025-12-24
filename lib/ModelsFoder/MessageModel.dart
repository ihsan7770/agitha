class MessageModel {
  final String docId;
  final String userId;
  final String username;
  final String email;
  final String phone;
  final String subject;
  final String message;


 MessageModel({
    required this.docId,
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    required this.subject,
    required this.message,
   
  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "userId": userId,
      "username": username,
      "email":email,
      "phone":phone,
      "subject":subject,
      "message":message,
      
    };
  }


  factory MessageModel.fromMap(Map<String, dynamic> data, String docId) {
    return MessageModel(
      docId: docId,
      userId: data["userId"] ?? '',
      username: data["username"] ?? '',
      email:data['email'] ?? '',
      phone:data['phone'] ?? '',
     subject: data['subject']?? '',
      message: data["message"] ?? '',
      
    );
  }


}