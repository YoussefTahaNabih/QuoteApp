import 'package:cleancode/core/api/api_consumer.dart';
import 'package:cleancode/core/api/dio_consumer.dart';
import 'package:cleancode/features/random/domain/usecases/get_rendom_quote.dart';
import 'package:cleancode/features/splash/domain/usecases/change_lang_usecase.dart';
import 'package:cleancode/features/splash/domain/usecases/get_saved_lang_usecase.dart';
import 'package:cleancode/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/app_interseptor.dart';
import 'core/network/network_info.dart';
import 'features/random/data/datasources/local_data_source.dart';
import 'features/random/data/datasources/remote_data_source.dart';
import 'features/random/data/repositories/quote_repository_impl.dart';
import 'features/random/domain/repositories/quote_repositories.dart';
import 'features/random/presentation/cubit/random_cubit.dart';
import 'features/splash/data/datasources/lang_local_datasource.dart';
import 'features/splash/data/repositories/lang_repository_impl.dart';
import 'features/splash/domain/repositories/lang_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features

  // Blocs
  sl.registerFactory<RandomCubit>(
      () => RandomCubit(getRandomQuoteUseCase: sl()));

  sl.registerFactory<LocaleCubit>(() => LocaleCubit(
        getSavedLangUsecase: sl(),
        changeLocaleUsecase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton<GetRandomQuote>(
      () => GetRandomQuote(quoteRepository: sl()));
  sl.registerLazySingleton<GetSavedLangUsecase>(
      () => GetSavedLangUsecase(langRepository: sl()));
  sl.registerLazySingleton<ChangeLocaleUsecase>(
      () => ChangeLocaleUsecase(langRepository: sl()));

  // Repository
  sl.registerLazySingleton<QuoteRepository>(() => QuoteRepositoryImpl(
      networkInfo: sl(),
      randomQuoteRemoteDataSource: sl(),
      randomQuoteLocalDataSource: sl()));
  sl.registerLazySingleton<LangRepository>(
      () => LangRepositoryImpl(langLocalDataSource: sl()));

  // Data Sources
  sl.registerLazySingleton<RandomQuoteLocalDataSource>(
      () => RandomQuoteLocalDataSourceImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<RandomQuoteRemoteDataSource>(
      () => RandomQuoteRemoteDataSourceImpl(
            apiConsumer: sl(),
          ));
  sl.registerLazySingleton<LangLocalDataSource>(
      () => LangLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppIntercepters());
  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => Dio());
}
