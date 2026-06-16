import 'package:equatable/equatable.dart';
import 'package:frantend/features/register/domain/entities/register_entity.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterFormState extends RegisterState {
  const RegisterFormState({required this.data});

  final RegisterEntity data;

  @override
  List<Object?> get props => [data];
}

class RegisterLoading extends RegisterState {
  const RegisterLoading({required this.data});

  final RegisterEntity data;

  @override
  List<Object?> get props => [data];
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.data});

  final RegisterEntity data;

  @override
  List<Object?> get props => [data];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure(this.message, {this.data});

  final String message;
  final RegisterEntity? data;

  @override
  List<Object?> get props => [message, data];
}
