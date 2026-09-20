import 'package:flutter/material.dart';

import '../../utils/app_utilz.dart';

class ElevatedButtonReuse extends StatelessWidget {
  Widget ChildType;
  VoidCallback onpressed;
  Color? background;

  ElevatedButtonReuse({
    super.key,
    required this.ChildType,
    required this.onpressed,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background ?? Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: onpressed,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: height * .02),
        child: ChildType,
      ),
    );
  }
}
