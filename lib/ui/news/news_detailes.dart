import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiNews/News_response.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/api/api_manager.dart';
import 'package:news/ui/news/news_item.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';

class NewsDetailes extends StatefulWidget {
  Source source;

  NewsDetailes({super.key, required this.source});

  @override
  State<NewsDetailes> createState() => _NewsDetailesState();
}

class _NewsDetailesState extends State<NewsDetailes> {
  late Future<NewsResponse?> futureNewsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  void didUpdateWidget(covariant NewsDetailes oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 2. التحقق: لو المستخدم غير التاب (المصدر الجديد مش هو القديم)
    if (oldWidget.source.id != widget.source.id) {
      getdata(); // احلب أخبار المصدر الجديد فوراً
    }
  }

  void getdata() {
    setState(() {
      futureNewsList = ApiManager.getNewsBySourceId(widget.source.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureNewsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainLoading();
        } else if (snapshot.hasError) {
          return MainError(
            erroMessage: snapshot.error.toString(),
            opressed: () {
              getdata();
              setState(() {});
            },
          );
        } else {
          var newsList = snapshot.data?.articles ?? [];
          return newsList.isEmpty
              ? Center(
                  child: Text(
                    "No News Found",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return NewsCardWidget(news: newsList[index]);
                  },
                  itemCount: newsList.length,
                );
        }
      },
    );
  }
}
