
import 'package:chatting_app/presentation/pages/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/app_localizations.dart';
import '../../bloc/theme_lang/theme_lang_bloc.dart';
import 'authed_widgets.dart';
import 'login.dart';

class ChooseAuth extends StatelessWidget {
  const ChooseAuth({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.read<ThemeLanguageBloc>().state.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Container(
        decoration: AuthedWidgets.backgroundPage(isDark),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    AuthedWidgets.topIcon(isDark),
                    const SizedBox(height: 20),
                    AuthedWidgets.appTitle(isDark, context),
                  ],
                ),
                AuthedWidgets.joinTitle(context),
                Column(
                  children: [
                    AuthedWidgets.submitButton(
                      label: AppLocalizations.of(context)!.login,
                      isDark: true,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LogIn()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    AuthedWidgets.submitButton(
                      label: AppLocalizations.of(context)!.createNewAccount,
                      isDark: false,
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
