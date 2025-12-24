class AddressModel{
  final String docId;
  final String userId;
  final String address;
  final String housename;
  final double longitude;
  final double latitude;
  bool  selectedAddress;

  AddressModel({
  required this.docId,
  required this.userId,
  required this.address,
  required this.housename,
  required this.longitude,
  required this.latitude,
  this.selectedAddress=false,
});

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "userId": userId,
      "address":address,
      "housename":housename,
      "longitude":longitude,
      "latitude":latitude,
      "selectedAddress":selectedAddress
     
    };
  }

    factory AddressModel.fromMap(Map<String, dynamic> data, String docId) {
    return AddressModel(
      docId: docId,
      userId: data["userId"] ?? '',
      address: data["address"] ?? '',
      housename: data["housename"] ?? '',
      longitude: (data["longitude"] as num?)?.toDouble() ?? 0.0,
      latitude: (data["latitude"] as num?)?.toDouble() ?? 0.0,
      selectedAddress:data["selectedAddress"]?? false  

    
    );
  }





}