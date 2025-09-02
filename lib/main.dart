import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:viserpay/core/utils/my_color.dart';
import 'package:viserpay/core/utils/util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viserpay/core/helper/shared_preference_helper.dart';
import 'package:viserpay/core/route/route.dart';
import 'package:viserpay/core/utils/messages.dart';
import 'package:viserpay/core/utils/my_strings.dart';
import 'package:viserpay/data/controller/localization/localization_controller.dart';
import 'package:viserpay/firebase_options.dart';
import 'package:viserpay/push_notification_service.dart';
import 'core/di_service/di_services.dart' as di_service;

Future<void> _messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  sharedPreferences.setBool(SharedPreferenceHelper.hasNewNotificationKey, true);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await di_service.init();
  MyUtils.allScreen();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  await PushNotificationService().setupInteractedMessage();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(languages: languages));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
      builder: (localizeController) => GetMaterialApp(
        title: MyStrings.appName,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.noTransition,
        transitionDuration: const Duration(milliseconds: 100),
        initialRoute: RouteHelper.splashScreen,
        navigatorKey: Get.key,
        theme: ThemeData(
          useMaterial3: true,
          indicatorColor: MyColor.primaryColor,
          scaffoldBackgroundColor: MyColor.colorWhite,
          splashColor: MyColor.primaryButtonColor.withOpacity(0.1),
          dialogTheme: const DialogTheme(
            surfaceTintColor: MyColor.transparentColor,
            elevation: 0,
            backgroundColor: MyColor.colorWhite,
          ),
          cardTheme: CardTheme(
            elevation: 0,
            surfaceTintColor: MyColor.transparentColor,
            color: MyColor.getCardBgColor(),
          ),
          snackBarTheme: const SnackBarThemeData(backgroundColor: MyColor.colorWhite),
          colorSchemeSeed: MyColor.primaryColor,
          drawerTheme: const DrawerThemeData(
            backgroundColor: MyColor.colorWhite,
            elevation: 0,
            surfaceTintColor: MyColor.transparentColor,
          ),
        ),
        getPages: RouteHelper().routes,
        locale: localizeController.locale,
        translations: Messages(languages: widget.languages),
        fallbackLocale: Locale(
          localizeController.locale.languageCode,
          localizeController.locale.countryCode,
        ),
      ),
    );
  }
}
