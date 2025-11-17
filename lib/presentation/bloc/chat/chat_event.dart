part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class GetChatEvent extends ChatEvent {}

class ChatUpdatedEvent extends ChatEvent {
  final List<ChatPreviewEntity> chats;
  ChatUpdatedEvent(this.chats);
}

class ChatErrorEvent extends ChatEvent {}
