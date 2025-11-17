import 'dart:ui';

import 'package:chatting_app/l10n/app_localizations.dart';
import 'package:chatting_app/presentation/bloc/chat/chat_bloc.dart';
import 'package:chatting_app/presentation/bloc/current_user/current_user_bloc.dart';
import 'package:chatting_app/presentation/bloc/theme_lang/theme_lang_bloc.dart';
import 'package:chatting_app/presentation/bloc/users/users_bloc.dart';
import 'package:chatting_app/presentation/pages/chats/chat_controller.dart';
import 'package:chatting_app/presentation/pages/introduction/introduction.dart';
import 'package:chatting_app/presentation/pages/pages_state/pages_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';

import 'core/service/notification_service.dart';
import 'data/dataSources/data_source.dart';
import 'domain/use_cases/setting/change_language.dart';
import 'domain/use_cases/setting/get_language.dart';
import 'domain/use_cases/setting/get_notification.dart';
import 'domain/use_cases/setting/set_notification.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('settings');
  final box = Hive.box('settings');
  await NotificationService.init();
  // 🔔 Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    final data = message.data;
    final senderId = data['senderId'] ?? 'unknown';
    final senderName = data['senderName'] ?? 'Unknown';
    final messageBody = notification?.body ?? '';
    final notificationsEnabled = box.get(
      'notifications_enabled',
      defaultValue: true,
    );
    if (!notificationsEnabled) return;
    if (notification != null) {
      if (ChatController.currentChatUserId != senderId) {
        NotificationService.showGroupedMessage(
          senderId: senderId,
          senderName: senderName,
          message: messageBody,
        );
      }
    }
  });

  final localDS = LocalDataSourceImpl();
  final changeLanguageUseCase = ChangeLanguageUseCase(localDS);
  final setNotificationUseCase = SetNotificationUseCase(LocalDataSourceImpl());
  final getLanguageUseCase = GetLanguageUseCase(localDS);
  final getNotificationUseCase = GetNotificationUseCase(LocalDataSourceImpl());

  final savedLocale = await getLanguageUseCase();
  final notificationValue = await getNotificationUseCase();
  runApp(
    MainApp(
      localLanguage: Locale(savedLocale),
      notificationValue: notificationValue,
      changeLanguageUseCase: changeLanguageUseCase,
      setNotificationUseCase: setNotificationUseCase,
    ),
  );
}

class MainApp extends StatefulWidget {
  final Locale localLanguage;
  final bool notificationValue;
  final ChangeLanguageUseCase changeLanguageUseCase;
  final SetNotificationUseCase setNotificationUseCase;

  const MainApp({
    super.key,
    required this.localLanguage,
    required this.notificationValue,
    required this.changeLanguageUseCase,
    required this.setNotificationUseCase,
  });
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    final initMode =
        window.platformDispatcher.platformBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeLanguageBloc>(
          create: (context) => ThemeLanguageBloc(
            changeLanguageUseCase: widget.changeLanguageUseCase,
            setNotificationUseCase: widget.setNotificationUseCase,
            initialMode: initMode,
            initialLanguage: widget.localLanguage,
            initialNotification: widget.notificationValue,
          ),
        ),
        BlocProvider(create: (context) => UsersBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => CurrentUserBloc()),
      ],
      child: BlocBuilder<ThemeLanguageBloc, ThemeLanguageState>(
        builder: (context, state) {
          return MaterialApp(
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: state.themeMode,
            locale: state.language,
            supportedLocales: const [Locale('en'), Locale('fr'), Locale('ar')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                if (user == null || !(user.emailVerified)) {
                  return const Introduction();
                }
                return const PageState();
              },
            ),
          );
        },
      ),
    );
  }
}
