import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetsProvider = ChangeNotifierProvider<AssetsProvider>(
  (ref) {
    return AssetsProvider(ref);
  },
);

class AssetsProvider extends ChangeNotifier {
  final Ref ref;
  AssetsProvider(this.ref);
  late ProjectModel projectModel;

  List<String> folders = [
    // '/home/jeff/Documents/FlutterProjects/DevCompanion/assets'
  ];

  bool isOpen(String path) {
    return folders.contains(path);
  }

  setProjectAssetsPath(String path1) {
    projectModel.assetsPath = path1;
    folders.add(path1);
    projectModel.save();
    notifyListeners();
    ref.read(projectProvider).updateProjectModel();
  }

  void initProjectAssets(ProjectModel projectModel) {
    this.projectModel = projectModel;
    // projectModel.assetsPath = null;
    // projectModel.save();
    folders.clear();
    if (projectModel.assetsPath != null) {
      folders.add(projectModel.assetsPath!);
    }

    notifyListeners();
  }

  void closeAssetFolder(String path) {
    final thisFolderIndex = folders.indexOf(path);
    final int len = folders.length;
    folders.removeRange(thisFolderIndex, len);

    notifyListeners();
  }

  void openAssetFolder(String path1, int folderIndex) {
    // final String parentFolder = path.basename(path1);
    final int len = folders.length;
    folders.removeRange(folderIndex + 1, len);

    folders.add(path1);
    notifyListeners();
  }
}
