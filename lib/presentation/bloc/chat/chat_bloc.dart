import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/chat_preview_entity.dart';
import '../../../data/repositories_impl/chat_repository_impl.dart';
import '../../../domain/use_cases/chats/get_all_chats_use_case.dart';
import '../../../domain/use_cases/chats/get_messages_use_case.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetAllChatsUseCase getMessagesUseCase = GetAllChatsUseCase(
    ChatRepositoryImpl(),
  );
  final GetMessagesUseCase getMessages = GetMessagesUseCase(
    ChatRepositoryImpl(),
  );

  StreamSubscription? _messagesSubscription;

  ChatBloc() : super(ChatInitial()) {
    on<GetChatEvent>(_onGetChat);
    on<ChatUpdatedEvent>(_onChatUpdated);
    on<ChatErrorEvent>(_onChatError);
  }

  void _onGetChat(GetChatEvent event, Emitter emit) {
    emit(ChatLoadingState());
    _messagesSubscription?.cancel();
    _messagesSubscription = getMessagesUseCase().listen(
      (users) {
        add(ChatUpdatedEvent(users));
      },
      onError: (e) {
        add(ChatErrorEvent());
      },
    );
  }

  void _onChatUpdated(ChatUpdatedEvent event, Emitter emit) {
    emit(ChatLoadedState(event.chats));
  }

  void _onChatError(ChatErrorEvent event, Emitter emit) {
    emit(ChatErrorState());
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
