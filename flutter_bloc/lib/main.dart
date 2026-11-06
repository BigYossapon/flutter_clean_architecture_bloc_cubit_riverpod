import 'dart:async';
import 'dart:ui' as ui;

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/injector.dart';

import 'package:intl/date_symbol_data_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'
    show
        defaultTargetPlatform,
        kIsWeb,
        TargetPlatform,
        PlatformDispatcher,
        kDebugMode;
import 'app.dart';
import 'firebase_options/firebase_options_dev.dart'
    as DefaultFirebaseOptions_dev;
import 'firebase_options/firebase_options_prod.dart'
    as DefaultFirebaseOptions_prod;

import 'firebase_options/firebase_options_sit.dart'
    as DefaultFirebaseOptions_sit;
import 'firebase_options/firebase_options_uat.dart'
    as DefaultFirebaseOptions_uat;
import 'flavors.dart';
import 'src/core/config/remote_config_service.dart';
import 'src/presentation/bloc_cubit/app_bloc_observer.dart';
import 'src/presentation/bloc_cubit/users/export_users_bloc_cubit.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );
  Bloc.observer = AppBlocObserver();

  print(F.appFlavor);
  // setup shared preferences storage
  sharedPreferences = await SharedPreferences.getInstance();

  // จัดการ firebase ให้ตรงกับ flavor ของแอป
  await initializeDefault(F.appFlavor);

  // #ดักจับ error และส่ง log ไปยัง Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    );
    return true;
  };

  bool remoteConfigLoaded = true;

  try {
    await initializeRemoteConfig();
  } catch (e) {
    remoteConfigLoaded = false;
  }

  // ลงทะเบียน Dependency หลังจากได้ Base URL แล้ว
  await initializeDependencies();
  // await initializeDateFormatting('en');
  // setup easy localization
  await EasyLocalization.ensureInitialized();
  Locale deviceLocale = Locale(ui.window.locale.languageCode);
  print(deviceLocale);
  List<Locale> flutterLocalizeSupportLanguagesLocale = const [
    Locale('en'),
    Locale('th'),
  ];
  // systemchrome setup แนวตั้งหรือแนวนอนของแอป
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).whenComplete(() {
    runApp(EasyLocalization(
      supportedLocales: flutterLocalizeSupportLanguagesLocale,
      path: 'assets/localization.csv',
      assetLoader: CsvAssetLoader(),
      fallbackLocale: const Locale('th'),
      startLocale: flutterLocalizeSupportLanguagesLocale.contains(deviceLocale)
          // ? deviceLocale
          ? const Locale("th")
          : const Locale("en"),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<GetUsersCubit>()),
        ],
        child: DevicePreview(
          enabled: kDebugMode, // แสดงเมื่อเป็นการ debug mode เท่านั้น
          builder: (context) =>
              App(remoteConfigLoaded: remoteConfigLoaded), // Wrap your app
        ),
      ),
    ));
  });
}

Future<void> initializeDefault(Flavor flavor) async {
  FirebaseOptions? firebaseOption;
  if (flavor == Flavor.diffdev) {
    firebaseOption =
        DefaultFirebaseOptions_dev.DefaultFirebaseOptions.currentPlatform;
  } else if (flavor == Flavor.dev) {
    firebaseOption =
        DefaultFirebaseOptions_prod.DefaultFirebaseOptions.currentPlatform;
  } else if (flavor == Flavor.diffsit) {
    firebaseOption =
        DefaultFirebaseOptions_sit.DefaultFirebaseOptions.currentPlatform;
  } else if (flavor == Flavor.sit) {
    firebaseOption =
        DefaultFirebaseOptions_prod.DefaultFirebaseOptions.currentPlatform;
  } else if (flavor == Flavor.diffuat) {
    firebaseOption =
        DefaultFirebaseOptions_uat.DefaultFirebaseOptions.currentPlatform;
  } else if (flavor == Flavor.uat) {
    firebaseOption =
        DefaultFirebaseOptions_prod.DefaultFirebaseOptions.currentPlatform;
  } else {
    firebaseOption =
        DefaultFirebaseOptions_prod.DefaultFirebaseOptions.currentPlatform;
  }
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    FirebaseApp app = await Firebase.initializeApp(
      options: firebaseOption,
      name: "clean",
    );
    print('Initialized default app $app');
  } else {
    FirebaseApp app = await Firebase.initializeApp(
      options: firebaseOption,
    );
    print('Initialized default app $app');
  }
}
