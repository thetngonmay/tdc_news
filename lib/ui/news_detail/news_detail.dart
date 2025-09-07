import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app2/bloc/save/save_bloc.dart';
import 'package:news_app2/network/response/article_model.dart';
import 'package:news_app2/ui/saved/saved_list_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  final ArticleModel data;

  const NewsDetail({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  late final WebViewController _controller;
  bool isLoading = true;

  void initWebView() {
    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              isLoading = true;
            });
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(Uri.parse(widget.data.url));

    _controller = controller;
  }

  void checkSaved() {
    context.read<SaveBloc>().add(CheckSavedStatusEvent(widget.data.url));
  }

  @override
  void initState() {
    super.initState();
    initWebView();
    checkSaved();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveBloc, SaveState>(
      listener: (context, state) {
        if (state is SaveArticleSuccessState) {
          checkSaved();
          _showMessage("Successfully saved to Save List");
        }
        if(state is UnsaveArticleSuccessState){
          checkSaved();
          _showMessage("Successfully removed from Save List!");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.data.title),
          bottom: isLoading
              ? PreferredSize(
                  preferredSize: Size.fromHeight(2.0),
                  child: LinearProgressIndicator(),
                )
              : null,
          actions: [
            IconButton(onPressed: ()async{
              await Navigator.push(context, MaterialPageRoute(builder: (context)=> SaveListScreen()));
              checkSaved();
            }, icon: Icon(Icons.save_rounded))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (isLoading) Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocSelector<SaveBloc, SaveState, bool>(
                  selector: (state) {
                    if (state is SavedStatusChecked) return state.isSaved;
                    return false;
                  },
                  builder: (context, isSaved) {
                    return IconButton(
                      onPressed: () {
                        if(isSaved){
                          context.read<SaveBloc>().add(UnSaveArticleEvent(widget.data.url));
                        }else{
                          context.read<SaveBloc>().add(
                            SaveArticleEvent(widget.data),
                          );
                        }
                      },
                      icon: Icon(
                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                      ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        title: widget.data.title,
                        text: widget.data.url,
                      ),
                    );
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _showMessage(String text){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      )
    );
  }
}
