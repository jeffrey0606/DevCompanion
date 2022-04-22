import 'dart:developer';

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/providers/assets_provider.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart' show showSnackbar, Snackbar;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class PickAssetPath extends ConsumerWidget {
  const PickAssetPath({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1.3,
          child: InkWell(
            onTap: () async {
              final String? selectedFile =
                  await FilePicker.platform.getDirectoryPath(
                dialogTitle: "choose assets folder",
                initialDirectory:
                    ref.read(projectProvider).currentProject.location,
                lockParentWindow: true,
              );

              if (selectedFile != null) {
                log("assets path seleceted! $selectedFile");
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
                          'Assets path seleceted ( ${path.basename(selectedFile)} )!',
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                );
                ref.read(assetsProvider).setProjectAssetsPath(selectedFile);
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
            borderRadius: BorderRadius.circular(10),
            splashColor: secondaryColor,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              // width: double.infinity,
              child: const Text(
                "💼  Locate the assets folder of this project",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: headerTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
