import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories_impl/user_repository_impl.dart';
import '../../../domain/use_cases/users/get_users_use_case.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsersUseCase getUsersUseCase = GetUsersUseCase(UserRepositoryImpl());

  StreamSubscription? _subscription;
  UsersBloc() : super(UsersInitialState()) {
    on<GetUsersEvent>(_onGetUsers);
    on<UsersUpdatedEvent>(_onUsersUpdated);
    on<UsersErrorEvent>(_onUsersError);
  }

  void _onGetUsers(GetUsersEvent event, Emitter emit) {
    emit(UsersLoadingState());
    _subscription?.cancel();
    _subscription = getUsersUseCase().listen(
      (users) {
        add(UsersUpdatedEvent(users));
      },
      onError: (e) {
        add(UsersErrorEvent());
      },
    );
  }

  void _onUsersUpdated(UsersUpdatedEvent event, Emitter emit) {
    emit(UsersLoadedState(users: event.users));
  }

  void _onUsersError(UsersErrorEvent event, Emitter emit) {
    emit(UsersErrorState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
