import 'package:flutter/material.dart';
import 'package:news/api/apiModel/apiSources/sources.dart';
import 'package:news/ui/category_details/tabs_widget.dart';
import 'package:news/ui/news/news_detailes.dart';
import 'package:news/utils/app_colors.dart';
import 'package:news/utils/app_utilz.dart';

class SourceTabs extends StatefulWidget {
  List<Source> sourceList;

  SourceTabs({super.key, required this.sourceList});

  @override
  State<SourceTabs> createState() => _SourceTabsState();
}

class _SourceTabsState extends State<SourceTabs> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * .02),
      child: DefaultTabController(
        length: widget.sourceList.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Theme.of(context).splashColor,
              dividerColor: AppColors.transparentColor,
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
              tabs: widget.sourceList.map((source) {
                return TabsWidget(
                  source: source,
                  isselected:
                      selectedIndex == widget.sourceList.indexOf(source),
                );
              }).toList(),
            ),
            Expanded(
                child: NewsDetailes(source: widget.sourceList[selectedIndex])),
          ],
        ),
      ),
    );
  }
}
