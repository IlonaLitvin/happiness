import 'package:dart_helpers/dart_helpers.dart';
import 'package:flutter_helpers/flutter_helpers.dart';

import '../card_aware.dart';

extension CardAwareJsonExtension on CardAware {
  Map<String, dynamic> get json => <String, dynamic>{
        'screen size': screenSize().json,
        'screen orientation': screenOrientation().sd,
      };

  String get sjson => json.toString();
}
