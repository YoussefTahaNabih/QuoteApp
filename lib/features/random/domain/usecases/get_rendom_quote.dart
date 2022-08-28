import 'package:cleancode/core/error/failures.dart';
import 'package:cleancode/core/usecase/usecase.dart';
import 'package:cleancode/features/random/domain/entities/quote.dart';
import 'package:dartz/dartz.dart';

import '../repositories/quote_repositories.dart';

class GetRandomQuote implements UseCase<Quote, NoParams> {
  final QuoteRepository quoteRepository;

  GetRandomQuote({required this.quoteRepository});
  @override
  Future<Either<Failure, Quote>> call(NoParams params) =>
      quoteRepository.getRandomQuote();
}
