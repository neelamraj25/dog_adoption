import 'package:equatable/equatable.dart';

abstract class PetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPets extends PetEvent {}

class SearchPets extends PetEvent {
  final String query;

  SearchPets(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterPets extends PetEvent {
  final String filter;

  FilterPets(this.filter);

  @override
  List<Object?> get props => [filter];
}
