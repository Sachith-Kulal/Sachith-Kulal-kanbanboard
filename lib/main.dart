import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:get/get.dart';

import 'firebase_options.dart';
import 'infrastructure/dal/daos/session_management.dart';
import 'infrastructure/dal/services/firebase_notification_services.dart';
import 'infrastructure/dal/services/localization_service.dart';
import 'infrastructure/navigation/navigation.dart';
import 'infrastructure/navigation/routes.dart';
import 'infrastructure/theme/app_themes.dart';


void main() async {
  var initialRoute = await Routes.initialRoute;
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseNotificationServices.init();

  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  await SessionManagement.setSession();
  bool isDarkMode = await SessionManagement.isDarkMode();
  String language = await SessionManagement.getLanguage();
  runApp(Main(initialRoute,isDarkMode,language));
}

class Main extends StatelessWidget {
  final String initialRoute;
  final String language;
  final bool isDarkMode;
  const Main(this.initialRoute,this.isDarkMode,this.language, {super.key});

  // Initialize Firebase Analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      initialRoute: initialRoute,
      getPages: Nav.routes,
      navigatorObservers: <NavigatorObserver>[observer],
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light(context),
      darkTheme: AppThemes.dark(context),
      themeMode: isDarkMode ? ThemeMode.dark:ThemeMode.light,
      translations: LocalizationService(),  // Localization service
      locale: LocalizationService().getLocaleFromLanguage(language),  // Default locale
      fallbackLocale: LocalizationService.fallbackLocale,  // Fallback locale
      supportedLocales: LocalizationService.locales,  // Supported locales

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
