import 'package:dartz/dartz.dart';
import 'package:morty_api/core/error/exeption.dart';
import 'package:morty_api/core/error/failure.dart';
import 'package:morty_api/feature/data/datasources/person_remote_data_source.dart';
import 'package:morty_api/feature/data/models/person_model.dart';
import 'package:morty_api/feature/domain/entities/person_entity.dart';
import 'package:morty_api/feature/domain/repositories/person_repository.dart';

import '../../../core/platform/network_info.dart';
import '../datasources/person_local_data_source.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPersons(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource.searchPerson(query);
    });
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        localDataSource.personsToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPerson = await localDataSource.getLastPersonsFromCache();
        return Right(localPerson);
      } on CacheExeption {
        return Left(CacheFailure());
      }
    }
  }
}
