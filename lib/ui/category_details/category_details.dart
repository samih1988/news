import 'package:flutter/material.dart';
import 'package:news/ui/category_details/source_tabs.dart';
import 'package:news/viewModels/source_view_model.dart';
import 'package:news/widgets/main_error.dart';
import 'package:news/widgets/main_loading.dart';
import 'package:provider/provider.dart';

import '../../models/category_model.dart';

class CategoryDetails extends StatefulWidget {
  final CategoryModel? category;

  const CategoryDetails({super.key, this.category});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  SourceViewModel sourceViewModel = SourceViewModel();
  @override
  void initState() {
    super.initState();
    sourceViewModel.getSource(widget.category?.id ?? 'general');
  }

  @override
  void didUpdateWidget(covariant CategoryDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category?.id != widget.category?.id) {
      _refreshData();
    }
  }

  void _refreshData() {
    setState(() {
      sourceViewModel.getSource(widget.category?.id ?? 'general');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => sourceViewModel,
      child: Consumer<SourceViewModel>(builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return MainLoading();
        }
        else if (viewModel.errorMessage != null) {
          return MainError(erroMessage: viewModel.errorMessage!,
              opressed: () {
                viewModel.getSource(widget.category!.id);
              });
        }
        else if (viewModel.sourceList == null) {
          return MainLoading();
        } else {
          return SourceTabs(sourceList: viewModel.sourceList!);
        }
      },),
    );
  }
}
