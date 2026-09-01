class DecorationModel{
  final String docId;
  final String restauratId;
  final String eventName;
  
  final String decorationDetails;


  DecorationModel({
    required this.docId,
    required this.restauratId,
    required this.eventName,
    required this.decorationDetails,
   

  });

  Map<String, dynamic> toMap() {
    return {
      "docId": docId,
      "restauratId": restauratId,
      "eventName": eventName,
      "decorationDetails": decorationDetails,
     
    };
  }


  factory DecorationModel.fromMap(Map<String, dynamic> data, String docId) {
    return DecorationModel(
      docId: docId,
      restauratId: data["restauratId"] ?? '',
      eventName: data["eventName"] ?? '',
      decorationDetails: data["decorationDetails"] ?? '',
     
    );
  }


}