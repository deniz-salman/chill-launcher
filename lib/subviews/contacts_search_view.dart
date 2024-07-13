import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launcher/views/launcher_view.dart';

class ContactsSearchView extends ConsumerWidget {
  const ContactsSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (launcherViewModel.searchController.text.isNotEmpty)
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            childAspectRatio: .8,
            crossAxisSpacing: 0,
            physics: const NeverScrollableScrollPhysics(),
            children: launcherViewModel.contactsSearchResult
                .getRange(
                    0,
                    launcherViewModel.contactsSearchResult.length > 8
                        ? 8
                        : launcherViewModel.contactsSearchResult.length)
                .map(
                  (e) => Padding(
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
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => launcherViewModel.onTabContact(e),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundImage: e.photo != null
                                      ? MemoryImage(e.photo!)
                                      : null,
                                  child: e.photo == null
                                      ? Text(
                                          e.displayName
                                              .split(' ')
                                              .map((e) => e[0])
                                              .join()
                                              .toUpperCase()
                                              .substring(
                                                  0,
                                                  e.displayName
                                                              .split(' ')
                                                              .length >
                                                          1
                                                      ? 2
                                                      : 1),
                                          style: CupertinoTheme.of(context)
                                              .textTheme
                                              .textStyle
                                              .copyWith(
                                                fontSize: 24,
                                              ),
                                        )
                                      : null,
                                )),
                            Text(
                              e.displayName,
                              style: CupertinoTheme.of(context)
                                  .textTheme
                                  .navTitleTextStyle
                                  .copyWith(
                                      fontSize: 11.sp,
                                      color: CupertinoColors.systemGrey5,
                                      shadows: const [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: CupertinoColors.black,
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}
