class QuoteModel {
  final String quote;
  final String author;

  QuoteModel({required this.quote, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      quote: json['q'] ?? json['quote'] ?? 'Keep coding and stay awesome!',
      author: json['a'] ?? json['author'] ?? 'Unknown',
    );
  }
}
