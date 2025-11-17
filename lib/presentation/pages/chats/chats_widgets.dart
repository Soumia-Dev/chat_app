import 'package:chatting_app/core/constants/global_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constants/colors_const.dart';
import '../../../data/models/chat_preview_entity.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/current_user/current_user_bloc.dart';

class ChatsWidgets {
  static bool isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  static title({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [ColorsConst.secondaryColor, ColorsConst.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
      ),
    );
  }

  static friendsRow(
    List friends,
    Function(BuildContext, String) navigateToProfile,
  ) {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () => navigateToProfile(context, friend.id ?? ''),
                      child: GlobalWidgets.image(friend.photoUrl),
                    ),
                    if (friend.isOnline)
                      Positioned(
                        bottom: 1,
                        left: isArabic(context) ? 0 : null,
                        right: !isArabic(context) ? 0 : null,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: ColorsConst.simpleColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  friend.fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static chatsBox(
    String senderName,
    bool isDark,
    double height,
    Function(String, BuildContext, ChatPreviewEntity) onNavigateToMessages,
  ) {
    bool isArabic(BuildContext context) {
      final locale = Localizations.localeOf(context);
      return locale.languageCode == 'ar';
    }

    return Container(
      height: height / 1.7,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoadingState) {
            return loadingChatList();
          } else if (state is ChatLoadedState) {
            if (state.chats.isEmpty) {
              return Center(child: Text(AppLocalizations.of(context)!.noChats));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          onNavigateToMessages(senderName, context, chat),
                      child: ListTile(
                        leading: Stack(
                          children: [
                            GlobalWidgets.image(chat.friendPhotoUrl),
                            if (chat.isFriend)
                              if (chat.isOnline)
                                Positioned(
                                  bottom: 1,
                                  left: isArabic(context) ? 0 : null,
                                  right: !isArabic(context) ? 0 : null,
                                  child: Container(
                                    width: 15,
                                    height: 15,
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
                        title: Row(
                          children: [
                            Text(
                              chat.friendFullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 3),
                            if (!chat.isOnline)
                              Expanded(
                                child: Text(
                                  "(${AppLocalizations.of(context)!.lastSeen} ${DateFormat('dd MMM, HH:mm').format(chat.lastSeen)})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                    fontSize: 11,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Text(
                          chat.lastMessage,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (chat.noReadFrom != 0)
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Text(
                                  chat.noReadFrom.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 5),
                            if (chat.lastMessage.isNotEmpty)
                              Text(
                                TimeOfDay.fromDateTime(
                                  chat.lastMessageTime,
                                ).format(context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(thickness: 0),
                  ],
                );
              },
            );
          } else if (state is ChatErrorState) {
            return Center(
              child: Text(AppLocalizations.of(context)!.pleaseTryAgain),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  static loadingFriends() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 60,
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 60,
                  height: 10,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget loadingChatList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              leading: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              title: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 15,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 10,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Unread badge shimmer
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(thickness: 0),
          ],
        );
      },
    );
  }

  static drawer(BuildContext context, bool isDark) {
    ListTile drawerItem(
      IconData icon,
      String title, {
      bool isChange = false,
      Function(String, String)? onTap,
      String? type,
      BuildContext? context,
    }) {
      return ListTile(
        leading: Icon(icon, color: ColorsConst.primaryColor),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: isChange ? penEdit(context!, title, type!) : null,
      );
    }

    return Drawer(
      child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrentUserLoaded) {
            final currentUser = state.user;
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        ColorsConst.primaryColor,
                        ColorsConst.accentColor.withOpacity(0.3),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      GlobalWidgets.image(currentUser.photoUrl),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.fullName,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              currentUser.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                drawerItem(
                  Icons.person,
                  currentUser.fullName,
                  context: context,
                  isChange: true,
                  type: "fullName",
                ),
                drawerItem(Icons.email_outlined, currentUser.email),
                drawerItem(
                  Icons.description,
                  currentUser.description ?? "",
                  context: context,
                  isChange: true,
                  type: "description",
                ),
                drawerItem(
                  Icons.people_outline,
                  "${AppLocalizations.of(context)!.myFriends}: ${currentUser.friendsCount.toString()}",
                ),
                drawerItem(
                  Icons.calendar_month,
                  "${AppLocalizations.of(context)!.joiningDate}: ${DateFormat('dd MM yyyy').format(currentUser.createdAt!)}",
                ),
                drawerItem(
                  Icons.help_outline,
                  AppLocalizations.of(context)!.helpSupport,
                ),
                drawerItem(
                  Icons.info_outline,
                  AppLocalizations.of(context)!.aboutApp,
                ),
              ],
            );
          } else if (state is CurrentUserError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.pleaseTryAgain),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  static penEdit(BuildContext context, String title, String type) {
    return IconButton(
      icon: const Icon(Icons.create),
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController(text: title);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(AppLocalizations.of(context)!.editValue),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterNewValue,
                  labelStyle: TextStyle(color: ColorsConst.simpleColor),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                      color: ColorsConst.simpleColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 1,
                      color: ColorsConst.simpleColor,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppLocalizations.of(context)!.cancel,
                    style: TextStyle(color: ColorsConst.simpleColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      context.read<CurrentUserBloc>().add(
                        ChangeCurrentUserEvent(
                          type: type,
                          value: controller.text,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(color: ColorsConst.simpleColor),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
