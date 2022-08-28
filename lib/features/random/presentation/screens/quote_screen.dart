import 'package:cleancode/features/random/presentation/cubit/random_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../config/locale/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../splash/presentation/cubit/locale_cubit.dart';
import '../widgets/quote_content.dart';
import '../../../../core/widget/erorr_widget.dart' as error_widget;

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({Key? key}) : super(key: key);

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  _getRandomQuote() => BlocProvider.of<RandomCubit>(context).getRandomQuote();

  @override
  void initState() {
    super.initState();
    _getRandomQuote();
  }

  Widget _buildBodyContent() {
    return BlocBuilder<RandomCubit, RandomState>(builder: ((context, state) {
      if (state is RandomIsLoading) {
        return Center(
          child: SpinKitFadingCircle(
            color: AppColors.primary,
          ),
        );
      } else if (state is RandomIsError) {
        return error_widget.ErrorWidget(
          onPress: () => _getRandomQuote(),
        );
      } else if (state is RandomLoaded) {
        return Column(
          children: [
            QuoteContent(
              quote: state.quote,
            ),
            InkWell(
                onTap: () => _getRandomQuote(),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(
                    Icons.refresh,
                    size: 28,
                    color: Colors.white,
                  ),
                ))
          ],
        );
      } else {
        return Center(
          child: SpinKitFadingCircle(
            color: AppColors.primary,
          ),
        );
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.translate_outlined,
          color: AppColors.primary,
        ),
        onPressed: () {
          if (AppLocalizations.of(context)!.isEnLocale) {
            BlocProvider.of<LocaleCubit>(context).toArabic();
          } else {
            BlocProvider.of<LocaleCubit>(context).toEnglish();
          }
        },
      ),
      title: Text(AppLocalizations.of(context)!.translate('app_name')!),
    );
    return RefreshIndicator(
        child: Scaffold(appBar: appBar, body: _buildBodyContent()),
        onRefresh: () => _getRandomQuote());
  }
}
