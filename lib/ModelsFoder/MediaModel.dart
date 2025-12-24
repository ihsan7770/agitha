class MediaModel {
  String? id;
  String news;
  String link;

  MediaModel({
    this.id,
    required this.news,
    required this.link,
  });


  Map<String, dynamic> toMap() {
    return {
      'news': news,
      'link': link,
    };
  }


  factory MediaModel.fromMap(Map<String, dynamic> map, String id) {
    return MediaModel(
      id: id,
      news: map['news'] ?? '',
      link: map['link'] ?? '',
    );
  }
}
