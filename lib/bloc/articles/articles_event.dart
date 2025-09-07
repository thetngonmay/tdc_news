part of 'articles_bloc.dart';

sealed class ArticlesEvent extends Equatable {
  const ArticlesEvent();

  @override
  List<Object?> get props => [];
}

class FetchEverything extends ArticlesEvent{
  final String search;
  final bool isRefresh;

  const FetchEverything(this.search, {this.isRefresh = false});

  @override
  List<Object?> get props =>  [search];
}

class FetchTopHeadLine extends ArticlesEvent{
  final String country;

  const FetchTopHeadLine(this.country);
  @override
  List<Object?> get props => [country];
}
