import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/utils/firebase_messaging_service.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/security_page.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/splash_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:freerasp/freerasp.dart';
import 'package:get/get.dart';
import 'package:screen_protector/screen_protector.dart';
import 'flavors.dart';
import 'main.dart';
import 'src/core/constants/app_constants.dart';
import 'src/core/utils/func.dart';
import 'src/core/utils/์navigator_observation.dart';

class App extends StatelessWidget {
  final bool remoteConfigLoaded;
  const App({
    super.key,
    this.remoteConfigLoaded = false,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        RouteObserverService(),
      ],
      title: F.title,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _flavorBanner(
          child: MyHomePage(
            remoteConfigLoaded: remoteConfigLoaded,
          ),
          show: kDebugMode),
    );
  }

  Widget _flavorBanner({required Widget child, bool show = true}) => show
      ? Banner(
          location: BannerLocation.topStart,
          message: F.name,
          color: Colors.green.withAlpha(150),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12.0,
            letterSpacing: 1.0,
          ),
          textDirection: TextDirection.ltr,
          child: child,
        )
      : Container(child: child);
}

class MyHomePage extends ConsumerStatefulWidget {
  final bool remoteConfigLoaded;
  const MyHomePage({
    super.key,
    required this.remoteConfigLoaded,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  initState() {
    FirebaseMessagingService().init();
    //function for do some thing on of firebase messaging
    // android must use local notification for show it not show noti form fcm directly
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(message.notification?.body.toString());

      if (defaultTargetPlatform == TargetPlatform.android) {
        Func.showLocalNotification(message.notification);
      }

      if (message.notification?.body == 'test') {
        print('do something');
      }

      print("onMessage2: ${message.notification?.toMap().toString()}");
    });
    //on open notification status app available
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      actionNotification(message, ref);
    });
    //on open notification status app terminate
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      actionNotification(message, ref);
    });

    enableSecurity();

    if (!widget.remoteConfigLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showLoadErrorDialog(context);
        }
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    disposeSecurity();
    super.dispose();
  }

  actionNotification(RemoteMessage? message, WidgetRef ref) async {
    if (message != null) {
      print(message);
      print(message.data);

      if (Get.currentRoute.toString().contains('/NotificationDetailPage')) {
        // Get.off(
        //   () => NotificationDetailPage(notiId: message.data['notiId'] ?? ''),
        // );
      } else if (Get.currentRoute.toString().contains('/DashboardPage')) {
        // Get.to(
        //   () => NotificationDetailPage(notiId: message.data['notiId'] ?? ''),
        // );
      } else {
        // Get.offAll(() => const DashboardPage(formNotification: true));
      }
    }
  }

  void enableSecurity() async {
    if (F.appFlavor == Flavor.prod) {
      protectON();
      _preventScreenshotOn();
      _checkScreenRecording();

      rsap();
      // goPageProtection();
    }
  }

  void disposeSecurity() async {
    if (F.appFlavor == Flavor.prod) {
      protectOFF();
      // For iOS and Android
      _removeListenerPreventScreenshot();
      _preventScreenshotOff();
    }
  }

  void protectON() async {
    await ScreenProtector.protectDataLeakageWithBlur();
    await ScreenProtector.protectDataLeakageOn();
    await ScreenProtector.preventScreenshotOn();
  }

  void protectOFF() async {
    await ScreenProtector.protectDataLeakageWithBlurOff();
    await ScreenProtector.protectDataLeakageOff();
    await ScreenProtector.preventScreenshotOff();
  }

  void _checkScreenRecording() async {
    final isRecording = await ScreenProtector.isRecording();

    if (isRecording) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //   content: Text('Screen Recording...'),
      // ));
    }
  }

  void _preventScreenshotOn() async {
    await ScreenProtector.preventScreenshotOn();
    await ScreenProtector.protectDataLeakageOn();
    if (GetPlatform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlur();
    }
  }

  void _preventScreenshotOff() async {
    await ScreenProtector.preventScreenshotOff();
    await ScreenProtector.protectDataLeakageOff();

    if (GetPlatform.isIOS) {
      await ScreenProtector.protectDataLeakageWithBlurOff();
    }
  }

  void _addListenerPreventScreenshot() async {
    ScreenProtector.addListener(
      () {
        // Screenshot
        debugPrint('Screenshot:');
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('Screenshot!'),
        // ));
      },
      (isCaptured) {
        // Screen Record
        debugPrint('Screen Record:');
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('Screen Record!'),
        // ));
      },
    );
  }

  void _removeListenerPreventScreenshot() async {
    ScreenProtector.removeListener();
  }

  void rsap() async {
    // bool
    final config = TalsecConfig(
      /// For Android
      // androidConfig: AndroidConfig(
      //   packageName: F.packageName, //if not valid is Appintegrate
      //   signingCertHashes: [F.signingCertHashes], //if not valid is Appintegrate
      //   supportedStores: [F.supportedStores],
      // ),

      /// For iOS
      // iosConfig: IOSConfig(bundleIds: [F.packageName], teamId: F.teamId),
      watcherMail: "",
      isProd: true,
      // kReleaseMode,
    );
    final callbackDebug = ThreatCallback(
      onAppIntegrity: () {
        Fluttertoast.showToast(msg: 'App integrity');
        print("Call back App integrity");
        Constants.listUnsecure.add("integrity");
      },
      onObfuscationIssues: () {
        print("Call back Obfuscation issues");
        Fluttertoast.showToast(msg: 'Obfuscation issues');
        Constants.listUnsecure.add("Obfuscation");
      },
      onDebug: () {
        print("Call back Debugging");
        Fluttertoast.showToast(msg: 'Debugging');
        Constants.listUnsecure.add("Debugging");
      },
      onDeviceBinding: () {
        print("Call back Device binding");
        Fluttertoast.showToast(msg: 'Device binding');
        Constants.listUnsecure.add("Device binding");
      },
      onDeviceID: () {
        print("Call back Device ID");
        Fluttertoast.showToast(msg: 'Device ID');
        Constants.listUnsecure.add("Device ID");
      },
      onHooks: () {
        print("Call back Hooks");
        Fluttertoast.showToast(msg: 'Hooks');
        Constants.listUnsecure.add("Hooks");
      },
      onPasscode: () {
        print("Call back Passcode not set");
        Fluttertoast.showToast(msg: 'Passcode not set');
        Constants.listUnsecure.add("Passcode not set");
      },
      onPrivilegedAccess: () {
        print("Call back Privileged access");
        Fluttertoast.showToast(msg: 'Privileged access');
        Constants.listUnsecure.add("Privileged access");
      },
      onSecureHardwareNotAvailable: () {
        print("Call back Secure hardware not available");
        Fluttertoast.showToast(msg: 'Secure hardware not available');
        Constants.listUnsecure.add("Secure hardware not available");
      },
      onSimulator: () {
        print("Call back Simulator");
        Fluttertoast.showToast(msg: 'Simulator');
        Constants.listUnsecure.add("Simulator");
      },
      onUnofficialStore: () {
        print("Call back Unofficial store");
        Fluttertoast.showToast(msg: 'Unofficial store');
        Constants.listUnsecure.add("Unofficial store");
      },
    );
    final callbackRelease = ThreatCallback(
      onAppIntegrity: () {
        print("Security App integrity");
        Constants.listUnsecure.add("integrity");

        // Fluttertoast.showToast(msg: 'Security App integrity');
        // if (Constants.isSecurityCount == false) {
        //   Constants.isSecurityCount = true;
        //   Constants.listUnsecure.add("integrity");
        //   Get.offAll(() => const SecurityPage(
        //         msg:
        //             'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(AppIntegrity)',
        //       ));
        // }
      },
      onObfuscationIssues: () {
        print("Security Obfuscation issues");
        // Fluttertoast.showToast(msg: 'Security Obfuscation issues');

        Constants.listUnsecure.add("ofuscation");

        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Obfuscation issues)',
          ),
        );
      },
      onDebug: () {
        print("Security Debugging");
        // Fluttertoast.showToast(msg: 'Security Debugging');

        Constants.listUnsecure.add("Security");

        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Debugging)',
          ),
        );
      },
      onDeviceBinding: () {
        print("Security Device binding");

        Constants.listUnsecure.add("Device binding");

        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Device binding)',
          ),
        );
      },
      onDeviceID: () {
        print("Security Device ID");
        // Fluttertoast.showToast(msg: 'Security Device ID');
        Constants.listUnsecure.add("Security Device ID");
        // if (Constants.isSecurityCount == false) {

        //   Constants.isSecurityCount = true;
        //   Get.offAll(() => const SecurityPage(
        //         msg:
        //             'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Device ID)',
        //       ));
        // }
      },
      onHooks: () {
        print("Security Hooks");

        // Fluttertoast.showToast(msg: 'Security Hooks');

        Constants.listUnsecure.add("Security Hooks");

        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Hooks)',
          ),
        );
      },
      onPasscode: () {
        print("Security Passcode not set");
        // Fluttertoast.showToast(msg: 'Security Passcode not set');

        Constants.listUnsecure.add("Passcode not set");
        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Passcode not set)',
          ),
        );
      },
      onPrivilegedAccess: () {
        print("Security Privileged access");
        // Fluttertoast.showToast(msg: 'Security Privileged access');

        Constants.listUnsecure.add("Privileged access");

        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Privileged access)',
          ),
        );
      },
      onSecureHardwareNotAvailable: () {
        print("Security Secure hardware not available");
        // Fluttertoast.showToast(msg: 'Security Secure hardware not available');

        Constants.listUnsecure.add("Security Secure hardware not available");
        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Secure hardware not available)',
          ),
        );
      },
      onSimulator: () {
        print("Security Simulator");
        // Fluttertoast.showToast(msg: 'Security Simulator');

        Constants.listUnsecure.add("Security Simulator");
        Get.offAll(
          () => const SecurityPage(
            msg:
                'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่(Simulator)',
          ),
        );
      },
      onUnofficialStore: () {
        print("Security Unofficial store");
      },
    );

    // Attaching listener
    Talsec.instance.attachListener(kReleaseMode && F.appFlavor == Flavor.prod
        ? callbackRelease
        : callbackDebug);
    await Talsec.instance.start(config);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery(
      data: mediaQuery.copyWith(
        textScaler: mediaQuery.textScaler.clamp(
          minScaleFactor: 1.1,
          maxScaleFactor: 1.1,
        ),
      ),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            navigatorKey: navigatorKey,
            builder: FToastBuilder(),
            useInheritedMediaQuery: false,
            theme: ThemeData(
              fontFamily: 'Line',
            ),
            initialRoute: widget.remoteConfigLoaded ? '/splash' : '/error',
            routes: {
              '/splash': (_) => const SplashPage(),
              '/error': (_) => const SplashPage(),
            },
          );
        },
      ),
    );
  }
}

Future<void> showLoadErrorDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('เกิดข้อผิดพลาด'),
        content: const Text(
          'เกิดข้อผิดพลาดในการโหลดข้อมูล\n'
          'กรุณาออกจากแอปและลองอีกครั้ง',
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยืนยัน'),
            ),
          ),
        ],
      );
    },
  );
}
