import 'package:flutter/cupertino.dart';

import '../../domain/entities/intro_page_entity.dart';
import '../../l10n/app_localizations.dart';

class IntroConst {
  static List<IntroPageEntity> pages(BuildContext context) {
    return [
      IntroPageEntity(
        title: AppLocalizations.of(context)!.introTitle0,
        subtitle: AppLocalizations.of(context)!.introSubtitle0,
        image: 'assets/intro0.png',
      ),
      IntroPageEntity(
        title: AppLocalizations.of(context)!.introTitle1,
        subtitle: AppLocalizations.of(context)!.introSubtitle1,
        image: 'assets/intro1.png',
      ),
      IntroPageEntity(
        title: AppLocalizations.of(context)!.introTitle2,
        subtitle: AppLocalizations.of(context)!.introSubtitle2,
        image: 'assets/intro2.png',
      ),
    ];
  }

  static List<String> languages() {
    return ['en', 'fr', 'ar'];
  }
}
