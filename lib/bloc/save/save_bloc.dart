import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app2/database/generic_dao.dart';
import 'package:news_app2/network/response/article_model.dart';

part 'save_event.dart';
part 'save_state.dart';

class SaveBloc extends Bloc<SaveEvent, SaveState> {

  final saveDao = GenericDao(
      tableName: 'save_articles',
      uniqueColumn: 'url',
      fromMap: (map) => ArticleModel.fromDb(map)
  );

  SaveBloc() : super(SaveInitial()) {

    on<SaveArticleEvent>((event, emit) async{
      await saveDao.insert(event.article);
      emit(SaveArticleSuccessState());
    });


    on<UnSaveArticleEvent>((event, emit) async {
      await saveDao.delete(event.url);
      emit(UnsaveArticleSuccessState());
    });

    on<CheckSavedStatusEvent>((event, emit) async{
      final exists = await saveDao.exists(event.url);
      emit(SavedStatusChecked(exists));
    });

    on<GetAllSavedArticlesEvent>((event, emit)async {
      emit(GetAllArticlesLoadingState());
      final savedList = await saveDao.getAll();
      emit(GetAllArticlesLoaded(savedList));
    });

  }
}
