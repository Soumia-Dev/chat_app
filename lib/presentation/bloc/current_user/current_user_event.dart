part of 'current_user_bloc.dart';

@immutable
sealed class CurrentUserEvent {}

class GetCurrentUserEvent extends CurrentUserEvent {}

class UpdateCurrentUserEvent extends CurrentUserEvent {
  final UserModel currentUser;
  UpdateCurrentUserEvent(this.currentUser);
}

class CurrentUserErrorEvent extends CurrentUserEvent {}

class ChangeCurrentUserEvent extends CurrentUserEvent {
  final String type;
  final String value;
  ChangeCurrentUserEvent({required this.type, required this.value});
}
