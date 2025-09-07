import 'package:news_app2/network/response/base_model.dart';
import 'package:news_app2/network/response/source_model.dart';

class ArticleModel implements BaseModel{
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urltoImage;
  final String publishedAt;
  final String content;

  ArticleModel(
      this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urltoImage,
      this.publishedAt,
      this.content
      );
  factory ArticleModel.fromMap(Map<String,dynamic> map){
    return ArticleModel(
        SourceModel.fromMap(map['source']),
        map['author']??"",
        map['title']??"",
        map['description']??"",
        map['url']??"",
        map['urlToImage']??"",
        map['publishedAt']??"",
        map['content']);
  }

  // From database
  factory ArticleModel.fromDb(Map<String,dynamic> map){
    return ArticleModel(
        SourceModel.fromDbString(map['source']),
        map['author']??"",
        map['title']??"",
        map['description']??"",
        map['url']??"",
        map['urlToImage']??"",
        map['publishedAt']??"",
        map['content']);
  }
  
  @override
  Map<String,dynamic> toMap(){
    return {
      'source': source.toDbString(),
      'author':author,
      'title':title,
      'description':description,
      'url':url,
      'urlToImage':urltoImage,
      'publishedAt':publishedAt,
      'content':content
    };
  }

}