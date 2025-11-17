import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PageStatesConst {
  static List<Map<String, dynamic>> pages(BuildContext context) => [
    {"label": AppLocalizations.of(context)!.chats, "icon": Icons.message},
    {
      "label": AppLocalizations.of(context)!.users,
      "icon": Icons.supervised_user_circle_sharp,
    },
    {
      "label": AppLocalizations.of(context)!.invitations,
      "icon": Icons.recent_actors_rounded,
    },
    {"label": AppLocalizations.of(context)!.setting, "icon": Icons.settings},
  ];
}
