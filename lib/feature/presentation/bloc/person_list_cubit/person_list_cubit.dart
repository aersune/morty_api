
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morty_api/feature/domain/entities/person_entity.dart';
import 'package:morty_api/feature/domain/usecases/get_all_persons.dart';
import 'package:morty_api/feature/presentation/bloc/person_list_cubit/person_list_state.dart';

import '../../../../core/error/failure.dart';

class PersonListCubit extends Cubit<PersonState> {
  final GetAllPersons getAllPersons;
  PersonListCubit({required this.getAllPersons}) : super(PersonEmpty());

  int page = 1;

  void loadPerson() async{
    if(state is PersonLoading) return;

    final currentState = state;

    var oldPerson = <PersonEntity> [];


    if(currentState is PersonLoaded) {
        oldPerson = currentState.personsList;
    }
    emit(PersonLoading(oldPersonList: oldPerson, isFirstFetch: page == 1));

    final failureOrPerson = await getAllPersons(PagePersonParams(page: page));

    failureOrPerson.fold((error) => PersonError(message: _mapFailureToMessage(error)), (character) {
      page++;
      final persons = (state as PersonLoading).oldPersonList;
      persons.addAll(character);
      emit(PersonLoaded(personsList: persons));
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return "SERVER_FAILURE";
      case CacheFailure:
        return "CACHE_FAILURE";
      default:
        return 'Unexpected Error';
    }}

}