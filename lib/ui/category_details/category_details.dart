import 'package:flutter/material.dart';
import 'package:news/api/api_manager.dart';
import 'package:news/ui/category_details/source_tabs.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';

import '../../api/apiModel/apiSources/source_response.dart';
import '../../models/category_model.dart';

class CategoryDetails extends StatefulWidget {
  final CategoryModel? category;

  const CategoryDetails({super.key, this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  late Future<SourceResponse?> sourcesFuture;

  @override
  void initState() {
    super.initState();
    sourcesFuture = ApiManager.getSource(widget.category?.id ?? 'general');
  }

  void _refreshData() {
    setState(() {
      // بنجدد الـ Future عشان الـ FutureBuilder يحس بالتغيير ويعيد الطلب
      sourcesFuture = ApiManager.getSource(widget.category?.id ?? 'general');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sourcesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MainLoading();
        } else if (snapshot.hasError) {
          return MainError(
            erroMessage: snapshot.error.toString(),
            opressed: () {
              _refreshData();
            },
          );
        } else if (snapshot.data?.status != 'ok') {
          return MainError(
            erroMessage: snapshot.data!.message!,
            opressed: () {
              _refreshData();
            },
          );
        }
        var sourceList = snapshot.data?.sources ?? [];
        return SourceTabs(sourceList: sourceList);
      },
    );
  }
}
