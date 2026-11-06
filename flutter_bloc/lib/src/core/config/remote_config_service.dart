import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../flavors.dart';

Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: Duration.zero,
    ),
  );

  try {
    await remoteConfig.fetchAndActivate();

    String forceUpdateKey;
    String minVersionKey;
    String apiUrlKey;

    if (F.appFlavor == Flavor.dev || F.appFlavor == Flavor.diffdev) {
      forceUpdateKey = 'DEV_FORCE_UPDATE_APP';
      minVersionKey = 'DEV_MIN_VERSION_APP';
      apiUrlKey = 'DEV_API_URL';
    } else if (F.appFlavor == Flavor.sit || F.appFlavor == Flavor.diffsit) {
      forceUpdateKey = 'SIT_FORCE_UPDATE_APP';
      minVersionKey = 'SIT_MIN_VERSION_APP';
      apiUrlKey = 'SIT_API_URL';
    } else if (F.appFlavor == Flavor.uat || F.appFlavor == Flavor.diffuat) {
      forceUpdateKey = 'UAT_FORCE_UPDATE_APP';
      minVersionKey = 'UAT_MIN_VERSION_APP';
      apiUrlKey = 'UAT_API_URL';
    } else {
      forceUpdateKey = 'PROD_FORCE_UPDATE_APP';
      minVersionKey = 'PROD_MIN_VERSION_APP';
      apiUrlKey = 'PROD_API_URL';
    }

    final forceUpdate = remoteConfig.getString(forceUpdateKey);
    final minVersion = remoteConfig.getString(minVersionKey);
    final apiUrl = remoteConfig.getString(apiUrlKey);

    if (forceUpdate.isNotEmpty) {
      F.forceUpdateAppVersion = forceUpdate;
    }

    if (minVersion.isNotEmpty) {
      F.minAppVersion = minVersion;
    }

    if (apiUrl.isNotEmpty) {
      F.baseUrl = apiUrl;
    }

    print('Remote Config initialized');
    print('forceUpdateAppVersion: ${F.forceUpdateAppVersion}');
    print('minAppVersion: ${F.minAppVersion}');
    print('baseUrl: ${F.baseUrl}');
  } catch (e) {
    print('Remote Config error: $e');
    rethrow;
  }
}
