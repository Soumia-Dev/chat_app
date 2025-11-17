import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories_impl/authed_repository_impl.dart';
import '../../../domain/use_cases/authed_use_cases/sign_up_use_case.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/theme_lang/theme_lang_bloc.dart';
import '../../controllers/auth_controller.dart';
import 'authed_widgets.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullNameControl;
  late TextEditingController emailControl;
  late TextEditingController passwordControl;
  late TextEditingController confirmPassControl;
  late AuthController authController;

  @override
  void initState() {
    fullNameControl = TextEditingController();
    emailControl = TextEditingController();
    passwordControl = TextEditingController();
    confirmPassControl = TextEditingController();
    authController = AuthController(
      signUpUseCase: SignUpUseCase(
        AuthedRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    fullNameControl.dispose();
    emailControl.dispose();
    passwordControl.dispose();
    confirmPassControl.dispose();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),
                    AuthedWidgets.topTitle(
                      title: AppLocalizations.of(context)!.createNewAccount,
                    ),
                    const SizedBox(height: 50),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AuthedWidgets.textFormField(
                            type: 'fullName',
                            typeInLang: AppLocalizations.of(context)!.fullName,
                            icon: Icons.person,
                            controller: fullNameControl,
                            context: context,
                          ),
                          const SizedBox(height: 20),
                          AuthedWidgets.textFormField(
                            type: 'email',
                            typeInLang: AppLocalizations.of(context)!.email,
                            icon: Icons.email,
                            controller: emailControl,
                            context: context,
                          ),
                          const SizedBox(height: 20),
                          AuthedWidgets.textFormField(
                            type: 'password',
                            typeInLang: AppLocalizations.of(context)!.password,
                            icon: Icons.lock,
                            controller: passwordControl,
                            context: context,
                          ),
                          const SizedBox(height: 20),
                          AuthedWidgets.textFormField(
                            type: 'confirmPassword',
                            typeInLang: AppLocalizations.of(
                              context,
                            )!.confirmPassword,
                            icon: Icons.lock,
                            controller: confirmPassControl,
                            passwordController: passwordControl,
                            context: context,
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder<bool>(
                            valueListenable: authController.isLoading,
                            builder: (context, isLoading, _) {
                              return isLoading
                                  ? const CircularProgressIndicator()
                                  : AuthedWidgets.submitButton(
                                      label: AppLocalizations.of(
                                        context,
                                      )!.signup,
                                      isDark: false,
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final string = await authController
                                              .signUp(
                                                UserModel(
                                                  fullName:
                                                      fullNameControl.text,
                                                  email: emailControl.text,
                                                ),
                                                passwordControl.text,
                                                context,
                                              );
                                          if (context.mounted) {
                                            AuthedWidgets.snackBar(
                                              content: string,
                                              context: context,
                                              duration: 5,
                                            );
                                          }
                                        }
                                      },
                                    );
                            },
                          ),
                          const SizedBox(height: 50),
                          AuthedWidgets.subTitle(
                            subTitle: AppLocalizations.of(
                              context,
                            )!.youHaveAlreadyAnAccount,
                            richText: AppLocalizations.of(context)!.login,
                            isDark: isDark,
                            context: context,
                            function: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LogIn(),
                                ),
                                (Route<dynamic> route) =>
                                    false, // remove all previous routes
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
