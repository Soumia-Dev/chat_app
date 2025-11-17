import 'package:chatting_app/domain/use_cases/chats/delete_messages_use_case.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/models/chat_preview_entity.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import '../../../domain/use_cases/chats/get_messages_use_case.dart';
import '../../../domain/use_cases/chats/read_messages_use_case.dart';
import '../../../l10n/app_localizations.dart';
import 'chat_controller.dart';
import 'messages_widgets.dart';

class MessagesPage extends StatefulWidget {
  final String senderName;
  final ChatPreviewEntity chatPreview;
  final GetMessagesUseCase getMessagesUseCase;
  const MessagesPage({
    super.key,
    required this.senderName,
    required this.chatPreview,
    required this.getMessagesUseCase,
  });

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final ReadMessagesUseCase readMessagesUseCase = ReadMessagesUseCase(
    ChatRepositoryImpl(),
  );
  final DeleteMessagesUseCase deleteMessagesUseCase = DeleteMessagesUseCase(
    ChatRepositoryImpl(),
  );
  @override
  void initState() {
    super.initState();
    ChatController.setCurrentChat(widget.chatPreview.friendId);
    widget.chatPreview.messages ??= widget.getMessagesUseCase(
      widget.chatPreview.chatRoomId,
    );
  }

  @override
  void dispose() {
    ChatController.setCurrentChat(null);
    super.dispose();
  }

  bool isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  final TextEditingController controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  Set<String> selectedMessageIds = {};

  void onLongPressMessage(String messageId) {
    setState(() {
      selectedMessageIds.add(messageId);
    });
  }

  void onTapMessage(String messageId) {
    if (selectedMessageIds.isNotEmpty) {
      setState(() {
        if (selectedMessageIds.contains(messageId)) {
          selectedMessageIds.remove(messageId);
        } else {
          selectedMessageIds.add(messageId);
        }
      });
    }
  }

  void cancelSelection() {
    setState(() {
      selectedMessageIds.clear();
    });
  }

  Future<void> confirmDeleteSelected() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteMessage),
        content: Text(AppLocalizations.of(context)!.areYouSureDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await deleteMessagesUseCase(
        widget.chatPreview.chatRoomId,
        selectedMessageIds,
      );
      setState(() {
        selectedMessageIds.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: selectedMessageIds.isNotEmpty
          ? AppBar(
              backgroundColor: Colors.grey.shade600,
              title: Text("${selectedMessageIds.length} selected"),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: cancelSelection,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: confirmDeleteSelected,
                ),
              ],
            )
          : MessagesWidgets.appBar(widget.chatPreview, context),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDark
                  ? "assets/background_dark.jpg"
                  : "assets/background_light.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: widget.chatPreview.messages,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.pleaseTryAgain,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.makeItFriendAndSayHi,
                      ),
                    );
                  } else {
                    final messages = snapshot.data!;
                    final lastMessage = messages.first;
                    if (lastMessage.receiverId == currentUser?.uid) {
                      readMessagesUseCase(widget.chatPreview.chatRoomId);
                    }
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final isSender = message.senderId == currentUser?.uid;
                        final isSelected = selectedMessageIds.contains(
                          message.id,
                        );
                        return MessagesWidgets.buildMessageBubble(
                          context,
                          message,
                          isSender,
                          isSelected,
                          onLongPressMessage,
                          onTapMessage,
                        );
                      },
                    );
                    // Display your UI with the data
                  }
                },
              ),
            ),
            widget.chatPreview.isFriend
                ? MessagesWidgets.inputRow(
                    controller,
                    currentUser!.uid,
                    widget.senderName,
                    widget.chatPreview.friendId,
                    widget.chatPreview.friendFcmToken,
                    context,
                  )
                : MessagesWidgets.noFriendBox(),
          ],
        ),
      ),
    );
  }
}
