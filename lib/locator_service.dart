import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:morty_api/core/platform/network_info.dart';
import 'package:morty_api/feature/data/datasources/person_local_data_source.dart';
import 'package:morty_api/feature/data/datasources/person_remote_data_source.dart';
import 'package:morty_api/feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'package:morty_api/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'feature/data/repositories/person_repository_impl.dart';
import 'feature/domain/repositories/person_repository.dart';
import 'feature/domain/usecases/get_all_persons.dart';
import 'feature/domain/usecases/search_person.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //BLoc /Cubit
  sl.registerFactory(() => PersonListCubit(getAllPersons: sl()));
  sl.registerFactory(() => PersonSearchBloc(searchPerson: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetAllPersons(sl()));
  sl.registerLazySingleton(() => SearchPerson(sl()));

  // Repository
  sl.registerLazySingleton<PersonRepository>(() => PersonRepositoryImpl(
      remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  sl.registerLazySingleton<PersonRemoteDataSource>(() => PersonRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<PersonLocalDataSource>(() => PersonLocalDataSourceImpl(sharedPreferences: sl()));

  //Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
}
