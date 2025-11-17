part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

class GetUsersEvent extends UsersEvent {}

class UsersUpdatedEvent extends UsersEvent {
  final List<UserModel> users;
  UsersUpdatedEvent(this.users);
}

class UsersErrorEvent extends UsersEvent {}
