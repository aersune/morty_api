
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morty_api/core/error/failure.dart';
import 'package:morty_api/feature/domain/usecases/search_person.dart';
import 'package:morty_api/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:morty_api/feature/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;
  PersonSearchBloc({required this.searchPerson}) : super(PersonEmpty());

  Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
    if (event is SearchPersons) {
      yield* _mapFetchPersonToState(event.personQuery);
    } else {
      yield PersonEmpty();
    }

  }


  Stream<PersonSearchState> _mapFetchPersonToState(String personQuery) async*{
    yield PersonSearchLoading();

    final failureOrPerson = await searchPerson(SearchPersonParams(query: personQuery));

    yield failureOrPerson.fold((failure) => PersonSearchError(message: _mapFailureToMessage(failure)), (person) => PersonSearchLoaded(persons: person));
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