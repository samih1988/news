import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiNews/Articles.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/ui/news/news_web_view.dart';
import 'package:news/utils/app_utilz.dart';
import 'package:news/widgets/elevated_button_reuse.dart';

import '../../widgets/main_loading.dart';

class NewsMoadlDialog {
  static void showFixedTextModal(BuildContext context,
      {required Articles news}) {
    String displayedText = news.title!;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        var height = context.height;
        return AlertDialog(
          backgroundColor: Theme
              .of(context)
              .splashColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),

          ),
          contentPadding: EdgeInsets.all(10.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 16.0),
          content: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.90,
            child: Column(
              crossAxisAlignment: .stretch,
              mainAxisSize: .min,
              spacing: height * .02,
              children: [
                // الصورة
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: news.urlToImage ?? '',
                    progressIndicatorBuilder: (context, url,
                        downloadProgress) =>
                        MainLoading(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),

                Text(
                  displayedText,
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayLarge
                  ,
                ),

                // الزرار
                SizedBox(
                    width: double.infinity,
                    child:
                    ElevatedButtonReuse(ChildType:
                    Text(AppLocalizations.of(context)!.view_full_articles,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium,),
                      onpressed: () {
                        final navigator = Navigator.of(context);
                        navigator.pop();
                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) =>
                                MyWebViewScreen(url: news.url ?? '',
                                  sourceTitle: news.source!.name ?? '',),
                          ),
                        );
                      }
                      , background: Theme
                          .of(context)
                          .primaryColor,)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

