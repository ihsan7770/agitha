class UserRegistrationModel {
  String documentid;
  String loggeduserId;
  String username;
  String phonenumber;
  String dob;
  String gender;
  String? profileImageUrl;
  String email;
  bool isBlocked; // ✅ New field

  UserRegistrationModel({
    required this.documentid,
    required this.loggeduserId,
    required this.username,
    required this.phonenumber,
    required this.dob,
    required this.gender,
    required this.email,
    this.profileImageUrl,
    this.isBlocked = false, // ✅ Default false
  });

  Map<String, dynamic> toMap() {
    return {
      'documentid': documentid,
      'loggeduserId': loggeduserId,
      'username': username,
      'phonenumber': phonenumber,
      'dob': dob,
      'gender': gender,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'isBlocked': isBlocked, // ✅ Save to Firestore
    };
  }

  factory UserRegistrationModel.fromMap(Map<String, dynamic> map, String id) {
    return UserRegistrationModel(
      documentid: map['documentid'] ?? '',
      loggeduserId: map['loggeduserId'] ?? '',
      username: map['username'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      dob: map['dob'] ?? '',
      gender: map['gender'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      isBlocked: map['isBlocked'] ?? false, // ✅ Read with default value
    );
  }
}
