import 'package:news/api/apiModel/apiSources/sources.dart';

abstract class SourceBlocState {}

class SourceInitialState extends SourceBlocState {}

class SourceLoadingState extends SourceBlocState {}

class SourceErrorState extends SourceBlocState {
  String errorMessage;

  SourceErrorState({required this.errorMessage});
}

class SourceSuccessState extends SourceBlocState {
  List<Source> sourceList;

  SourceSuccessState({required this.sourceList});
}
