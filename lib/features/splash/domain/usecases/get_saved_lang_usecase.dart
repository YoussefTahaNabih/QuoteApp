import 'package:cleancode/core/error/failures.dart';
import 'package:cleancode/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';

import '../repositories/lang_repository.dart';

class GetSavedLangUsecase implements UseCase<String, NoParams> {
  final LangRepository langRepository;

  GetSavedLangUsecase({required this.langRepository});
  @override
  Future<Either<Failure, String>> call(NoParams params) async =>
      await langRepository.getSavedLang();
}
