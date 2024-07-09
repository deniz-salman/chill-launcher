import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launcher/views/launcher_view.dart';

class GoogleSearchView extends ConsumerWidget {
  const GoogleSearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final launcherViewModel = ref.watch(launcherViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (launcherViewModel.searchController.text.isNotEmpty)
          ...launcherViewModel.googleSuggestions
              .map(
                (e) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CupertinoListTile(
                      backgroundColor: CupertinoTheme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(.50),
                      trailing: const Icon(
                        CupertinoIcons.search,
                      ),
                      title: Text(e),
                      onTap: () => launcherViewModel.onTabGoogleSuggestion(e),
                    ),
                  ),
                ),
              )
              .toList(growable: false)
      ],
    );
  }
}
