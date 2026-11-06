import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/utils/func.dart';
import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/presentation/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../flavors.dart';
import '../../core/gen/assets.gen.dart';
import '../../core/utils/url_launcher_manager.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSplash(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0x00fbe6f0),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            color:
                // Color(0xFBE6F0),
                const Color(0xFFFBE6F0),
            // const Color(0x00fbe6f0),
          ),
          // SvgPicture.asset(
          //   width: 1.sw,
          //   height: 1.sh,
          //   Assets.images.background.bgSplash.path,
          //   fit: BoxFit.cover,
          // ),

          Center(
            child: Image.asset(
              Assets.images.icons.playstore.path,
              width: 180.sp,
              height: 180.sp,
              fit: BoxFit.contain,
            ),
          ),
          // Assets.images.icons.iconLauncherSvg
          //     .svg(width: 250.sp, height: 250.sp)
          //     ),
          // Center(
          //     child: SvgPicture.asset(
          //       Assets.images.icons.iconLauncherSvg.path,
          //   // Constants.logo_icon_splash,
          //   width: 176.sp,
          //   height: 176.sp,
          // )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.images.icons.playstore.path,
                    width: 40.sp,
                    height: 40.sp,
                  ),
                  Text(
                    'CLEAN',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'App Version ',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> loadSplash(BuildContext context) async {
  await Future.delayed(const Duration(seconds: 3)).then((value) async {
    // Constants.isSplashSuccess = true;
    final PackageInfo info = await Func.getAppinfo();
    final isInLength = Func.isVersionCompatible(
      info.version,
      F.minAppVersion,
    );

    if (isInLength) {
      if (F.forceUpdateAppVersion == "Y") {
        showDialog(
          context: context,
          barrierDismissible: false, // ไม่ให้กดข้างนอกเพื่อปิด
          builder: (context) {
            return AlertDialog(
              title: const Text('อัปเดต'),
              content: const Text(
                'แอปพลิเคชันมีเวอร์ชันใหม่ กรุณาอัปเดตแอปพลิเคชัน',
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    if (GetPlatform.isAndroid) {
                      const targetURL = "market://details?id=com.xxx.xxxx";
                      await UrlLauncherManager.redirectUrl(targetURL);
                    } else if (GetPlatform.isIOS) {
                      const targetURL =
                          "itms-apps://itunes.apple.com/app/idxxxxxxx";
                      await UrlLauncherManager.redirectUrl(targetURL);
                    }
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        Get.off(() => const HomePage());
      }
    } else {
      showDialog(
        context: context,
        barrierDismissible: false, // ไม่ให้กดข้างนอกเพื่อปิด
        builder: (context) {
          return AlertDialog(
            title: const Text('อัปเดต'),
            content: const Text(
              'แอปพลิเคชันมีเวอร์ชันใหม่ กรุณาอัปเดตแอปพลิเคชัน',
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  if (GetPlatform.isAndroid) {
                    const targetURL =
                        "market://details?id=com.vaantee.practice";
                    await UrlLauncherManager.redirectUrl(targetURL);
                  } else if (GetPlatform.isIOS) {
                    const targetURL =
                        "itms-apps://itunes.apple.com/app/id00000000";
                    await UrlLauncherManager.redirectUrl(targetURL);
                  }
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        },
      );
    }

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const LoginAdPage()),
    // );
  });
}
