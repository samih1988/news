import 'package:flutter/material.dart';
import 'package:news/l10n/app_localizations.dart';
import 'package:news/utils/app_utilz.dart';
import 'package:news/widgets/elevated_button_reuse.dart';

class MainError extends StatelessWidget {
  String erroMessage;
  VoidCallback opressed;

  MainError({super.key, required this.erroMessage, required this.opressed});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Column(
      spacing: height * .02,
      children: [
        Text(erroMessage, style: Theme.of(context).textTheme.labelLarge),
        ElevatedButtonReuse(
          ChildType: Text(
            AppLocalizations.of(context)!.try_again,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          onpressed: opressed,
        ),
      ],
    );
  }
}
