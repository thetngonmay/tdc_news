import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/bloc/articles/articles_bloc.dart';
import 'package:news_app2/bloc/save/save_bloc.dart';
import 'package:news_app2/network/repository/article_repository.dart';
import 'package:news_app2/network/service/api.dart';
import 'package:news_app2/ui/home/home_page.dart';

import 'bloc/app_bloc.dart';

void main() {
  Bloc.observer= const AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[
        BlocProvider<SaveBloc>(create: (context) => SaveBloc()),
        BlocProvider<ArticlesBloc>(create:(context)=>ArticlesBloc(ArticleRepository(Api()))),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}