part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

class ChatLoadingState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<ChatPreviewEntity> chats;
  ChatLoadedState(this.chats);
}

class ChatErrorState extends ChatState {
  ChatErrorState();
}
