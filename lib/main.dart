import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:morty_api/locator_service.dart'  as di;

import 'feature/presentation/bloc/person_list_cubit/person_list_cubit.dart';
import 'feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'feature/presentation/pages/person_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (_) => di.sl<PersonListCubit>()),
      BlocProvider(create: (_) => di.sl<PersonSearchBloc>()),
    ], child: MaterialApp(
      title: 'Rick and Morty',
      theme: ThemeData.dark().copyWith(

        scaffoldBackgroundColor: Colors.grey
      ),
      home: HomePage(),
    ));
  } 
}



