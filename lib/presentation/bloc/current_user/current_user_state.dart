part of 'current_user_bloc.dart';

@immutable
sealed class CurrentUserState {}

final class CurrentUserInitial extends CurrentUserState {}

class CurrentUserLoading extends CurrentUserState {}

class CurrentUserLoaded extends CurrentUserState {
  final UserModel user;
  CurrentUserLoaded(this.user);
}

class CurrentUserError extends CurrentUserState {}
