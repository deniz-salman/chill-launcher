import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:launcher/model/app_model.dart';
import 'package:launcher/view/launcher_view.dart';
import 'package:path_provider/path_provider.dart';

late Box<AppModel> appBox;
late Directory documentDirectory;

Future<void> main(List<String> args) async {
  await Hive.initFlutter();
  Hive.registerAdapter(AppModelAdapter());
  appBox = await Hive.openBox<AppModel>('apps');

  documentDirectory = await getApplicationDocumentsDirectory();
  runApp(const App());
}

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
        child: CupertinoApp(
          navigatorKey: navigatorKey,
          theme: const CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: CupertinoColors.white,
            scaffoldBackgroundColor: CupertinoColors.black,
          ),
          title: 'Launcher',
          home: const LauncherView(),
        ),
      ),
    );
  }
}
