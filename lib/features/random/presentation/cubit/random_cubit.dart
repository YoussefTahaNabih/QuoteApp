import 'package:cleancode/core/error/failures.dart';
import 'package:cleancode/core/usecase/usecase.dart';
import 'package:cleancode/features/random/domain/entities/quote.dart';
import 'package:cleancode/features/random/domain/usecases/get_rendom_quote.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_strings.dart';

part 'random_state.dart';

class RandomCubit extends Cubit<RandomState> {
  final GetRandomQuote getRandomQuoteUseCase;
  RandomCubit({required this.getRandomQuoteUseCase}) : super(RandomInitial());

  Future<void> getRandomQuote() async {
    emit(RandomIsLoading());
    Either<Failure, Quote> response = await getRandomQuoteUseCase(NoParams());
    emit(response.fold(
        (failure) => RandomIsError(msg: _mapFailureToMsg(failure)),
        (quote) => RandomLoaded(quote: quote)));
  }

  String _mapFailureToMsg(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return AppStrings.serverFailure;
      case CacheFailure:
        return AppStrings.cacheFailure;

      default:
        return AppStrings.unexpectedError;
    }
  }
}
