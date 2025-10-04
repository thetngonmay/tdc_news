part of 'articles_bloc.dart';

sealed class ArticlesState extends Equatable {
  const ArticlesState();
  @override
  List<Object> get props => [];
}

final class ArticlesInitial extends ArticlesState { }

final class EverythingLoading extends ArticlesState { }

final class EverythingLoaded extends ArticlesState{
  final List<ArticleModel> articles;
  final int page;
  final bool hasReachedMax;

  const EverythingLoaded({required this.articles, required this.page, required this.hasReachedMax});

  EverythingLoaded copyWith({
    List<ArticleModel>? articles,
    int? page,
    bool? hasReachedMax
}){
    return EverythingLoaded(
        articles: articles?? this.articles,
        page: page?? this.page,
        hasReachedMax: hasReachedMax?? this.hasReachedMax
    );
  }

  @override
  List<Object> get props => [articles, page, hasReachedMax];

}
final class EverythingError extends ArticlesState{
  final String message;

  const EverythingError(this.message);
  @override
  List<Object> get props => [message];
}
 final class HeadLineLoading extends ArticlesState{ }

 final class HeadLineLoaded extends ArticlesState{
  final List<ArticleModel> articles;
  final int page;
  final bool hasReachedMax;

  const HeadLineLoaded({required this.articles,required this.page, required this.hasReachedMax, });

  HeadLineLoaded copyWith({
    List<ArticleModel>? articles,
    int? page,
    bool? hasReachedMax,
 }){
    return HeadLineLoaded(
        articles: articles??this.articles,
        page: page?? this.page,
        hasReachedMax: hasReachedMax??this.hasReachedMax
    );
  }
  @override
  List<Object> get props => [articles];
 }
final class HeadLineError extends ArticlesState{
  final String message;

  HeadLineError(this.message);
  @override
  List<Object> get props => [message];
}

