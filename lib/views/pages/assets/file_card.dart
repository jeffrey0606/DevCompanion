import 'dart:io';

import 'package:devcompanion/helpers/colors.dart';
import 'package:devcompanion/providers/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class FileCard extends ConsumerWidget {
  final FileSystemEntity file;
  final int index;
  final bool isOpen;
  final int folderIndex;
  const FileCard({
    Key? key,
    required this.index,
    required this.file,
    this.isOpen = false,
    required this.folderIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final FileStat stat = file.statSync();
    final _assetsProvider = ref.read(assetsProvider);
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 1,
        child: InkWell(
          onTap: stat.type == FileSystemEntityType.directory
              ? () async {
                  if (isOpen) {
                    _assetsProvider.closeAssetFolder(
                      file.path,
                    );
                  } else {
                    _assetsProvider.openAssetFolder(
                      file.path,
                      folderIndex,
                    );
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(10),
          splashColor: secondaryColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isOpen ? 4 : 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: isOpen
                  ? Border.all(
                      color: primaryColor,
                      width: 4,
                    )
                  : null,
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                path.basename(file.path),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
