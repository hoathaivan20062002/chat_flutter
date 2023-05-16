import 'dart:ui';
import 'package:get/get.dart';

class Localization extends Translations {
  static final Localization _inst = Localization._internal();
  static Localization get inst => _inst;
  Localization._internal() {
    // set default local
    Get.updateLocale(Get.deviceLocale ?? const Locale('en', 'US'));
  }

  Locale get defaultLocale => Get.locale!;

  @override
  Map<String, Map<String, String>> get keys => {};
}
