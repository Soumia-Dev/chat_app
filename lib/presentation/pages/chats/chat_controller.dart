class ChatController {
  static String? currentChatUserId;

  static void setCurrentChat(String? userId) {
    currentChatUserId = userId;
  }
}
