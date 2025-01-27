import 'package:equatable/equatable.dart';

abstract class PetState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<Map<String, String>> pets;

  PetLoaded(this.pets);

  @override
  List<Object?> get props => [pets];
}

class PetError extends PetState {
  final String message;

  PetError(this.message);

  @override
  List<Object?> get props => [message];
}
