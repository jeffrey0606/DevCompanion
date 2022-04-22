import 'dart:developer';

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/contants.dart';
import 'package:devcompanion/models/nav_bar_pages_icon_model.dart';
import 'package:devcompanion/providers/assets_provider.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/providers/nav_bar_pages_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:devcompanion/views/components/custom_menu.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: 85,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1.5,
        child: Container(
          padding: const EdgeInsets.symmetric(
            // horizontal: 8,
            vertical: 15,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [
                primaryColor,
                primaryColor,
                secondaryColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: ProjectControl(),
              ),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Column(
                  children: navBarPagesIcon.map((pageIconModel) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: NavBarPageIconCard(
                        pageIconModel: pageIconModel,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Profile(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarPageIconCard extends ConsumerWidget {
  final NavBarPagesIconModel pageIconModel;
  const NavBarPageIconCard({
    Key? key,
    required this.pageIconModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(navBarPagesProvider).changePage(pageIconModel.page);
      },
      child: Consumer(
        builder: (context, watch, child) {
          final watcher = watch.watch(navBarPagesProvider);
          final bool isSelected = watcher.currentPage == pageIconModel.page;
          return AnimatedContainer(
            duration: const Duration(
              milliseconds: 200,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: isSelected ? activeColor : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 3,
            ),
            child: SizedBox(
              // width: 20,
              // height: 20,
              height: 21,
              child: DisplayImage(
                asset: pageIconModel.asset,
                color: isSelected ? activeColor : inActiveColor,
              ),
            ),
            // SvgPicture.asset(
            //  pageIconModel.asset,
            //   width: 20,
            //   color: isSelected ? activeColor : inActiveColor,
            // ),
          );
        },
      ),
    );
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  String getAsset() {
    switch (deviceInfo.platform) {
      case "Linux":
        return "assets/svgs/linux.svg";
      case "Windows":
        return "assets/svgs/windows.svg";
      case "MacOS":
        return "assets/svgs/macos.svg";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(50),
      // ),
      radius: 23,
      backgroundColor: backgroundColor,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DisplayImage(
            asset: getAsset(),
          ),
        ),
      ),
    );
  }
}

class ProjectControl extends ConsumerWidget {
  const ProjectControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 45,
      width: 45,
      child: CustomMenu(
        onDismissed: () {},
        onItemSelected: (item) {},
        // menuItems: [
        //   MenuItem(title: 'First item'),
        //   MenuItem(title: 'Second item'),
        //   MenuItem(
        //     title: 'Third item with submenu',
        //     items: [
        //       MenuItem(title: 'First subitem'),
        //       MenuItem(title: 'Second subitem'),
        //       MenuItem(title: 'Third subitem'),
        //     ],
        //   ),
        //   MenuItem(title: 'Fourth item'),
        // ],
        items: [
          InkWell(
            onTap: () async {
              final String? selectedDirectory =
                  await FilePicker.platform.getDirectoryPath(
                dialogTitle: "Add new project",
              );

              if (selectedDirectory != null) {
                log("add new project! $selectedDirectory");

                final _projectProvider = ref.read(projectProvider);

                if (_projectProvider.projectAlreadyExists(selectedDirectory)) {
                  f.showSnackbar(
                    context,
                    f.Snackbar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.cancel_rounded,
                            color: errorColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Project already exists ( ${path.basename(selectedDirectory)} )!',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  f.showSnackbar(
                    context,
                    f.Snackbar(
                      content: Row(
                        children: [
                          const Icon(
                            Icons.folder,
                            color: successColor,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'New project selected ( ${path.basename(selectedDirectory)} )!',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                  await _projectProvider.addNewProject(
                    selectedDirectory,
                  );
                  ref
                      .read(logoProvider)
                      .initSupportedPlatforms(_projectProvider.currentProject);
                  ref
                      .read(assetsProvider)
                      .initProjectAssets(_projectProvider.currentProject);
                }
              } else {
                f.showSnackbar(
                  context,
                  f.Snackbar(
                    content: Row(
                      children: const [
                        Icon(
                          Icons.cancel_rounded,
                          color: errorColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('No project selected!')
                      ],
                    ),
                  ),
                );
              }
            },
            child: const SizedBox(
              // width: 100,
              height: 35,
              child: Center(
                child: Text(
                  "new project",
                  style: TextStyle(
                    color: headerTextColor,
                  ),
                ),
              ),
            ),
          ),
          // CustomMenuItem(
          //   child: SizedBox(
          //     width: 100,
          //     height: 30,
          //     child: Text("data"),
          //   ),
          // ),
        ],
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: primaryColor,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
