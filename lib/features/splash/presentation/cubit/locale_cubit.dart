import 'package:cleancode/core/usecase/usecase.dart';
import 'package:cleancode/core/utils/app_strings.dart';
import 'package:cleancode/features/splash/domain/usecases/change_lang_usecase.dart';
import 'package:cleancode/features/splash/domain/usecases/get_saved_lang_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final ChangeLocaleUsecase changeLocaleUsecase;
  final GetSavedLangUsecase getSavedLangUsecase;
  LocaleCubit({
    required this.changeLocaleUsecase,
    required this.getSavedLangUsecase,
  }) : super(const ChangeLocalState(Locale(AppStrings.englishCode)));

  String currentLangCode = AppStrings.englishCode;
  Future<void> getSavedLang() async {
    final response = await getSavedLangUsecase.call(NoParams());
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = value;
      emit(ChangeLocalState(Locale(currentLangCode)));
    });
  }

  Future<void> _changeLang(String langCode) async {
    final response = await changeLocaleUsecase.call(langCode);
    response.fold((failure) => debugPrint(AppStrings.cacheFailure), (value) {
      currentLangCode = langCode;
      emit(ChangeLocalState(Locale(currentLangCode)));
    });
  }

  void toEnglish() => _changeLang(AppStrings.englishCode);
  void toArabic() => _changeLang(AppStrings.arabicCode);
}
