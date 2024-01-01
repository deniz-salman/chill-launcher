import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/view/launcher_view.dart';

void main(List<String> args) {
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
