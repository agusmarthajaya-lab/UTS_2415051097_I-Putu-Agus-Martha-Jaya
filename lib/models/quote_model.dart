class QuoteModel {
  final String quote;
  final String author;

  QuoteModel({
    required this.quote,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      quote: json['q'] ?? json['quote'] ?? json['content'] ?? 'Tetap semangat, sukses ada di depan mata!',
      author: json['a'] ?? json['author'] ?? 'Anonim',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quote': quote,
      'author': author,
    };
  }
}
