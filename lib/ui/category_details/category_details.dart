import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/di/di.dart';
import 'package:news/di_config/di_config.dart';
import 'package:news/ui/category_details/cubit/source_bloc_state.dart';
import 'package:news/ui/category_details/cubit/source_cubit_view_model.dart';
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
  SourceCubitViewModel sourceCubitViewModel = getIt<SourceCubitViewModel>();
  @override
  void initState() {
    super.initState();
    sourceCubitViewModel.getSource(widget.category?.id ?? 'general');
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
      sourceCubitViewModel.getSource(widget.category?.id ?? 'general');
    });
  }

  @override
  void dispose() {
    sourceCubitViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SourceCubitViewModel, SourceBlocState>(
      bloc: sourceCubitViewModel,
      builder: (context, state) {
        if (state is SourceSuccessState) {
          return SourceTabs(sourceList: state.sourceList);
        } else if (state is SourceErrorState) {
          return MainError(erroMessage: state.errorMessage, opressed: () {
            sourceCubitViewModel.getSource(widget.category!.id);
          });
        } else {
          return MainLoading();
        }
      },);


  }
}
