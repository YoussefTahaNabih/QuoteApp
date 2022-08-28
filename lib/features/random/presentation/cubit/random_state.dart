part of 'random_cubit.dart';

abstract class RandomState extends Equatable {
  const RandomState();

  @override
  List<Object> get props => [];
}

class RandomInitial extends RandomState {}

class RandomIsLoading extends RandomState {}

class RandomLoaded extends RandomState {
  final Quote quote;

  const RandomLoaded({required this.quote});
  @override
  List<Object> get props => [quote];
}

class RandomIsError extends RandomState {
  final String msg;

  const RandomIsError({required this.msg});
  @override
  List<Object> get props => [msg];
}
