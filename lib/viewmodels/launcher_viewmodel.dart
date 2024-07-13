import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:launcher/main.dart';
import 'package:launcher/models/app_model.dart';
import 'package:launcher/services/google_search.dart';
import 'package:launcher/views/settings_view.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class LauncherViewModel extends ChangeNotifier {
  final searchController = TextEditingController();

  final searchFocusNode = FocusNode();

  final iconsDirectory = Directory(p.join(documentDirectory.path, 'icons'));

  List<String> googleSearchSuggestions = [];
  List<Contact> contactsSearchResult = [];

  LauncherViewModel() {
    init();
  }

  onPopInvoked() {
    if (searchController.text.isNotEmpty) {
      searchController.clear();
      searchController.clearComposing();
      notifyListeners();
    }
  }

  File getIconFile(String packageName) => File(p.join(
        iconsDirectory.path,
        packageName,
      ));

  appCaching() async {
    final apps = (await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    ))
        .whereType<ApplicationWithIcon>();

    for (var e in apps) {
      final iconFile = getIconFile(e.packageName);
      if (!iconFile.parent.existsSync()) {
        iconFile.parent.createSync();
      }
      await iconFile.writeAsBytes(e.icon);
    }

    for (var e in iconsDirectory.listSync()) {
      if (!apps.any((element) => element.packageName == p.basename(e.path))) {
        e.deleteSync();
      }
    }

    for (var e in apps) {
      appBox.put(e.packageName, AppModel().toApp(e));
      if (e.packageName == packageInfo.packageName) {
        appBox.put(
            e.packageName, appBox.get(e.packageName)!..appName = "Settings");
      }
    }

    for (var e in appBox.values) {
      if (!apps.any((element) => element.packageName == e.packageName)) {
        appBox.delete(e.packageName);
      }
    }
  }

  onSearchChanged() {
    notifyListeners();
    if (searchController.text.isNotEmpty) {
      GoogleSearch.getSuggestions(searchController.text).then((value) {
        googleSearchSuggestions = value;
        notifyListeners();
      });
      Permission.contacts.isGranted.then((value) {
        if (value) {
          FlutterContacts.getContacts().then(
            (value) {
              contactsSearchResult = value
                  .where(
                      (element) => element.displayName.toLowerCase().contains(
                            searchController.text.toLowerCase(),
                          ))
                  .toList();
              notifyListeners();
            },
          );
        }
      });
    } else {
      googleSearchSuggestions = [];
      notifyListeners();
    }
  }

  onTabGoogleSuggestion(String suggestion) {
    GoogleSearch.openSearch(suggestion);
    googleSearchSuggestions = [];
    searchController.clear();
    searchFocusNode.unfocus();
    notifyListeners();
  }

  onTabContact(Contact contact) async {
    await FlutterContacts.openExternalView(contact.id);
    searchController.clear();
    searchFocusNode.unfocus();
    notifyListeners();
  }

  init() async {
    log('init');

    DeviceApps.listenToAppsChanges().listen((event) {
      log('listenToAppsChanges');
      appCaching();
    });

    appCaching();
    notifyListeners();

    appBox.listenable().addListener(() {
      appBox.flush();
      notifyListeners();
    });
  }

  onTabApp(AppModel app) async {
    if (app.packageName == packageInfo.packageName) {
      navigatorKey.currentState?.push(
        CupertinoPageRoute(builder: (context) => const SettingsView()),
      );
      appBox.put(
        app.packageName,
        app
          ..lastOpened = DateTime.now()
          ..timesOpened += 1,
      );
    } else {
      navigatorKey.currentState?.push(
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: Container(
                color: CupertinoColors.black.withOpacity(.4),
                child:
                    Hero(tag: app.packageName, child: Image.memory(app.icon))),
          );
        }),
      );
      await Future.delayed(const Duration(milliseconds: 300), () async {
        await DeviceApps.openApp(app.packageName);
        appBox.put(
          app.packageName,
          app
            ..lastOpened = DateTime.now()
            ..timesOpened += 1,
        );
      });
      await Future.delayed(const Duration(milliseconds: 300), () {
        navigatorKey.currentState?.pop();
      });
    }
    onPopInvoked();
    searchFocusNode.unfocus();
  }
}
