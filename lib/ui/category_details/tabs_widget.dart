import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';

class TabsWidget extends StatelessWidget {
  bool isselected;
  Source source;

  TabsWidget({super.key, required this.source, required this.isselected});

  @override
  Widget build(BuildContext context) {
    return Text(
      source.name ?? '',
      style: isselected
          ? Theme.of(context).textTheme.labelLarge
          : Theme.of(context).textTheme.labelMedium,
    );
  }
}
