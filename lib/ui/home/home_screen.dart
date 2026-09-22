import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/widgets/custom_drawer.dart';

import '../category_details/category_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.home,

        ),
      ),
      drawer: const CustomDrawer(),
      body: CategoryDetails(),
    );
  }
}

