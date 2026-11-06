import 'package:flutter_clean_architecture_bloc_cubit_riverpod_template/src/core/env/env.dart';

enum Flavor {
  diffdev,
  dev,
  diffsit,
  sit,
  diffuat,
  uat,
  prod,
}

class F {
  static late final Flavor appFlavor;

  static String get name => appFlavor.name;

  static String get title {
    switch (appFlavor) {
      case Flavor.diffdev:
        return 'Clean Arch (DEV)';
      case Flavor.dev:
        return 'Clean Arch (DEV)';
      case Flavor.diffsit:
        return 'Clean Arch (SIT)';
      case Flavor.sit:
        return 'Clean Arch (SIT)';
      case Flavor.diffuat:
        return 'Clean Arch (UAT)';
      case Flavor.uat:
        return 'Clean Arch (UAT)';
      case Flavor.prod:
        return 'Clean Arch';
    }
  }

  static String? _custombaseUrl;
  static String get baseUrl {
    if (_custombaseUrl != null && _custombaseUrl != "") {
      return _custombaseUrl!;
    }

    switch (appFlavor) {
      case Flavor.diffdev:
        return EnvDev.baseUrl;
      case Flavor.dev:
        return EnvDev.baseUrl;
      case Flavor.sit:
        return EnvSit.baseUrl;
      case Flavor.diffsit:
        return EnvSit.baseUrl;
      case Flavor.diffuat:
        return EnvUat.baseUrl;
      case Flavor.uat:
        return EnvUat.baseUrl;
      case Flavor.prod:
        return EnvProd.baseUrl;
    }
  }

  static set baseUrl(String value) {
    _custombaseUrl = value;
  }

  static String? _customForceUpdateAppVersion;
  static set forceUpdateAppVersion(String value) {
    _customForceUpdateAppVersion = value;
  }

  static String get forceUpdateAppVersion {
    if (_customForceUpdateAppVersion != null &&
        _customForceUpdateAppVersion != "") {
      return _customForceUpdateAppVersion!;
    }
    switch (appFlavor) {
      case Flavor.diffdev:
        return 'N';
      case Flavor.dev:
        return 'N';
      case Flavor.sit:
        return 'N';
      case Flavor.diffsit:
        return 'N';
      case Flavor.diffuat:
        return 'N';
      case Flavor.uat:
        return 'N';
      case Flavor.prod:
        return 'N';
      default:
        return 'N';
    }
  }

  static String? _customMinAppVersion;
  static set minAppVersion(String value) {
    _customMinAppVersion = value;
  }

  static String get minAppVersion {
    if (_customMinAppVersion != null && _customMinAppVersion != "") {
      return _customMinAppVersion!;
    }
    switch (appFlavor) {
      case Flavor.diffdev:
        return '1.0.10';
      case Flavor.dev:
        return '1.0.10';
      case Flavor.sit:
        return '1.0.10';
      case Flavor.diffsit:
        return '1.0.10';
      case Flavor.diffuat:
        return '1.0.10';
      case Flavor.uat:
        return '1.0.10';
      case Flavor.prod:
        return '1.0.10';
      default:
        return '1.0.10';
    }
  }
}
