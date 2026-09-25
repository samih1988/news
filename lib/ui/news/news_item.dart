import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/utils/app_styles.dart';
import 'package:news/utils/app_utilz.dart';
import 'package:news/widgets/main_loading.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../api/apiModel/apiNews/Articles.dart';

class NewsCardWidget extends StatelessWidget {
  final Articles news;

  const NewsCardWidget({
    super.key,
    required this.news
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: width * .04, vertical: height * .02),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * .02, vertical: height * .02),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme
              .of(context)
              .splashColor),
        ),
        child: Column(
          spacing: height * .02,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. الصورة
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: news.urlToImage ?? '',
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    MainLoading(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),

            // 2. التكست اللي تحت الصورة
            Text(
              news.title ?? '',
              style: Theme
                  .of(context)
                  .textTheme
                  .labelLarge,
            ),

            // 3. الاتنين تكست اللي قصاد بعض
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(
                  "By:${news.author}", style: AppStyles.medium12gray,)),
                Text(
                    timeago.format(
                      DateTime.parse(
                          news.publishedAt ?? DateTime.now().toString()),
                      locale: 'ar', // عرض الوقت باللغة العربية
                    ),
                    style: AppStyles.medium12gray
                )
                ,
              ],
            ),
          ],
        ),
      ),
    );
  }
}