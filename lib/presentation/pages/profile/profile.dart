import 'package:chatting_app/presentation/pages/profile/profile_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/invitation_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import '../../../data/repositories_impl/user_repository_impl.dart';
import '../../../domain/use_cases/chats/get_messages_use_case.dart';
import '../../../domain/use_cases/users/accept_receive_invitation_use_case.dart';
import '../../../domain/use_cases/users/cancel_friend_use_case.dart';
import '../../../domain/use_cases/users/cancel_sent_receive_request_use_case.dart';
import '../../../domain/use_cases/users/send_f_request_use_case.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/current_user/current_user_bloc.dart';
import '../../bloc/users/users_bloc.dart';
import '../../controllers/users_controller.dart';
import '../chats/messages.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  final UserController userController = UserController(
    sendFRequestUseCase: SendFRequestUseCase(UserRepositoryImpl()),
    cancelFriendUseCase: CancelFriendUseCase(UserRepositoryImpl()),
    cancelSentReceiveRequestUseCase: CancelSentReceiveRequestUseCase(
      UserRepositoryImpl(),
    ),
    acceptReceiveInvitationUseCase: AcceptReceiveInvitationUseCase(
      UserRepositoryImpl(),
    ),
  );
  bool isActionLoading = false;
  void runAction(Future<void> Function() action) async {
    setState(() => isActionLoading = true);
    await action();
    setState(() => isActionLoading = false);
  }

  void navigateToMessages(
    String senderName,
    BuildContext context,
    UserModel friend,
  ) {
    final bloc = context.read<ChatBloc>();
    if (bloc.state is ChatLoadedState) {
      final state = bloc.state as ChatLoadedState;
      final chatPreviewEntity = state.chats.firstWhere(
        (chat) => chat.friendId == friend.id,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesPage(
            senderName: senderName,
            chatPreview: chatPreviewEntity,
            getMessagesUseCase: GetMessagesUseCase(ChatRepositoryImpl()),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bloc = context.read<CurrentUserBloc>();
    String senderName = "";
    if (bloc.state is CurrentUserLoaded) {
      senderName = (bloc.state as CurrentUserLoaded).user.fullName;
    }
    return Scaffold(
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoadedState) {
            final user = state.users.firstWhere(
              (user) => user.id == widget.userId,
            );
            return CustomScrollView(
              slivers: [
                ProfileWidgets.header(user, theme, textTheme, context),
                if (user.state == 'friend')
                  ProfileWidgets.connectTools(
                    theme,
                    senderName,
                    context,
                    user,
                    navigateToMessages,
                  ),
                SliverToBoxAdapter(
                  child: ProfileWidgets.buildActionButton(
                    user: user,
                    isDark: isDark,
                    context: context,
                    isLoading: isActionLoading,
                    reState: runAction,
                    onReceiveAccept: () async {
                      final message = await userController
                          .acceptReceiveInvitation(
                            InvitationModel(
                              fromId: user.id ?? "",
                              toId: currentUser,
                            ),
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                    onCancelSentRequest: () async {
                      final message = await userController
                          .cancelSentReceiveRequest(
                            InvitationModel(
                              fromId: currentUser,
                              toId: user.id ?? "",
                            ),
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                    onCancelReceiveRequest: () async {
                      final message = await userController
                          .cancelSentReceiveRequest(
                            InvitationModel(
                              fromId: user.id ?? "",
                              toId: currentUser,
                            ),
                          );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                    onCancelFriend: () async {
                      final message = await userController.cancelFriend(
                        InvitationModel(
                          fromId: currentUser,
                          toId: user.id ?? "",
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                    onAddFriend: () async {
                      final message = await userController.addFriend(
                        InvitationModel(
                          fromId: currentUser,
                          toId: user.id ?? "",
                        ),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(message)));
                      }
                    },
                  ),
                ),
                ProfileWidgets.userInformation(user, textTheme, theme, context),
              ],
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
