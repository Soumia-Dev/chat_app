import 'package:flutter/material.dart';

import '../../../core/constants/colors_const.dart';
import '../../../core/constants/global_widgets.dart';
import '../../../data/models/user_model.dart';
import '../../../l10n/app_localizations.dart';

class InvitationWidgets {
  static appBar(BuildContext context) {
    return AppBar(
      bottom: TabBar(
        labelColor: ColorsConst.simpleColor,
        indicatorColor: ColorsConst.simpleColor,
        tabs: [
          Tab(
            icon: const Icon(
              Icons.call_received,
              color: ColorsConst.primaryColor,
            ),
            text: AppLocalizations.of(context)!.received,
          ),
          Tab(
            icon: const Icon(Icons.send, color: ColorsConst.primaryColor),
            text: AppLocalizations.of(context)!.sent,
          ),
        ],
      ),
    );
  }

  static usersList(
    List<UserModel> users,
    void Function(BuildContext, String) onNavigateToProfile,
  ) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: GlobalWidgets.image(user.photoUrl),

          title: Text(user.fullName),
          subtitle: Text(
            user.description,
            maxLines: 2,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          onTap: () => onNavigateToProfile(context, user.id ?? ""),
        );
      },
    );
  }
}
