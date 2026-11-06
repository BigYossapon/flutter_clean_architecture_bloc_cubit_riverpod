import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityPage extends StatelessWidget {
  final String msg;
  const SecurityPage(
      {super.key,
      this.msg =
          'ขออภัย ไม่สามาถดำเนินการต่อได้เนื่องจากตรวจพบความผิดปกติบางอย่าง กรุณาตรวจสอบและลองใหม่'});

  @override
  Widget build(BuildContext context) {
    // Constants.currentPage = CurrentPage.notsecure;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text('Security Alert'),
              Text(msg),
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    getOutOfApp();
                  },
                  child: Text('exit app'))
            ],
          ),
        ),
      ),
    );
  }
}

void getOutOfApp() {
  if (Platform.isIOS) {
    try {
      exit(0);
    } catch (e) {
      try {
        SystemNavigator.pop();
      } catch (e) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
      // for IOS, not true this, you can make comment this :)
    }
  } else {
    try {
      SystemNavigator.pop(); // sometimes it cant exit app
    } catch (e) {
      try {
        exit(0); // so i am giving crash to app ... sad :(
      } catch (e) {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }
  }
}
