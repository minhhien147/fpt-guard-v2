class NewsModel {
  final int id;
  final String title;
  final String description;
  final String link;
  final String published;
  final String source;
  final String category;
  final String? image;

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.link,
    required this.published,
    required this.source,
    required this.category,
    this.image,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      link: json['link'] ?? '',
      published: json['published'] ?? '',
      source: json['source'] ?? '',
      category: json['category'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'link': link,
      'published': published,
      'source': source,
      'category': category,
      'image': image,
    };
  }
}

