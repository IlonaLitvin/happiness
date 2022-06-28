import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'config.dart';
import 'service_locator.dart';

class ActiveLocalization {
  final BuildContext context;

  ActiveLocalization(this.context);

  AppLocalizations get defaultAppLocalizations =>
      lookupAppLocalizations(C.defaultLocale);

  AppLocalizations get localization =>
      AppLocalizations.of(context) ?? defaultAppLocalizations;

  Locale get currentLocale => Localizations.localeOf(context);
}

mixin Localization on Object {
  AppLocalizations get localization =>
      sl.get<ActiveLocalization>().localization;
}
