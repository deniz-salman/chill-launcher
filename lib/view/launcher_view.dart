import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/viewmodel/launcher_viewmodel.dart';

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

    final appList = GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        childAspectRatio: .8,
        crossAxisSpacing: 0,
        children: launcherViewModel.appViews);

    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (onPopInvoked) => launcherViewModel.onPopInvoked(),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: NotificationListener(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                FocusScope.of(context).unfocus();
              }
              return false;
            },
            child: CupertinoPageScaffold(
              backgroundColor: Colors.transparent,
              child: launcherViewModel.apps == null
                  ? const Center(
                      child: CupertinoActivityIndicator(
                      radius: 20,
                    ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        searchTextField,
                        launcherViewModel.appViews.isEmpty
                            ? const Text('No apps found')
                            : Expanded(flex: 20, child: appList),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
