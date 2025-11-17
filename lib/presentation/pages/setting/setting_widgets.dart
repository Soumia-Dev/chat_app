import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/global_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/current_user/current_user_bloc.dart';
import '../../controllers/auth_controller.dart';

class SettingWidgets {
  static Widget buildProfileSection(
    BuildContext context,
    bool isDark,
    Function(BuildContext) updateImage,
  ) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        if (state is CurrentUserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CurrentUserLoaded) {
          final user = state.user;
          return Center(
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: AuthController().isLoading,
                  builder: (context, isLoading, child) {
                    return Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorsConst.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: GlobalWidgets.image(user.photoUrl),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 25,
                          child: InkWell(
                            onTap: () => updateImage(context),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ColorsConst.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(Icons.edit, size: 18),
                            ),
                          ),
                        ),
                        if (isLoading)
                          Container(
                            width: 160,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "@${user.fullName}",
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        }
        if (state is CurrentUserError) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.pleaseTryAgain,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  static Widget title(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  static Widget buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color iconColor = ColorsConst.primaryColor,
    Widget? trailing,
    Function()? onTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  static void showLanguageDialog(
    BuildContext context,
    Function(BuildContext, String code) changeLang,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildLang(context, "English", '🇬🇧', 'en', changeLang),
            buildLang(context, "العربية", '🇸🇦', 'ar', changeLang),
            buildLang(context, "Français", '🇫🇷', 'fr', changeLang),
          ],
        ),
      ),
    );
  }

  static Widget buildLang(
    BuildContext context,
    String label,
    String flag,
    String code,
    Function(BuildContext, String) changeLang,
  ) {
    return ListTile(
      title: Text(label),
      trailing: Text(flag, style: const TextStyle(fontSize: 30)),
      onTap: () {
        changeLang(context, code);
      },
    );
  }

  static void showLogoutDeleteDialog(
    BuildContext context,
    String title,
    String content,
    AuthController authController,
    Function() onPressed,
  ) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: ColorsConst.simpleColor),
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: authController.isLoading,
              builder: (context, isLoading, _) {
                return isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => {onPressed()},
                        child: Text(
                          AppLocalizations.of(context)!.ok,
                          style: TextStyle(color: ColorsConst.simpleColor),
                        ),
                      );
              },
            ),
          ],
        );
      },
    );
  }
}
