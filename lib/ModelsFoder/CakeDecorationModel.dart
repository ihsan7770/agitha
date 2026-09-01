class CakeDecorationModel{
  final String docId;
  final String restauratId;
  final String decorationPrice;
  final String decorationDetails;


 CakeDecorationModel({
    required this.docId,
    required this.restauratId,
    required this.decorationPrice,
    required this.decorationDetails,
   

  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "restauratId": restauratId,
      "decorationPrice": decorationPrice,
      "decorationDetail": decorationDetails,
     
    };
  }


  factory CakeDecorationModel.fromMap(Map<String, dynamic> data, String docId) {
    return CakeDecorationModel(
      docId: docId,
      restauratId: data["restauratId"] ?? '',
      decorationPrice: data["decorationPrice"] ?? '',
      decorationDetails: data["decorationDetail"] ?? '',
     
    );
  }


}