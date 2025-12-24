class AboutUsModel {
  String? uid; 
  String about;
  String ourPeople;
  String missionAndVision;
  String wordFromChairman;

  AboutUsModel({
    this.uid,
    required this.about,
    required this.ourPeople,
    required this.missionAndVision,
    required this.wordFromChairman,
  });

  Map<String, dynamic> toMap() {
    return {
      "about": about,
      "ourPeople": ourPeople,
      "missionAndVision": missionAndVision,
      "wordFromChairman": wordFromChairman,
    };
  }

  factory AboutUsModel.fromMap(Map<String, dynamic> map, String uid) {
    return AboutUsModel(
      uid: uid,
      about: map["about"] ?? "",
      ourPeople: map["ourPeople"] ?? "",
      missionAndVision: map["missionAndVision"] ?? "",
      wordFromChairman: map["wordFromChairman"] ?? "",
    );
  }
}
