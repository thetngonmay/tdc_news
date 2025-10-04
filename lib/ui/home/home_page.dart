
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/bloc/articles/articles_bloc.dart';
import 'package:news_app2/bloc/save/save_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../articles_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<HomePage> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshEverything();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    fetchEverything();
    _refreshController.loadComplete();
  }

  void refreshEverything(){
    context.read<ArticlesBloc>().add(FetchEverything("bitcoin", isRefresh: true));
  }

  void fetchEverything(){
    context.read<ArticlesBloc>().add(FetchEverything("bitcoin"));
  }

  void fetchSavedList(){
    context.read<SaveBloc>().add(GetAllSavedArticlesEvent());
  }

  @override
  void initState() {
    fetchEverything();
    fetchSavedList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Article")),
      body: BlocBuilder<ArticlesBloc, ArticlesState>(
        builder: (context, state){
          if(state is EverythingLoading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(state is EverythingError){
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(state.message, textAlign: TextAlign.center,)
                  ],
                ),
              ),
            );
          }
          if(state is EverythingLoaded){
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              header: WaterDropHeader(),
              footer: CustomFooter(
                  builder: (context, status){
                    if(state.hasReachedMax){
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Text("You have read all!"),
                      );
                    }
                    return CupertinoActivityIndicator();
                  }
              ),
              child: ListView.builder(
                itemCount: state.articles.length,
                itemBuilder: (BuildContext context, int index) {
                  return ArticleItemView(data: state.articles[index]);
                },
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
