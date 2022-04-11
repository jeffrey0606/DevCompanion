import 'dart:developer';

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/views/components/display_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' show showSnackbar, Snackbar;
import 'package:flutter/material.dart';
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                  : DisplayImage(
                                      asset: widget.projectModel!.logo!,
                                      imageType: widget.projectModel!.logoType!,
                                      fit: BoxFit.cover,
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
                                const ChangeLogoButton(),
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

class ChangeLogoButton extends StatelessWidget {
  const ChangeLogoButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        final FilePickerResult? selectedFile =
            await FilePicker.platform.pickFiles(
          dialogTitle: "Select new logo",
          allowMultiple: false,
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
