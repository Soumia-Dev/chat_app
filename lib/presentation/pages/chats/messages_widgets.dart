import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/global_widgets.dart';
import '../../../data/models/chat_preview_entity.dart';
import '../../../data/models/message_entity.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import '../../../domain/use_cases/chats/send_message_use_case.dart';
import '../../../l10n/app_localizations.dart';

class MessagesWidgets {
  static bool isArabic(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar';
  }

  static SendMessageUseCase sendMessageUseCase = SendMessageUseCase(
    ChatRepositoryImpl(),
  );

  static appBar(ChatPreviewEntity chatPreview, BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: GlobalWidgets.image(chatPreview.friendPhotoUrl),
              ),
              if (chatPreview.isFriend)
                if (chatPreview.isOnline)
                  Positioned(
                    bottom: 0,
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
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chatPreview.friendFullName,
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
                if (!chatPreview.isOnline)
                  Text(
                    "(${AppLocalizations.of(context)!.lastSeen} ${DateFormat('dd MMM, HH:mm').format(chatPreview.lastSeen)})",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.call),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.camera_alt),
        ),
      ],
    );
  }

  static buildMessageBubble(
    BuildContext context,
    MessageEntity message,
    bool isSender,
    bool isSelected,
    Function(String messageId) onLongPressMessage,
    Function(String messageId) onTapMessage,
  ) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => isSender ? onLongPressMessage(message.id!) : null,
        onTap: () => isSender ? onTapMessage(message.id!) : null,
        child: Container(
          margin: EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: isSender ? 80 : 8,
            right: isSender ? 8 : 80,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: isSender
                ? isSelected
                      ? ColorsConst.simpleColor.withOpacity(0.5)
                      : ColorsConst.simpleColor
                : ColorsConst.backgroundLight,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: isSender
                  ? const Radius.circular(15)
                  : const Radius.circular(0),
              bottomRight: isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(15),
            ),
          ),
          child: Column(
            crossAxisAlignment: isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.text,
                style: TextStyle(
                  color: isSender ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('HH:mm').format(message.dateTime).toLowerCase(),
                style: TextStyle(
                  color: isSender ? Colors.white70 : Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static inputRow(
    TextEditingController controller,
    String currentUser,
    String currentName,
    String friendId,
    String friendFcmToken,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      color: ColorsConst.simpleColor.withOpacity(0.1),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.camera_alt), onPressed: () {}),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.writeSomethingHere,
                hintStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 1,
                    color: ColorsConst.simpleColor,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 1,
                    color: ColorsConst.simpleColor,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final message = MessageEntity(
                  senderId: currentUser,
                  receiverId: friendId,
                  friendFcmToken: friendFcmToken,
                  text: controller.text,
                  dateTime: DateTime.now(),
                );
                sendMessageUseCase(message, currentName, currentUser);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  static noFriendBox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade700, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 20, color: Colors.brown),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "You can’t chat with this user until you become friend 🤝",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.brown,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
