class BlogsModel {
  final int? id;
  final String title;
  final String body;

  final String imageUrl;

  BlogsModel({
    this.id,
    required this.title,
    required this.body,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };
  }

  static BlogsModel fromMap(Map<String, dynamic> map) {
    return BlogsModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      imageUrl: map['imageUrl'],
    );
  }
}
