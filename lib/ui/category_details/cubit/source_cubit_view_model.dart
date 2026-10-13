import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:news/data/repository/sources/repository/source_repository.dart';
import 'package:news/ui/category_details/cubit/source_bloc_state.dart';

@injectable
class SourceCubitViewModel extends Cubit<SourceBlocState> {
  SourceRepository sourceRepository;

  SourceCubitViewModel({required this.sourceRepository})
    : super(SourceLoadingState());

  void getSource(String categoryId) async {
    try {
      emit(SourceLoadingState());
      var response = await sourceRepository.getSource(categoryId);
      if (response.status == 'error') {
        emit(SourceErrorState(errorMessage: response.message!));
      } else {
        emit(SourceSuccessState(sourceList: response.sources ?? []));
      }
    } catch (e) {
      emit(SourceErrorState(errorMessage: e.toString()));
    }
  }
}
