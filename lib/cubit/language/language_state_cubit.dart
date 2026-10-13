abstract class LanguageStateCubit {
  String languageCode;

  LanguageStateCubit({required this.languageCode});
}

class LanguageInitialState extends LanguageStateCubit {
  LanguageInitialState({required super.languageCode});
}

class LanguageChangeState extends LanguageStateCubit {
  LanguageChangeState({required super.languageCode});
}
