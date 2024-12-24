import 'package:dartz/dartz.dart';
import 'package:morty_api/core/error/failure.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);

}