part of 'locale_cubit.dart';

abstract class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);

  @override
  List<Object> get props => [locale];
}

class ChangeLocalState extends LocaleState {
  const ChangeLocalState(Locale selectedLocale) : super(selectedLocale);
}
