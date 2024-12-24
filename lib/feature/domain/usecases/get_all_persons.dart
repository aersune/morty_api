import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:morty_api/core/error/failure.dart';
import 'package:morty_api/core/usecases/usecases.dart';
import 'package:morty_api/feature/domain/entities/person_entity.dart';
import 'package:morty_api/feature/domain/repositories/person_repository.dart';

class GetAllPersons extends Usecase<List<PersonEntity>, PagePersonParams> {
  final PersonRepository personRepository;
  GetAllPersons(this.personRepository);

 @override
  Future<Either<Failure, List<PersonEntity>>> call(PagePersonParams params)  async{
    return await personRepository.getAllPersons(params.page);
  }
  
}

class PagePersonParams extends Equatable {
  final int page;

  const PagePersonParams({required this.page});

  @override
 
  List<Object?> get props => [page];
}