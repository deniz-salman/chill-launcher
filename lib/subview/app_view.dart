import 'package:device_apps/device_apps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/view/launcher_view.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:share_plus/share_plus.dart';

class AppView extends ConsumerWidget {
  const AppView({super.key, required this.app});

  final ApplicationWithIcon app;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherViewModelProvider);
    return PullDownButton(
      itemBuilder: (context) => contextMenuList,
      buttonBuilder: (context, showMenu) => GestureDetector(
        onLongPress: showMenu,
        child: CupertinoButton(
          onPressed: () => launcherViewModel.onTabApp(app),
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
          child: Hero(
              tag: app.packageName,
              flightShuttleBuilder: (flightContext, animation, direction,
                  fromContext, toContext) {
                final hero = fromContext.widget as Hero;
                return hero.child;
              },
              child: Image.memory(app.icon))));

  Widget get appName => Text(
        app.appName,
        style: TextStyle(fontSize: 11.sp, shadows: const [
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
          icon: CupertinoIcons.settings,
          onTap: () => app.openSettingsScreen(),
        ),
        if (!(app.systemApp)) ...[
          PullDownMenuItem(
            title: 'Share',
            icon: CupertinoIcons.share,
            onTap: () =>
                Share.shareXFiles([XFile(app.apkFilePath)], text: app.appName),
          ),
          PullDownMenuItem(
            title: 'Uninstall',
            icon: CupertinoIcons.trash,
            onTap: () => app.uninstallApp(),
          ),
        ]
      ];
}
