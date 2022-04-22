import 'dart:io';

import 'package:devcompanion/providers/assets_provider.dart';
import 'package:devcompanion/views/pages/assets/file_card.dart';
import 'package:devcompanion/views/pages/assets/pick_asset_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Assets extends ConsumerWidget {
  const Assets({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _assetsProvider = ref.read(assetsProvider);
    final watcher = ref.watch(assetsProvider);

    if (watcher.folders.isEmpty) {
      return const PickAssetPath();
    } else {
      // return CustomScrollView(
      //   scrollDirection: Axis.horizontal,
      //   slivers: watcher.folders.map((folder) {
      //     final int index = watcher.folders.indexOf(folder);
      //     final List<FileSystemEntity> files = Directory(folder).listSync();

      //     return SliverToBoxAdapter(
      //       child: Card(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(8),
      //         ),
      //         elevation: 1.5,
      //         child: Container(
      //           padding: const EdgeInsets.all(1),
      //           decoration: BoxDecoration(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //           width: 200,
      //           height: double.infinity,
      //           child: SliverList(
      //             delegate: SliverChildBuilderDelegate(
      //               (context, index1) {
      //                 final FileSystemEntity file = files[index1];
      //                 return FileCard(
      //                   index: index1,
      //                   file: file,
      //                   isOpen: watcher.isOpen(file.path),
      //                   folderIndex: index,
      //                 );
      //               },
      //               childCount: files.length,
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   }).toList(),
      // );
      return ListView.builder(
        itemCount: watcher.folders.length,
        // controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final String folder = watcher.folders[index];
          final List<FileSystemEntity> files = Directory(folder).listSync();
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1.5,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              width: 200,
              height: double.infinity,
              child: ListView.builder(
                controller: ScrollController(),
                itemBuilder: (context, index1) {
                  final FileSystemEntity file = files[index1];
                  return FileCard(
                    index: index1,
                    file: file,
                    isOpen: watcher.isOpen(file.path),
                    folderIndex: index,
                  );
                },
                itemCount: files.length,
              ),
            ),
          );
        },
      );
    }
  }
}
