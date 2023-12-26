import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LauncherViewModel extends ChangeNotifier {
  List<ApplicationWithIcon>? apps;

  LauncherViewModel() {
    init();

    DeviceApps.listenToAppsChanges().listen((event) {
      init();
    });
  }

  init() async {
    final tempApps = <ApplicationWithIcon>[];
    for (Application app in await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    )) {
      if (app is ApplicationWithIcon &&
          app.packageName != (await PackageInfo.fromPlatform()).packageName) {
        tempApps.add((await DeviceApps.getApp(app.packageName, true))
            as ApplicationWithIcon);
        tempApps.sort((a, b) =>
            a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      }
    }
    apps = tempApps;
    notifyListeners();
  }
}
