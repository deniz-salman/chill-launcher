import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:launcher/main.dart';
import 'package:launcher/subview/app_view.dart';
import 'package:launcher/view/launcher_view.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LauncherViewModel extends ChangeNotifier {
  List<ApplicationWithIcon>? apps;

  List<Widget> appViews = [];

  final searchController = TextEditingController();

  final searchFocusNode = FocusNode();

  LauncherViewModel() {
    init();

    DeviceApps.listenToAppsChanges().listen((event) {
      init();
    });

    searchFocusNode.addListener(() {
      searchFocusNode.onKey = (node, event) {
        if (event.logicalKey.keyId == 4294971397) {
          FocusManager.instance.primaryFocus?.unfocus();
          searchController.clear();
          onSearchChanged();
        }
        return KeyEventResult.handled;
      };
    });
  }

  onPopInvoked() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
      onSearchChanged();
    }
  }

  onSearchChanged() {
    appViews = apps!
        .where((element) => element.appName
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .map((e) => AppView(app: e))
        .toList();
    notifyListeners();
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
    if (apps != tempApps) {
      apps = tempApps;
      appViews = apps!.map((e) => AppView(app: e)).toList();
      notifyListeners();
    }
  }

  onTabApp(ApplicationWithIcon app) async {
    navigatorKey.currentState?.push(
      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: Container(
              color: CupertinoColors.black.withOpacity(.4),
              child: Hero(tag: app.packageName, child: Image.memory(app.icon))),
        );
      }),
    );
    await Future.delayed(const Duration(milliseconds: 300), () async {
      await app.openApp();
    });
    await Future.delayed(const Duration(milliseconds: 300), () {
      navigatorKey.currentState?.pop();
    });
    onPopInvoked();
    searchFocusNode.unfocus();
  }
}
