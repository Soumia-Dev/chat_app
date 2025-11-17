import 'package:chatting_app/presentation/pages/users/user_search_delegate.dart';
import 'package:chatting_app/presentation/pages/users/users_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories_impl/search_repository_impl.dart';
import '../../../domain/use_cases/search_history/clear_one_use_case.dart';
import '../../../domain/use_cases/search_history/clear_search_history_use_case.dart';
import '../../../domain/use_cases/search_history/get_search_history_use_case.dart';
import '../../../domain/use_cases/search_history/save_search_query_use_case.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/users/users_bloc.dart';
import '../profile/profile.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  SearchRepositoryImpl buildSearchRepository() {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return SearchRepositoryImpl(
      firestore: FirebaseFirestore.instance,
      uId: userId,
    );
  }

  UserSearchDelegate buildUserSearchDelegate(
    BuildContext context,
    List<UserModel> users,
  ) {
    final searchRepository = buildSearchRepository();
    return UserSearchDelegate(
      users: users,
      bloc: context.read<UsersBloc>(),
      getSearchHistory: GetSearchHistoryUseCase(
        searchRepository: searchRepository,
      ),
      saveSearchQuery: SaveSearchQueryUseCase(
        searchRepository: searchRepository,
      ),
      clearSearchHistory: ClearSearchHistoryUseCase(
        searchRepository: searchRepository,
      ),
      clearOne: ClearOneUseCase(searchRepository: searchRepository),
    );
  }

  void navigateToProfile(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(userId: userId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.users),
        actions: [
          BlocBuilder<UsersBloc, UsersState>(
            builder: (context, state) {
              if (state is UsersLoadedState) {
                return UsersWidgets.searchWidget(() {
                  showSearch(
                    context: context,
                    delegate: buildUserSearchDelegate(context, state.users),
                  );
                });
              }
              return Container();
            },
          ),
        ],
      ),
      body: BlocBuilder<UsersBloc, UsersState>(
        builder: (context, state) {
          if (state is UsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoadedState) {
            return UsersWidgets.listUsers(
              context,
              state.users,
              navigateToProfile,
            );
          } else if (state is UsersErrorState) {
            return Center(
              child: Text(AppLocalizations.of(context)!.failedToLoadUsers),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
