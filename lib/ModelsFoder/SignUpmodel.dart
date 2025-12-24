class SignUpModel{

  String uid;
  String email;
  String password;
  String role;

  SignUpModel({
    required this.uid,
    required this.email,
    required this.password,
    required this.role,


});

Map<String, dynamic>toMap(){
  return{

    'uid':uid,
    'email':email,
    'password':password,
    'role':role,
};



}





    factory  SignUpModel.fromMap(Map<String, dynamic> map) {
    return  SignUpModel(
     uid:map['uid'] ?? '',
     email:map['email'] ?? '',
     password:map['password']?? '',
     role: map['role'] ?? '',

    
    );
  }
}







