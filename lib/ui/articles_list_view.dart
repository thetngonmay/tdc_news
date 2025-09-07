import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/bloc/save/save_bloc.dart';
import 'package:news_app2/network/response/article_model.dart';
import 'package:news_app2/ui/news_detail/news_detail.dart';

class ArticlesListView extends StatelessWidget {
  final List<ArticleModel> articles;

  const ArticlesListView(this.articles, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (BuildContext context, int index) {
        return ArticleItemView(data: articles[index]);
      },
    );
  }
}

class ArticleItemView extends StatelessWidget {
  final ArticleModel data;

  const ArticleItemView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaveBloc, SaveState>(
      builder: (context, state){
        bool isSaved = false;
        if (state is GetAllSavedArticlesLoaded) {
          isSaved = state.articles.any((a)=> a.url == data.url);
        }
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsDetail(data: data,)));
          },
          child: Container(
            padding: EdgeInsets.only(left: 15, bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: data.urltoImage,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => SizedBox(
                      width: 100,
                      height: 100,
                      child: CupertinoActivityIndicator(),
                    ),
                    errorWidget: (_, _, _) =>
                        Container(width: 100, height: 100, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              data.title,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsDetail(data: data,)));
                            },
                            icon: Icon(isSaved?Icons.bookmark:Icons.bookmark_border),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Text(
                        data.source.name,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
