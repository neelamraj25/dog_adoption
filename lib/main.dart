import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_bloc.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_event.dart';
import 'package:pet_adoption_app/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:BlocProvider(
      create: (context) => PetBloc()..add(FetchPets()),
      child: HomePage(),
    ));
  }
}
