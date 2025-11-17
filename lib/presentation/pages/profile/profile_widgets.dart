import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/global_widgets.dart';
import '../../../data/models/user_model.dart';
import '../../../l10n/app_localizations.dart';

class ProfileWidgets {
  static bool isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  static header(
    UserModel user,
    ThemeData theme,
    TextTheme textTheme,
    BuildContext context,
  ) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsConst.primaryColor.withOpacity(0.9),
                    ColorsConst.primaryColor.withOpacity(0.6),
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: GlobalWidgets.image(user.photoUrl),
                        ),
                        if (user.state == "friend")
                          if (user.isOnline)
                            Positioned(
                              bottom: 5,
                              left: isArabic(context) ? 30 : null,
                              right: !isArabic(context) ? 30 : null,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: ColorsConst.simpleColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    (user.isDeleted)
                        ? Text(
                            AppLocalizations.of(context)!.deleteAccount,
                            style: TextStyle(color: Colors.red),
                          )
                        : Text(
                            '@${user.fullName}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                    const SizedBox(height: 8),
                    if (user.state == "friend")
                      if (!user.isOnline && !user.isDeleted)
                        Text(
                          "${AppLocalizations.of(context)!.lastSeen}: ${DateFormat('dd MMM, HH:mm').format(user.lastSeen!)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static connectTools(
    ThemeData theme,
    String senderName,
    BuildContext context,
    UserModel user,
    Function(String, BuildContext, UserModel) navigateToMessages,
  ) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildConnectButton(
            icon: Icons.message_rounded,
            label: "Message",
            onTap: () => navigateToMessages(senderName, context, user),
            theme: theme,
          ),
          buildConnectButton(
            icon: Icons.call_rounded,
            label: "Call",
            onTap: () {},
            theme: theme,
          ),
          buildConnectButton(
            icon: Icons.videocam_rounded,
            label: "Video",
            onTap: () {},
            theme: theme,
          ),
        ],
      ),
    );
  }

  static Widget userInformation(
    UserModel user,
    TextTheme textTheme,
    ThemeData theme,
    BuildContext context,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user.description.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.aboutMe,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user.description,
                style: textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (user.state == 'friend')
              buildInfoCard(
                icon: Icons.email_rounded,
                label: AppLocalizations.of(context)!.email,
                value: user.email,
                theme: theme,
              ),
            buildInfoCard(
              icon: Icons.people,
              label: AppLocalizations.of(context)!.friends,
              value: user.friendsCount.toString(),
              theme: theme,
            ),
            buildInfoCard(
              icon: Icons.calendar_today_rounded,
              label: AppLocalizations.of(context)!.joiningDate,
              value: DateFormat('dd MM yyyy').format(user.createdAt!),
              theme: theme,
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  static Widget buildActionButton({
    required UserModel user,
    required bool isDark,
    required BuildContext context,
    required bool isLoading,
    required Function(Future<void> Function()) reState,
    required Future<void> Function() onReceiveAccept,
    required Future<void> Function() onCancelSentRequest,
    required Future<void> Function() onCancelReceiveRequest,
    required Future<void> Function() onCancelFriend,
    required Future<void> Function() onAddFriend,
  }) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: ColorsConst.accentColor),
        ),
      );
    }

    switch (user.state) {
      case "receive":
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileWidgets.buildButton(
              icon: Icons.check,
              label: AppLocalizations.of(context)!.accept,
              isDark: isDark,
              color: Colors.green.shade600,
              onPressed: () {
                reState(() async {
                  await onReceiveAccept(); // this is fine
                });
              },
            ),
            const SizedBox(width: 10),
            ProfileWidgets.buildButton(
              icon: Icons.close,
              label: AppLocalizations.of(context)!.ignore,
              isDark: isDark,
              color: Colors.red.shade400,
              onPressed: () {
                reState(() async {
                  await onCancelReceiveRequest();
                });
              },
            ),
          ],
        );
      case "sent":
        return ProfileWidgets.buildButton(
          icon: Icons.access_time,
          label: AppLocalizations.of(context)!.cancel,
          isDark: isDark,
          onPressed: () {
            reState(() async {
              await onCancelSentRequest();
            });
          },
        );
      case "friend":
        return ProfileWidgets.buildButton(
          icon: Icons.person_remove,
          label: AppLocalizations.of(context)!.cancelFriend,
          isDark: isDark,
          onPressed: () {
            reState(() async {
              await onCancelFriend();
            });
          },
        );
      case "none":
        return ProfileWidgets.buildButton(
          icon: Icons.person_add,
          label: AppLocalizations.of(context)!.addFriend,
          isDark: isDark,
          onPressed: () {
            reState(() async {
              await onAddFriend();
            });
          },
        );
      default:
        null;
        return const SizedBox.shrink();
    }
  }

  static Widget buildButton({
    required IconData icon,
    required String label,
    required bool isDark,
    Color color = ColorsConst.primaryColor,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        SizedBox(height: 30),
        ElevatedButton.icon(
          icon: Icon(icon),
          label: Text(label, style: const TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }

  static Widget buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorsConst.primaryColor.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: ColorsConst.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildConnectButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: ColorsConst.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: ColorsConst.primaryColor),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
