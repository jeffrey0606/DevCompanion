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

class ProjectsContent extends StatelessWidget {
  const ProjectsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _projectProvider = context.read(projectProvider);
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
                  final watcher1 = watch(navBarPagesProvider);

                  final name = _projectProvider.noProjectFound
                      ? "Empty"
                      : _projectProvider.currentProject.name;
                  return Text(
                    "Project ( $name )'s - ${watcher1.currentPage.name.firstCharToUpperCase()}",
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
                final watcher1 = watch(navBarPagesProvider);
                switch (watcher1.currentPage) {
                  case NavBarPages.overview:
                    return Overview();
                  case NavBarPages.preview:
                    return const Preview();
                  case NavBarPages.assets:
                    return const Assets();
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
