
import 'package:equatable/equatable.dart';
import 'package:morty_api/feature/domain/entities/person_entity.dart';

abstract class PersonState extends Equatable {
  const PersonState();


  @override
  List<Object?> get props => [];
}



class PersonEmpty extends PersonState {
  @override
  List<Object?> get props => [];

}


class PersonLoading extends PersonState {
  final List<PersonEntity> oldPersonList;
  final bool isFirstFetch;

  const PersonLoading({required this.oldPersonList, this.isFirstFetch = false});


  @override
  List<Object?> get props => [oldPersonList];
}

class PersonLoaded extends PersonState {
  final List<PersonEntity> personsList;

 const PersonLoaded({required this.personsList});

  @override
  List<Object?> get props => [personsList];
}


class PersonError extends PersonState {
  final String message;

  const PersonError({required this.message});

  @override
  List<Object?> get props => [message];
}










