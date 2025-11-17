import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories_impl/authed_repository_impl.dart';
import '../../../domain/use_cases/authed_use_cases/change_user_information_use_case.dart';
import '../../../domain/use_cases/authed_use_cases/get_current_user_use_case.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final GetCurrentUserUserCase getCurrentUserUserCase = GetCurrentUserUserCase(
    AuthedRepositoryImpl(),
  );
  final ChangeUserInformationUseCase changeUserInformationUseCase =
      ChangeUserInformationUseCase(AuthedRepositoryImpl());
  StreamSubscription? subscription;

  CurrentUserBloc() : super(CurrentUserInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<UpdateCurrentUserEvent>(_onUpdateCurrentUser);
    on<CurrentUserErrorEvent>(_onCurrentUserError);
    on<ChangeCurrentUserEvent>(_onChangeCurrentUser);
  }
  void _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<CurrentUserState> emit,
  ) async {
    emit(CurrentUserLoading());

    await subscription?.cancel();
    subscription = getCurrentUserUserCase().listen(
      (user) {
        add(UpdateCurrentUserEvent(user));
      },
      onError: (error) {
        add(CurrentUserErrorEvent());
      },
    );
  }

  void _onUpdateCurrentUser(
    UpdateCurrentUserEvent event,
    Emitter<CurrentUserState> emit,
  ) {
    emit(CurrentUserLoaded(event.currentUser));
  }

  void _onCurrentUserError(
    CurrentUserErrorEvent event,
    Emitter<CurrentUserState> emit,
  ) {
    emit(CurrentUserError());
  }

  Future<void> _onChangeCurrentUser(
    ChangeCurrentUserEvent event,
    Emitter<CurrentUserState> emit,
  ) async {
    try {
      await changeUserInformationUseCase(event.type, event.value);
    } catch (e) {
      emit(CurrentUserError());
    }
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
