import 'package:news_app2/network/response/article_model.dart';

class ResponseModel {
  final String static;
  final int totalResult;
  final List<ArticleModel> articles;

  ResponseModel(this.static, this.totalResult, this.articles);

  factory ResponseModel.fromMap(Map<String, dynamic> map) {
    return ResponseModel(
      map['static'] ?? "",
      map['totalResult'] ?? 0,
      (map['articles'] as List<dynamic>)
          .map((article) => ArticleModel.fromMap(article))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'static': static,
      'totalResult': totalResult,
      'articles': articles.map((articles) => (articles).toMap()).toList(),
    };
  }
}
