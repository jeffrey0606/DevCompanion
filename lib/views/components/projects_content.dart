import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/providers/nav_bar_pages_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:devcompanion/views/pages/assets/assets.dart';
import 'package:devcompanion/views/pages/color_picker/color_picker.dart';
import 'package:devcompanion/views/pages/overview/overview.dart';
import 'package:devcompanion/views/pages/preview/preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/extensions.dart';

class ProjectsContent extends ConsumerWidget {
  const ProjectsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _projectProvider = ref.read(projectProvider);
    return SizedBox(
      height: double.infinity,
      width: 280,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1.3,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Consumer(
                builder: (context, watch, child) {
                  final watcher1 = watch.watch(navBarPagesProvider);
                  final watcher2 = watch.watch(projectProvider);

                  final String name = watcher2.noProjectFound
                      ? "Empty"
                      : watcher2.currentProject.name;
                  final String pageName =
                      watcher1.currentPage.name.firstCharToUpperCase();
                  return Text(
                    "Project ( $name )'s - $pageName",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: headerTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final watcher1 = watch.watch(navBarPagesProvider);
                switch (watcher1.currentPage) {
                  case NavBarPages.overview:
                    return Overview();
                  case NavBarPages.preview:
                    return const Preview();
                  case NavBarPages.assets:
                    return Assets();
                  case NavBarPages.colorPicker:
                    return const ColorPicker();
                  default:
                    return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
