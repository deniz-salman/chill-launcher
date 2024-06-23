import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:launcher/models/app_model.dart';
import 'package:launcher/views/launcher_view.dart';
import 'package:launcher/views/settings_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late Box<AppModel> appBox;
late Directory documentDirectory;
final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences sharedPreferences;
late PackageInfo packageInfo;
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AppModelAdapter());
  appBox = await Hive.openBox<AppModel>('apps');
  documentDirectory = await getApplicationDocumentsDirectory();
  sharedPreferences = await SharedPreferences.getInstance();
  packageInfo = await PackageInfo.fromPlatform();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsViewModel = ref.watch(settingsViewModelProvider);
    return ScreenUtilInit(
      child: CupertinoApp(
        navigatorKey: navigatorKey,
        theme: settingsViewModel.isDarkMode
            ? const CupertinoThemeData(
                brightness: Brightness.dark,
                primaryColor: CupertinoColors.systemGrey,
              )
            : const CupertinoThemeData(
                brightness: Brightness.light,
                primaryColor: CupertinoColors.systemGrey,
              ),
        title: 'Launcher',
        home: const LauncherView(),
      ),
    );
  }
}
