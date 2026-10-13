import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubit/language/language_state_cubit.dart';
import 'package:news/sharedPreference/preferences_helper.dart';

class LanguageViewModelCubit extends Cubit<LanguageStateCubit> {
  LanguageViewModelCubit()
    : super(LanguageInitialState(languageCode: PreferencesHelper.getLang()));

  String get currentLanguage => state.languageCode;

  void changeAppLanguage(String newLanguage) {
    if (state.languageCode == newLanguage) return;
    PreferencesHelper.saveLang(newLanguage);
    emit(LanguageChangeState(languageCode: newLanguage));
  }
}
