import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/main.dart';
import 'package:launcher/subviews/app_view.dart';
import 'package:launcher/viewmodels/launcher_viewmodel.dart';

final launcherViewModelProvider =
    ChangeNotifierProvider((ref) => LauncherViewModel());

class LauncherView extends ConsumerWidget {
  const LauncherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherViewModelProvider);

    final searchTextField = Padding(
      padding: const EdgeInsets.only(right: 18, left: 18, top: 20),
      child: CupertinoSearchTextField(
        focusNode: launcherViewModel.searchFocusNode,
        borderRadius: BorderRadius.circular(10),
        controller: launcherViewModel.searchController,
        onChanged: (value) => launcherViewModel.onSearchChanged(),
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: 17.sp,
        ),
        placeholder: 'Search',
      ),
    );

    Widget getAppList() {
      final applist = appBox.values.map((e) => AppView(app: e)).where(
        (element) {
          final app = element.app;
          final searchQuery = launcherViewModel.searchController.text;
          return app.appName.toLowerCase().contains(searchQuery.toLowerCase());
        },
      ).toList(growable: false);
      applist.sort((a, b) {
        final appA = a.app;
        final appB = b.app;
        if (appA.lastOpened == null && appB.lastOpened == null) {
          return appB.appName.compareTo(appA.appName);
        }
        return (appB.lastOpened ?? DateTime.fromMicrosecondsSinceEpoch(0))
            .compareTo(
                appA.lastOpened ?? DateTime.fromMicrosecondsSinceEpoch(0));
      });

      final appGridList = GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: .8,
        crossAxisSpacing: 0,
        physics: const NeverScrollableScrollPhysics(),
        children: applist,
      );

      return applist.isEmpty
          ? Column(
              children: [
                240.verticalSpace,
                launcherViewModel.searchController.text.isNotEmpty
                    ? Text(
                        'No apps found',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 17.sp,
                        ),
                      )
                    : const CupertinoActivityIndicator(
                        radius: 15,
                      ),
              ],
            )
          : appGridList;
    }

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (onPopInvoked) => launcherViewModel.onPopInvoked(),
        child: CupertinoPageScaffold(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              searchTextField,
              appBox.isEmpty
                  ? const Expanded(
                      child: Center(
                          child: CupertinoActivityIndicator(
                      radius: 15,
                    )))
                  : Expanded(
                      flex: 20,
                      child: SingleChildScrollView(
                        child: getAppList(),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
