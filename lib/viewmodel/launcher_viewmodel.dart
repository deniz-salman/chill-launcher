import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LauncherViewModel extends ChangeNotifier {
  List<ApplicationWithIcon> apps = [];

  LauncherViewModel() {
    init();
  }

  init() async {
    for (Application app in await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    )) {
      if (app is ApplicationWithIcon &&
          app.packageName != (await PackageInfo.fromPlatform()).packageName) {
        apps.add((await DeviceApps.getApp(app.packageName, true))
            as ApplicationWithIcon);
        notifyListeners();
      }
    }
  }
}
