import 'dart:developer';

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/logo/logo_provider.dart';
import 'package:devcompanion/providers/logo/replace_reset_varient_provider.dart';
import 'package:devcompanion/views/components/custom_menu.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' show showSnackbar, Snackbar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class OverviewCard extends StatefulWidget {
  final ProjectModel? projectModel;
  const OverviewCard({
    Key? key,
    required this.projectModel,
  }) : super(key: key);

  @override
  _OverviewCardState createState() => _OverviewCardState();
}

class _OverviewCardState extends State<OverviewCard> {
  late Future<List<Color>> _getLogoColors;

  @override
  void didUpdateWidget(covariant OverviewCard oldWidget) {
    if (widget.projectModel != null &&
        oldWidget.projectModel != null &&
        oldWidget.projectModel!.name != widget.projectModel!.name) {
      _getLogoColors = getLogoColors();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _getLogoColors = getLogoColors();
    super.initState();
  }

  Future<List<Color>> getLogoColors() async {
    if (widget.projectModel != null && widget.projectModel!.logo == null) {
      return [];
    }
    if (widget.projectModel!.logoColors != null) {
      return widget.projectModel!.logoColors!;
    }

    //TODO: update project's model with the colors
    return getImageColors(
      widget.projectModel!.logo!,
      widget.projectModel!.logoType!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Color>>(
      future: _getLogoColors,
      builder: (context, snapshot) {
        Color? color = snapshot.hasData && snapshot.data!.isNotEmpty
            ? snapshot.data!.first //.withBlue(0) //.withRed(255)
            : null;
        return SizedBox(
          width: double.infinity,
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                //color: color,
                // gradient: snapshot.hasData && snapshot.data!.isNotEmpty
                //     ? LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           // snapshot.data!.first,
                //           snapshot.data!.last.withOpacity(0.6),
                //           snapshot.data!.first,
                //         ],
                //       )
                //     : null,
              ),
              child: widget.projectModel == null
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          height: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 2,
                            // color: color,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: widget.projectModel!.logo == null
                                  ? const SizedBox(
                                      height: double.infinity,
                                      width: 120,
                                      child: Center(
                                        child: Text(
                                          "🚀",
                                          style: TextStyle(
                                            fontSize: 50,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: DisplayImage(
                                        asset: widget.projectModel!.logo!,
                                        imageType:
                                            widget.projectModel!.logoType!,
                                        fit: BoxFit.cover,
                                        useImageSize: false,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.projectModel!.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: headerTextColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.3,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      if (widget.projectModel!.dimension !=
                                          null)
                                        Text(
                                          widget.projectModel!.dimension!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: normalTextColor,
                                            fontSize: 18,
                                            letterSpacing: 1.3,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      if (widget.projectModel!.size != null)
                                        Text(
                                          humanFileSize(
                                              widget.projectModel!.size!),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            color: normalTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: const [
                                    ChangeLogoButton(),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    ModifyLogoVarient(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class ModifyLogoVarient extends ConsumerWidget {
  const ModifyLogoVarient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watcher = ref.watch(logoProvider);
    return CustomMenu(
      onDismissed: () {},
      onItemSelected: (item) {},
      onOpen: () {
        ref.refresh(replaceResetVarientProvider);
      },
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
        ...watcher.listOfProjectPlatforms.map(
          (platform) {
            return Consumer(
              builder: (context, watch, child) {
                final watcher1 = watch.watch(replaceResetVarientProvider);
                final isSelected =
                    watcher1.selectedPlatforms.contains(platform);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: SizedBox(
                    // width: 100,
                    height: 30,
                    child: InkWell(
                      onTap: () async {
                        final _replaceResetVarientProvider =
                            ref.read(replaceResetVarientProvider);

                        if (isSelected) {
                          _replaceResetVarientProvider.remove(platform);
                        } else {
                          _replaceResetVarientProvider.select(platform);
                        }
                      },
                      borderRadius: BorderRadius.circular(10),
                      splashColor: secondaryColor,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: primaryColor,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            platform.name,
                            style: const TextStyle(
                              color: headerTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        // const SizedBox(
        //   height: 5,
        //   width: double.infinity,
        // ),
        Consumer(builder: (context, watch, child) {
          final watcher1 = watch.watch(replaceResetVarientProvider);
          final bool isEmpty = watcher1.selectedPlatforms.isEmpty;
          return SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.grey,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      "reset",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: isEmpty
                        ? null
                        : () {
                            ref.read(replaceResetVarientProvider).replace();
                            Navigator.of(context).pop();
                          },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        successColor,
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const FittedBox(
                      child: Text(
                        "replace",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
      alignment: CustomMenuAlignment.bottom,
      fitContentToChildWidth: true,
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: infoColor,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 6,
        ),
        child: Row(
          children: const [
            Icon(
              Icons.update_rounded,
              color: Colors.white,
              // size: 18,
            ),
            Text(
              "update varients",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeLogoButton extends ConsumerWidget {
  const ChangeLogoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      onPressed: () async {
        final FilePickerResult? selectedFile =
            await FilePicker.platform.pickFiles(
          dialogTitle: "Select new logo",
          allowMultiple: false,
          allowedExtensions: ['png', 'webp'],
        );

        if (selectedFile != null) {
          log("add new logo! ${selectedFile.paths.first}");
          showSnackbar(
            context,
            Snackbar(
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
                    'New logo selected ( ${path.basename(selectedFile.paths.first!)} )!',
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          );
          ref.read(logoProvider).changeLogo(selectedFile.paths.first!);
        } else {
          showSnackbar(
            context,
            Snackbar(
              content: Row(
                children: const [
                  Icon(
                    Icons.cancel_rounded,
                    color: errorColor,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('No logo selected!')
                ],
              ),
            ),
          );
        }
      },
      icon: const Icon(
        Icons.image_outlined,
        color: Colors.white,
        size: 18,
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          infoColor,
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      label: const Text(
        "change logo",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w300,
          fontSize: 14,
        ),
      ),
    );
  }
}
