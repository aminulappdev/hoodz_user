import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import '../core/binder/binder.dart';
import '../core/utils/share_preference.dart';
import 'routes/app_routes.dart';
import 'theme/my_theme.dart';
import 'translator/localization_service.dart';

class HoodzApp extends StatelessWidget {
  const HoodzApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: GetMaterialApp(
        title: 'Hoodz',
        debugShowCheckedModeBanner: false,
        initialBinding: ControllerBinder(),
        theme: MyTheme.getThemeData(isLight: true),
        darkTheme: MyTheme.getThemeData(isLight: false),
        themeMode: MySharedPref.isLightTheme()
            ? ThemeMode.light
            : ThemeMode.dark,
        initialRoute: initialRoute,
        routes: getAppRoutes(),
        locale: MySharedPref.getLocale(),
        fallbackLocale: LocalizationService.defaultLanguage,
        translations: LocalizationService.getInstance(),
      ),
    );
  }
}
