import 'package:chatting_app/presentation/pages/users/users_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/use_cases/search_history/clear_one_use_case.dart';
import '../../../domain/use_cases/search_history/clear_search_history_use_case.dart';
import '../../../domain/use_cases/search_history/get_search_history_use_case.dart';
import '../../../domain/use_cases/search_history/save_search_query_use_case.dart';
import '../../../l10n/app_localizations.dart';
import '../../bloc/users/users_bloc.dart';
import '../profile/profile.dart';

class UserSearchDelegate extends SearchDelegate {
  final List<UserModel> users;
  final UsersBloc bloc;
  final SaveSearchQueryUseCase saveSearchQuery;
  final GetSearchHistoryUseCase getSearchHistory;
  final ClearSearchHistoryUseCase clearSearchHistory;
  final ClearOneUseCase clearOne;

  UserSearchDelegate({
    required this.users,
    required this.bloc,
    required this.saveSearchQuery,
    required this.getSearchHistory,
    required this.clearSearchHistory,
    required this.clearOne,
  });
  void navigateToProfile(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: Profile(userId: userId),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox.shrink();
    }
    saveSearchQuery(query);
    final result = users
        .where(
          (user) => user.fullName.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (result.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noUsersFound));
    }
    return UsersWidgets.listUsers(context, result, navigateToProfile);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
      stream: getSearchHistory(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noRecentSearches),
          );
        }
        final history = snapshot.data!;
        return UsersWidgets.buildSuggestion(
          history,
          context,
          () => clearSearchHistory(),
          (item) => clearOne(item),
          (selected) {
            query = selected;
            showResults(context);
          },
        );
      },
    );
  }
}
