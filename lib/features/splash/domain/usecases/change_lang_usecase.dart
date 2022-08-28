import 'package:cleancode/core/error/failures.dart';
import 'package:cleancode/core/usecase/usecase.dart';
import 'package:cleancode/features/splash/domain/repositories/lang_repository.dart';
import 'package:dartz/dartz.dart';

class ChangeLocaleUsecase implements UseCase<bool, String> {
  final LangRepository langRepository;

  ChangeLocaleUsecase({required this.langRepository});
  @override
  Future<Either<Failure, bool>> call(String langCode) async =>
      await langRepository.changeLang(langCode: langCode);
}
