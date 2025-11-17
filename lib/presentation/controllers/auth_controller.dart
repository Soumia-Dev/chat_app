import 'package:chatting_app/domain/use_cases/authed_use_cases/update_user_photo_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../domain/use_cases/authed_use_cases/delete_account_use_case.dart';
import '../../domain/use_cases/authed_use_cases/login_google_use_case.dart';
import '../../domain/use_cases/authed_use_cases/login_use_case.dart';
import '../../domain/use_cases/authed_use_cases/logout_use_case.dart';
import '../../domain/use_cases/authed_use_cases/reset_password_use_case.dart';
import '../../domain/use_cases/authed_use_cases/sign_up_use_case.dart';
import '../../l10n/app_localizations.dart';
import '../pages/auth/login.dart';
import '../pages/introduction/introduction.dart';
import '../pages/pages_state/pages_state.dart';

class AuthController {
  final LoginUseCase? loginUseCase;
  final ResetPasswordUseCase? resetPasswordUseCase;
  final LoginGoogleUseCase? googleSignInUseCase;
  final SignUpUseCase? signUpUseCase;
  final UpdateUserPhotoUseCase? updateUserPhotoUseCase;
  final LogoutUseCase? logoutUseCase;
  final DeleteAccountUseCase? deleteAccountUseCase;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  AuthController({
    this.loginUseCase,
    this.resetPasswordUseCase,
    this.googleSignInUseCase,
    this.signUpUseCase,
    this.updateUserPhotoUseCase,
    this.logoutUseCase,
    this.deleteAccountUseCase,
  });

  void dispose() {
    isLoading.dispose();
  }

  Future<String?> login(String email, String password, context) async {
    isLoading.value = true;
    try {
      await loginUseCase!(email, password);
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PageState()),
        );
        return null;
      } else {
        return AppLocalizations.of(context)!.pleaseConfirmEmail;
      }
    } catch (e) {
      print('-------${e}');
      return AppLocalizations.of(context)!.pleaseCheckInformation;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> resetPassword(String email, context) async {
    try {
      if (email.isNotEmpty) {
        await resetPasswordUseCase!(email);
        return AppLocalizations.of(context)!.resetPassword;
      }
      return null;
    } catch (e) {
      return AppLocalizations.of(context)!.resetPasswordFalse;
    }
  }

  Future<String?> loginWithGoogle(String email, context) async {
    try {
      final googleSignIn = await googleSignInUseCase!(email);
      if (googleSignIn != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PageState()),
        );
      }

      return null;
    } catch (e) {
      return AppLocalizations.of(context)!.pleaseTryAgain;
    }
  }

  Future<String> signUp(UserModel userModel, String password, context) async {
    try {
      isLoading.value = true;
      await signUpUseCase!(userModel, password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LogIn()),
        (Route<dynamic> route) => false,
      );
      return AppLocalizations.of(context)!.pleaseConfirmEmail;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return AppLocalizations.of(context)!.emailExists;
      }
      return AppLocalizations.of(context)!.pleaseTryAgain;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> logout(context) async {
    try {
      isLoading.value = true;
      logoutUseCase!();
      isLoading.value = false;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Introduction()),
        (Route<dynamic> route) => false,
      );
      return AppLocalizations.of(context)!.successfullyLoggedOut;
    } catch (e) {
      isLoading.value = false;
      return AppLocalizations.of(context)!.pleaseTryAgain;
    }
  }

  Future<String?> deleteAccount(context) async {
    final String? message = await deleteAccountUseCase!();
    return message;
  }

  Future<String> updatePhoto(context, String userId, String base64Image) async {
    try {
      isLoading.value = true;
      await updateUserPhotoUseCase!(userId, base64Image);
      return AppLocalizations.of(context)!.successfullyUpdatePhoto;
    } catch (e) {
      return AppLocalizations.of(context)!.pleaseTryAgain;
    } finally {
      isLoading.value = false;
    }
  }
}
