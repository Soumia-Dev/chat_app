import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/global_widgets.dart';
import '../../../l10n/app_localizations.dart';

class UsersWidgets {
  static searchWidget(onSearch) {
    return IconButton(icon: const Icon(Icons.search), onPressed: onSearch);
  }

  static listUsers(
    BuildContext context,
    List users,
    void Function(BuildContext, String) onNavigateToProfile,
  ) {
    if (users.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noUsersFound));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () => onNavigateToProfile(context, user.id ?? ""),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 1),
                  ),
                  child: GlobalWidgets.image(user.photoUrl),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      user.fullName,
                      style: TextStyle(
                        decoration: user.isDeleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.joiningDate),
                        Text(
                          DateFormat('dd MMM, HH:mm').format(user.createdAt),
                        ),
                      ],
                    ),
                    subtitle: user.isDeleted
                        ? Text(
                            AppLocalizations.of(context)!.deleteAccount,
                            style: TextStyle(
                              color: Colors.red,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : user.description != null
                        ? Text(
                            user.description!,
                            maxLines: 2,
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static buildSuggestion(
    List history,
    BuildContext context,
    VoidCallback onClearAllSearch,
    void Function(String) onClearOneSearch,
    void Function(String) onShowResults,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.clearAll),
          trailing: IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: onClearAllSearch,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(item.query),
                leading: const Icon(Icons.history),
                trailing: IconButton(
                  onPressed: () => onClearOneSearch(item.id),
                  icon: const Icon(Icons.clear),
                ),
                onTap: () => onShowResults(item.query),
              );
            },
          ),
        ),
      ],
    );
  }
}
