import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app2/network/repository/article_repository.dart';
import 'package:news_app2/network/response/article_model.dart';
import 'package:news_app2/network/response/error_response.dart';
import 'package:news_app2/network/response/response_model.dart';
import 'package:news_app2/network/service/api_response.dart';

part 'articles_event.dart';
part 'articles_state.dart';

class ArticlesBloc extends Bloc<ArticlesEvent, ArticlesState> {

  final ArticleRepository repo;

  ArticlesBloc(this.repo) : super(ArticlesInitial()) {

    on<FetchEverything>((event, emit) async{

      final currentState = state;
      List<ArticleModel> oldArticles = [];
      int nextPage = 1;
      final pageSize = 20;

      if(currentState is EverythingLoaded && !currentState.hasReachedMax && !event.isRefresh){
        oldArticles = currentState.articles;
        nextPage = currentState.page + 1;
      }else {
        emit(EverythingLoading());
      }

      final response = await repo.fetchEverything(
          searchKey: event.search,
        page: nextPage,
        pageSize: pageSize
      );

      if (response is Success<ResponseModel, ErrorResponse>){
        final newArticles = response.data.articles;
        final allArticles = [...oldArticles, ...newArticles];

        final hasReachedMax = newArticles.isEmpty || newArticles.length < pageSize;

        emit(EverythingLoaded(
          articles: allArticles,
          page: nextPage,
          hasReachedMax: hasReachedMax
        ));
      }else if(response is Fail<ResponseModel, ErrorResponse>){
        emit(EverythingError(response.error.message));
      }
    });

    on<FetchTopHeadLine>((event, emit) async{
      final currentState = state;
      List<ArticleModel> oldArticles = [];
      int nextPage = 1;
      final int pageSize = 20;

      if(currentState is HeadLineLoaded && !currentState.hasReachedMax){
        oldArticles = currentState.articles;
        nextPage = nextPage + 1;
      }else {
        emit(HeadLineLoading());
      }

      final response= await repo.fetchTopHeadLine(
          country: event.country,
        page: nextPage,
        pageSize: pageSize
      );

      if(response is Success<ResponseModel, ErrorResponse>){
        final newArticles = response.data.articles;
        final allArticles = [...oldArticles, ...newArticles];
        final hasReachedMax = newArticles.isEmpty || newArticles.length < pageSize;
        emit(HeadLineLoaded(
            articles: allArticles,
            page: nextPage,
            hasReachedMax: hasReachedMax)
        );
      } else if(response is Fail<ResponseModel, ErrorResponse>){
        emit(HeadLineError(response.error.message));
      }
    });
  }
}
