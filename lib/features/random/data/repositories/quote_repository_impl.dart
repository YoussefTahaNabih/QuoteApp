import 'package:cleancode/core/error/exceptions.dart';
import 'package:cleancode/core/network/network_info.dart';
import 'package:cleancode/features/random/data/datasources/local_data_source.dart';
import 'package:cleancode/features/random/data/datasources/remote_data_source.dart';
import 'package:cleancode/features/random/domain/entities/quote.dart';
import 'package:cleancode/core/error/failures.dart';
import 'package:cleancode/features/random/domain/repositories/quote_repositories.dart';
import 'package:dartz/dartz.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final NetworkInfo networkInfo;
  final RandomQuoteRemoteDataSource randomQuoteRemoteDataSource;
  final RandomQuoteLocalDataSource randomQuoteLocalDataSource;

  QuoteRepositoryImpl({
    required this.networkInfo,
    required this.randomQuoteRemoteDataSource,
    required this.randomQuoteLocalDataSource,
  });
  @override
  Future<Either<Failure, Quote>> getRandomQuote() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteRandomQuote =
            await randomQuoteRemoteDataSource.getRandomQuote();
        randomQuoteLocalDataSource.cacheQuote(remoteRandomQuote);
        return Right(remoteRandomQuote);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cachRandomQuote =
            await randomQuoteLocalDataSource.getLastRandomQuote();
        return Right(cachRandomQuote);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
