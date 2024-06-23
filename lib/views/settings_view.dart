import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/main.dart';
import 'package:launcher/viewmodels/settings_viewmodel.dart';

final settingsViewModelProvider =
    ChangeNotifierProvider((ref) => SettingsViewModel());

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<SettingsView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      navigatorKey.currentState!.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = ref.watch(settingsViewModelProvider);
    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        child: AnimatedContainer(
          color: CupertinoTheme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(.53),
          curve: Curves.fastOutSlowIn,
          duration: const Duration(milliseconds: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'Settings',
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .navLargeTitleTextStyle
                        .copyWith(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            shadows: [
                          BoxShadow(
                            color: CupertinoTheme.of(context)
                                .primaryColor
                                .withOpacity(.4),
                            blurRadius: 10,
                            offset: const Offset(-2, 2),
                          ),
                        ]),
                  ),
                ),
                SettingItem(
                  CupertinoListTile(
                    leading: const Icon(CupertinoIcons.moon),
                    title: const Text('Dark Mode'),
                    trailing: CupertinoSwitch(
                      value: settingsViewModel.isDarkMode,
                      onChanged: settingsViewModel.toggleDarkMode,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class SettingItem extends ConsumerWidget {
  const SettingItem(
    this.listTile, {
    super.key,
  });

  final CupertinoListTile listTile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context)
              .scaffoldBackgroundColor
              .withOpacity(.6),
          border: Border.all(
            color: CupertinoTheme.of(context).primaryColor.withOpacity(.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: CupertinoTheme.of(context).primaryColor.withOpacity(.4),
              blurRadius: 10,
              offset: const Offset(-1, 1),
            ),
          ],
        ),
        child:
            ClipRRect(borderRadius: BorderRadius.circular(10), child: listTile),
      ),
    );
  }
}
