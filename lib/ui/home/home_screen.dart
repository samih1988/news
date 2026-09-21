import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.home,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
