import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors_const.dart';
import '../../../data/models/chat_preview_entity.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import '../../../domain/use_cases/chats/get_messages_use_case.dart';
import '../../../domain/use_cases/chats/read_messages_use_case.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/current_user/current_user_bloc.dart';
import '../../bloc/users/users_bloc.dart';
import '../profile/profile.dart';
import 'chats_widgets.dart';
import 'messages.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void onNavigateToMessages(
    String senderName,
    BuildContext context,
    ChatPreviewEntity chatEntity,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagesPage(
          senderName: senderName,
          chatPreview: chatEntity,
          getMessagesUseCase: GetMessagesUseCase(ChatRepositoryImpl()),
        ),
      ),
    );
  }

  void navigateToProfile(BuildContext context, String friendId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(userId: friendId)),
    );
  }

  late ReadMessagesUseCase readMessagesUseCase;
  @override
  void initState() {
    readMessagesUseCase = ReadMessagesUseCase(ChatRepositoryImpl());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final bloc = context.read<CurrentUserBloc>();
    String senderName = "";
    if (bloc.state is CurrentUserLoaded) {
      senderName = (bloc.state as CurrentUserLoaded).user.fullName;
    }

    return RefreshIndicator(
      color: ColorsConst.primaryColor,
      onRefresh: () async {
        context.read<ChatBloc>().add(GetChatEvent());
        context.read<UsersBloc>().add(GetUsersEvent());
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: ChatsWidgets.drawer(context, isDark),
        backgroundColor: isDark
            ? ColorsConst.backgroundDark
            : ColorsConst.backgroundLight,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                    ),
                    ChatsWidgets.title(
                      title: AppLocalizations.of(context)!.myFriends,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                BlocBuilder<UsersBloc, UsersState>(
                  builder: (context, state) {
                    if (state is UsersLoadingState) {
                      return ChatsWidgets.loadingFriends();
                    } else if (state is UsersLoadedState) {
                      final friends = state.users
                          .where((u) => u.state == "friend")
                          .toList();
                      if (friends.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.noUsersFound,
                          ),
                        );
                      }
                      return ChatsWidgets.friendsRow(
                        friends,
                        navigateToProfile,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 20),
                ChatsWidgets.title(
                  title: AppLocalizations.of(context)!.chatBox,
                ),
                const SizedBox(height: 10),
                ChatsWidgets.chatsBox(
                  senderName,
                  isDark,
                  height,
                  onNavigateToMessages,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
