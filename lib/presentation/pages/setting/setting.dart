import 'dart:convert';
import 'dart:io';

import 'package:chatting_app/domain/use_cases/authed_use_cases/update_user_photo_use_case.dart';
import 'package:chatting_app/presentation/pages/setting/setting_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/colors_const.dart';
import '../../../data/repositories_impl/authed_repository_impl.dart';
import '../../../domain/use_cases/authed_use_cases/delete_account_use_case.dart';
import '../../../domain/use_cases/authed_use_cases/logout_use_case.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/theme_lang/theme_lang_bloc.dart';
import '../../controllers/auth_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late AuthController authController;

  @override
  void initState() {
    authController = AuthController(
      logoutUseCase: LogoutUseCase(AuthedRepositoryImpl()),
      deleteAccountUseCase: DeleteAccountUseCase(
        AuthedRepositoryImpl(),
        context,
      ),
      updateUserPhotoUseCase: UpdateUserPhotoUseCase(AuthedRepositoryImpl()),
    );
    super.initState();
  }

  Future<void> pickAndUploadImage(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final bytes = await File(picked.path).readAsBytes();
    final base64Image = base64Encode(bytes);
    final message = await authController.updatePhoto(
      context,
      userId,
      base64Image,
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void changeMode(BuildContext context, ThemeMode theme) {
    context.read<ThemeLanguageBloc>().add(ChangeThemeEvent(themeMode: theme));
  }

  void changeValueNotification(BuildContext context, bool value) {
    context.read<ThemeLanguageBloc>().add(
      ChangeNotificationEvent(value: value),
    );
  }

  void changeLang(BuildContext context, String code) {
    context.read<ThemeLanguageBloc>().add(ChangeLanguageEvent(code: code));
    Navigator.of(context).pop();
  }

  void logout(BuildContext context) async {
    SettingWidgets.showLogoutDeleteDialog(
      context,
      AppLocalizations.of(context)!.alert,
      AppLocalizations.of(context)!.leaveApp,
      authController,
      () async {
        final message = await authController.logout(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  void deleteAccount(BuildContext context) async {
    SettingWidgets.showLogoutDeleteDialog(
      context,
      AppLocalizations.of(context)!.alert,
      AppLocalizations.of(context)!.deleteAccountAlert,
      authController,
      () async {
        final message = await authController.deleteAccount(context);
        if (message != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context).brightness == Brightness.light
        ? ThemeMode.light
        : ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.setting),
        backgroundColor: isDark ? Colors.black : ColorsConst.primaryColor,
      ),
      body: Container(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            SettingWidgets.buildProfileSection(
              context,
              isDark,
              pickAndUploadImage,
            ),
            const SizedBox(height: 30),
            SettingWidgets.title(AppLocalizations.of(context)!.general),
            const SizedBox(height: 8),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.dark_mode,
              title: AppLocalizations.of(context)!.darkMode,
              trailing: Switch(
                value: isDark,
                activeThumbColor: ColorsConst.primaryColor,
                onChanged: (v) {
                  changeMode(context, theme);
                },
              ),
            ),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.language,
              title: AppLocalizations.of(context)!.language,
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                SettingWidgets.showLanguageDialog(context, changeLang);
              },
            ),
            const SizedBox(height: 20),
            SettingWidgets.title(AppLocalizations.of(context)!.notifications),
            const SizedBox(height: 8),
            BlocBuilder<ThemeLanguageBloc, ThemeLanguageState>(
              builder: (context, state) {
                return SettingWidgets.buildSettingTile(
                  context,
                  icon: Icons.notifications_active,
                  title: AppLocalizations.of(context)!.pushNotifications,
                  trailing: Switch(
                    value: state.isEnabledNotification,
                    activeThumbColor: ColorsConst.primaryColor,
                    onChanged: (v) {
                      context.read<ThemeLanguageBloc>().add(
                        ChangeNotificationEvent(value: v),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            SettingWidgets.title(AppLocalizations.of(context)!.privacySecurity),
            const SizedBox(height: 8),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.lock_outline,
              title: AppLocalizations.of(context)!.privacySettings,
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.security,
              title: AppLocalizations.of(context)!.twoFactorAuthentication,
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.delete,
              title: AppLocalizations.of(context)!.deleteAccount,
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              iconColor: Colors.red,
              onTap: () => deleteAccount(context),
            ),
            SettingWidgets.buildSettingTile(
              context,
              icon: Icons.logout,
              title: AppLocalizations.of(context)!.logout,
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () => logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
