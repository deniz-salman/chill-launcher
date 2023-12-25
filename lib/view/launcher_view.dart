import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/viewmodel/launcher_viewmodel.dart';
import 'package:pull_down_button/pull_down_button.dart';

final launcherViewModelProvider =
    ChangeNotifierProvider((ref) => LauncherViewModel());

class LauncherView extends ConsumerWidget {
  const LauncherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherViewModelProvider);

    return SafeArea(
      child: PopScope(
        canPop: false,
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: .8,
              crossAxisSpacing: 0,
              children: [
                for (ApplicationWithIcon app in launcherViewModel.apps)
                  AppView(app: app)
              ]),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key, required this.app});

  final ApplicationWithIcon app;

  @override
  Widget build(BuildContext context) {
    return PullDownButton(
      itemBuilder: (context) => contextMenuList,
      buttonBuilder: (context, showMenu) => GestureDetector(
        onLongPress: showMenu,
        child: CupertinoButton(
          onPressed: () => app.openApp(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appIcon,
              appName,
            ],
          ),
        ),
      ),
    );
  }

  Widget get appIcon => Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withAlpha(45),
                blurRadius: 35,
                offset: const Offset(1, 1),
              ),
            ],
          ),
          child: Image.memory(app.icon)));

  Widget get appName => Text(
        app.appName,
        style: TextStyle(fontSize: 12.sp, shadows: const [
          Shadow(
            blurRadius: 10.0,
            color: CupertinoColors.black,
            offset: Offset(1.0, 1.0),
          ),
        ]),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );

  List<PullDownMenuEntry> get contextMenuList => [
        PullDownMenuItem(
          title: 'Open Settings',
          onTap: () => app.openSettingsScreen(),
        ),
        if (!(app.systemApp))
          PullDownMenuItem(
            title: 'Uninstall',
            onTap: () => app.uninstallApp(),
          ),
      ];
}
