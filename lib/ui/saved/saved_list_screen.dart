import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/bloc/save/save_bloc.dart';
import 'package:news_app2/ui/articles_list_view.dart';

class SaveListScreen extends StatefulWidget{
  const SaveListScreen({super.key});

  @override
  State<StatefulWidget> createState()  => SaveListScreenState();
}

class SaveListScreenState extends State<SaveListScreen>{

  void fetchSavedList(){
    context.read<SaveBloc>().add(GetAllSavedArticlesEvent());
  }

  @override
  void initState() {
    fetchSavedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved List"),
      ),
      body: BlocBuilder<SaveBloc, SaveState>(
        builder: (context, state){
          if(state is GetAllArticlesLoadingState){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(state is GetAllSavedArticlesLoaded){
            return ArticlesListView(state.articles);
          }

          return SizedBox.shrink();
        },
      ),
    );
  }

}