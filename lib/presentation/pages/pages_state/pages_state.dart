import 'package:chatting_app/presentation/pages/pages_state/pages_state_widgets.dart';
import 'package:chatting_app/presentation/pages/users/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/page_states_const.dart';
import '../../../data/repositories_impl/authed_repository_impl.dart';
import '../../../domain/use_cases/authed_use_cases/get_num_invitations_use_case.dart';
import '../../bloc/chat/chat_bloc.dart';
import '../../bloc/current_user/current_user_bloc.dart';
import '../../bloc/users/users_bloc.dart';
import '../chats/chats.dart';
import '../invitations/invitations.dart';
import '../setting/setting.dart';

class PageState extends StatefulWidget {
  const PageState({super.key});

  @override
  State<PageState> createState() => _PageStateState();
}

class _PageStateState extends State<PageState> {
  GetNumInvitationsUseCase getNumInvitationsUseCase = GetNumInvitationsUseCase(
    AuthedRepositoryImpl(),
  );

  Future<void> saveUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({'fcmToken': fcmToken});
    }
  }

  Future<void> permission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (kDebugMode) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }
  }

  @override
  initState() {
    super.initState();
    saveUserToken();
    permission();
    context.read<UsersBloc>().add(GetUsersEvent());
    context.read<ChatBloc>().add(GetChatEvent());
    context.read<CurrentUserBloc>().add(GetCurrentUserEvent());
  }

  final PageController pageController = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = PageStatesConst.pages(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(pages[0]['icon']),
            label: pages[0]['label'],
          ),
          NavigationDestination(
            icon: Icon(pages[1]['icon']),
            label: pages[1]['label'],
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                SizedBox(width: 35, height: 35, child: Icon(pages[2]['icon'])),
                PagesStateWidgets.inviteNotification(getNumInvitationsUseCase),
              ],
            ),
            label: pages[2]['label'],
          ),
          NavigationDestination(
            icon: Icon(pages[3]['icon']),
            label: pages[3]['label'],
          ),
        ],
        selectedIndex: index,
        backgroundColor: isDark
            ? ColorsConst.backgroundDark
            : ColorsConst.backgroundLight,
        indicatorColor: ColorsConst.simpleColor.withOpacity(0.5),
        onDestinationSelected: (i) {
          pageController.jumpToPage(i);
          setState(() {
            index = i;
          });
        },
      ),
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const ChatsPage(),
          const UsersPage(),
          const InvitationsPage(),
          SettingPage(),
        ],
      ),
    );
  }
}
