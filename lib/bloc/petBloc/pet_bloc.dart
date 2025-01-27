
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_event.dart';
import 'package:pet_adoption_app/bloc/petBloc/pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final List<Map<String, String>> allPets = [
    {"name": "Bella", "breed": "Labrador Retriever", "age": "2", "image": "assets/bella.jpeg","price":"10000"},
    {"name": "Max", "breed": "German Shepherd", "age": "3", "image": "assets/bull_dog.jpg","price":"40000"},
    {"name": "Luna", "breed": "Siberian Husky", "age": "1", "image": "assets/dog1.jpeg","price":"50000"},
    {"name": "Charlie", "breed": "Golden Retriever", "age": "4", "image": "assets/dog2.jpg","price":"5000"},
    {"name": "Daisy", "breed": "Beagle", "age": "1", "image": "assets/dog3.jpg","price":"10000"},
    {"name": "Cooper", "breed": "Border Collie", "age": "3", "image": "assets/dog4.jpeg","price":"40000"},
    {"name": "Rocky", "breed": "Rottweiler", "age": "2", "image": "assets/dog6.jpeg","price":"80000"},
    {"name": "Molly", "breed": "Cavalier King Charles Spaniel", "age": "4", "image": "assets/dog7.jpeg","price":"50000"},
    {"name": "Bailey", "breed": "Australian Shepherd", "age": "5", "image": "assets/dog9.jpeg","price":"30000"},
    {"name": "Buddy", "breed": "Boxer", "age": "2", "image": "assets/bull_dog.jpg","price":"10000"},
    {"name": "Ba", "breed": "Labrador Retriever", "age": "2", "image": "assets/bella.jpeg","price":"10000"},
    {"name": "Ma", "breed": "German Shepherd", "age": "3", "image": "assets/bull_dog.jpg","price":"40000"},
    {"name": "La", "breed": "Siberian Husky", "age": "1", "image": "assets/dog1.jpeg","price":"50000"},
    {"name": "Chaie", "breed": "Golden Retriever", "age": "4", "image": "assets/dog2.jpg","price":"5000"},
    {"name": "Dsy", "breed": "Beagle", "age": "1", "image": "assets/dog3.jpg","price":"10000"},
    {"name": "Coop", "breed": "Border Collie", "age": "3", "image": "assets/dog4.jpeg","price":"40000"},
    {"name": "Rock", "breed": "Rottweiler", "age": "2", "image": "assets/dog6.jpeg","price":"80000"},
    {"name": "Moy", "breed": "Cavalier King Charles Spaniel", "age": "4", "image": "assets/dog7.jpeg","price":"50000"},
    {"name": "Bey", "breed": "Australian Shepherd", "age": "5", "image": "assets/dog9.jpeg","price":"30000"},
    {"name": "Bussy", "breed": "Boxer", "age": "2", "image": "assets/bull_dog.jpg","price":"10000"},
  ];

  PetBloc() : super(PetInitial()) {
    on<FetchPets>((event, emit) async {
      emit(PetLoading());
      await Future.delayed(Duration(seconds: 1)); 
      emit(PetLoaded(allPets));
    });

   on<SearchPets>((event, emit) {
  final filteredPets = allPets
      .where((pet) => pet['name']!.toLowerCase().contains(event.query.toLowerCase()))
      .toList();
  
  if (filteredPets.isEmpty) {
    emit(PetLoaded([]));
  } else {
    emit(PetLoaded(filteredPets)); 
  }
});



    on<FilterPets>((event, emit) {
      final filteredPets = allPets
          .where((pet) => pet['breed'] == event.filter)
          .toList();
      emit(PetLoaded(filteredPets)); 
    });
  }
}
