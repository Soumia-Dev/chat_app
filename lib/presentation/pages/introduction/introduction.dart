import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/intro_const.dart';
import '../../../domain/entities/intro_page_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/theme_lang/theme_lang_bloc.dart';
import '../auth/choose_auth.dart';
import 'intro_widgets.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<Introduction> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void setStatePage(int index) {
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<IntroPageEntity> pages = IntroConst.pages(context);
    return BlocBuilder<ThemeLanguageBloc, ThemeLanguageState>(
      builder: (context, state) {
        final isDark = state.themeMode == ThemeMode.dark;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: IntroWidgets.appBar(
            isDark: isDark,
            currentLang: state.language.languageCode,
            onThemeToggle: () {
              context.read<ThemeLanguageBloc>().add(
                ChangeThemeEvent(themeMode: state.themeMode),
              );
            },
            onLanguageChange: (lang) {
              context.read<ThemeLanguageBloc>().add(
                ChangeLanguageEvent(code: lang),
              );
            },
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: IntroWidgets.background(isDark),
            ),
            child: Column(
              children: [
                IntroWidgets.pageContent(
                  controller: _pageController,
                  pages: pages,
                  onPageChange: (i) => setState(() => _currentPage = i),
                  isDark: isDark,
                ),
                IntroWidgets.smoothPageIndicator(
                  controller: _pageController,
                  length: pages.length,
                  isDark: isDark,
                ),
                const SizedBox(height: 40),
                IntroWidgets.button(
                  isLastPage: _currentPage == pages.length - 1,
                  label: _currentPage == pages.length - 1
                      ? AppLocalizations.of(context)!.getStarted
                      : AppLocalizations.of(context)!.next,
                  isDark: isDark,
                  onPressed: () {
                    if (_currentPage == pages.length - 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChooseAuth()),
                      );
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
