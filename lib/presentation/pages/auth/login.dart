
import 'package:chatting_app/presentation/pages/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../data/repositories_impl/authed_repository_impl.dart';
import '../../../domain/use_cases/authed_use_cases/login_google_use_case.dart';
import '../../../domain/use_cases/authed_use_cases/login_use_case.dart';
import '../../../domain/use_cases/authed_use_cases/reset_password_use_case.dart';
import '../../bloc/theme_lang/theme_lang_bloc.dart';
import '../../controllers/auth_controller.dart';
import 'authed_widgets.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailControl;
  late TextEditingController passwordControl;
  late final AuthController authController;

  @override
  void initState() {
    super.initState();

    emailControl = TextEditingController();
    passwordControl = TextEditingController();
    authController = AuthController(
      loginUseCase: LoginUseCase(
          AuthedRepositoryImpl(firebaseAuth: FirebaseAuth.instance)),
      googleSignInUseCase: LoginGoogleUseCase(AuthedRepositoryImpl(
          firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn())),
      resetPasswordUseCase: ResetPasswordUseCase(
          AuthedRepositoryImpl(firebaseAuth: FirebaseAuth.instance)),
    );
  }

  @override
  void dispose() {
    emailControl.dispose();
    passwordControl.dispose();
    authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        context.read<ThemeLanguageBloc>().state.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Stack(
        children: [
          AuthedWidgets.circleTop(isDark: isDark),
          AuthedWidgets.circleDown(isDark: isDark),
          AuthedWidgets.backdropFilter(),
          SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 100),
                          AuthedWidgets.topTitle(
                            title: AppLocalizations.of(context)!.login,
                          ),
                          const SizedBox(height: 50),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                AuthedWidgets.textFormField(
                                  type: 'email',
                                  typeInLang:
                                      AppLocalizations.of(context)!.email,
                                  controller: emailControl,
                                  icon: Icons.email,
                                  context: context,
                                ),
                                const SizedBox(height: 20),
                                AuthedWidgets.textFormField(
                                  type: 'password',
                                  typeInLang:
                                      AppLocalizations.of(context)!.password,
                                  controller: passwordControl,
                                  icon: Icons.lock,
                                  context: context,
                                ),
                                const SizedBox(height: 10),
                                AuthedWidgets.forgetPass(
                                    email: emailControl,
                                    context: context,
                                    function: () async {
                                      final error =
                                          await authController.resetPassword(
                                              emailControl.text, context);
                                      if (error != null && context.mounted) {
                                        AuthedWidgets.snackBar(
                                          content: AppLocalizations.of(context)!
                                              .resetPassword,
                                          context: context,
                                          duration: 5,
                                        );
                                      }
                                    }),
                                const SizedBox(height: 20),
                                ValueListenableBuilder<bool>(
                                    valueListenable: authController.isLoading,
                                    builder: (context, isLoading, _) {
                                      return isLoading
                                          ? const CircularProgressIndicator()
                                          : Column(
                                              children: [
                                                AuthedWidgets.submitButton(
                                                  label: AppLocalizations.of(
                                                          context)!
                                                      .login,
                                                  isDark: false,
                                                  onTap: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      final error =
                                                          await authController
                                                              .login(
                                                        emailControl.text,
                                                        passwordControl.text,
                                                        context,
                                                      );
                                                      if (error != null &&
                                                          context.mounted) {
                                                        AuthedWidgets.snackBar(
                                                          content: error,
                                                          context: context,
                                                          duration: 5,
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                                const SizedBox(height: 15),
                                                AuthedWidgets.submitButton(
                                                  label: AppLocalizations.of(
                                                          context)!
                                                      .signUpWith,
                                                  isDark: true,
                                                  onTap: () async {
                                                    final error =
                                                        await authController
                                                            .loginWithGoogle(
                                                      emailControl.text,
                                                      context,
                                                    );
                                                    if (error != null &&
                                                        context.mounted) {
                                                      AuthedWidgets.snackBar(
                                                        content: error,
                                                        context: context,
                                                        duration: 5,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                    }),
                                const SizedBox(height: 50),
                                AuthedWidgets.subTitle(
                                  richText: AppLocalizations.of(context)!
                                      .createNewAccount,
                                  subTitle: AppLocalizations.of(context)!
                                      .youHaveNotAnAccount,
                                  isDark: isDark,
                                  function: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()),
                                      (Route<dynamic> route) => false,
                                    );
                                  },
                                  context: context,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ))),
          ),
        ],
      ),
    );
  }
}
