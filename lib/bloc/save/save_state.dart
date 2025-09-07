part of 'save_bloc.dart';

sealed class SaveState extends Equatable {
  const SaveState();
  @override
  List<Object> get props => [];
}

final class SaveInitial extends SaveState { }

final class SaveArticleSuccessState extends SaveState {}

final class UnsaveArticleSuccessState extends SaveState {}

class SavedStatusChecked extends SaveState{
  final bool isSaved;
  const SavedStatusChecked(this.isSaved);

  @override
  List<Object> get props => [isSaved];
}

final class GetAllArticlesLoadingState extends SaveState {}

final class GetAllSavedArticlesLoaded extends SaveState{
  final List<ArticleModel> articles;

  const GetAllSavedArticlesLoaded(this.articles);

  @override
  List<Object> get props => [articles];

}
