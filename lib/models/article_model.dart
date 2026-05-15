class ArticleModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String? imageUrl;
  final String author;
  final DateTime publishedDate;
  final List<String> tags;
  final int readTimeMinutes;

  ArticleModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    this.imageUrl,
    required this.author,
    required this.publishedDate,
    this.tags = const [],
    required this.readTimeMinutes,
  });
}

class TipModel {
  final String id;
  final String title;
  final String description;
  final String? iconUrl;

  TipModel({
    required this.id,
    required this.title,
    required this.description,
    this.iconUrl,
  });
}
