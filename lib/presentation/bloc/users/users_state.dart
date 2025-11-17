part of 'users_bloc.dart';

@immutable
sealed class UsersState {}

final class UsersInitialState extends UsersState {}

final class UsersLoadingState extends UsersState {}

final class UsersLoadedState extends UsersState {
  final List<UserModel> users;
  UsersLoadedState({required this.users});
}

final class UsersErrorState extends UsersState {}
