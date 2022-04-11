import 'dart:io';

import 'package:devcompanion/helpers/contants.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/models/logo_models.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as path;

// class LogoProviderEqualizer extends Equatable {
//   final ProjectModel projectModel;
//   const LogoProviderEqualizer({
//     required this.projectModel,
//   });
//   @override
//   List<Object> get props => [projectModel.id];
// }

// final logoProvider =
//     ChangeNotifierProvider.family<LogoProvider, LogoProviderEqualizer>(
//   (ref, logoProviderEqualizer) {
//     return LogoProvider(logoProviderEqualizer.projectModel);
//   },
// );

final logoProvider = ChangeNotifierProvider<LogoProvider>(
  (ref) {
    return LogoProvider();
  },
);

class LogoProvider extends ChangeNotifier {
  Map<ProjectPlatform, List<LogoModel>> supportedProjectPlatforms = {};

  List<ProjectPlatform> get listOfProjectPlatforms {
    return supportedProjectPlatforms.keys.toList();
  }

  late ProjectModel projectModel;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void initSupportedPlatforms(ProjectModel projectModel) async {
    isLoading = true;
    this.projectModel = projectModel;
    supportedProjectPlatforms.clear();
    if (projectModel.type == ProjectsTechType.flutter) {
      for (var varient in flutterLogoVarients.map(
        (e) => e.copyWith(),
      )) {
        List<LogoModel> data = [];

        if (varient.projectPlatform == ProjectPlatform.linux) {
          data = await getLinuxLogo(varient);
        } else if (varient.projectPlatform == ProjectPlatform.android) {
          varient.path = path.join(
            "android",
            varient.path,
          );
          data = await getAndroidLogo(varient);
        } else if (varient.projectPlatform == ProjectPlatform.ios) {
          data = await getMacosIosLogo(varient);
        } else if (varient.projectPlatform == ProjectPlatform.macos) {
          data = await getMacosIosLogo(varient);
        } else if (varient.projectPlatform == ProjectPlatform.windows) {
          data = await getWindowsLogo(varient);
        }

        if (data.isNotEmpty) {
          supportedProjectPlatforms.update(
            varient.projectPlatform,
            (value) => data,
            ifAbsent: () => data,
          );
        }
      }
    } else if (projectModel.type == ProjectsTechType.android) {
      List<LogoModel> data = await getAndroidLogo(androidLogoVarient);

      if (data.isNotEmpty) {
        supportedProjectPlatforms.update(
          androidLogoVarient.projectPlatform,
          (value) => data,
          ifAbsent: () => data,
        );
      }
    }

    isLoading = false;
  }

  Future<List<LogoModel>> getWindowsLogo(LogoVarientModel varient) async {
    List<LogoModel> temp = [];
    final dir = Directory(
      path.join(projectModel.location, varient.path),
    );
    if (!(await dir.exists())) {
      return temp;
    }
    for (var file in dir.listSync()) {
      final String fileName = path.basename(file.path);
      final String mimeType = mime(fileName) ?? path.extension(file.path);
      // print("file : $fileName | mimeType: $mimeType");
      if (mimeType.contains("image")) {
        final Size dimension = await getImageSize(file.path, ImageType.file);
        final int size = (await file.stat()).size;
        temp.add(
          LogoModel(
            dimension: dimension,
            path: file.path,
            size: size,
          ),
        );
      }
    }

    temp.sort((a, b) => (b.dimension.height - a.dimension.height).toInt());
    return temp;
  }

  Future<List<LogoModel>> getAndroidLogo(LogoVarientModel varient) async {
    List<LogoModel> temp = [];
    final dir = Directory(
      path.join(projectModel.location, varient.path),
    );
    if (!(await dir.exists())) {
      return temp;
    }

    for (var image in (varient.contentJson["images"] as List<Map>)) {
      File file = File(path.join(dir.path, image["folder"], image["filename"]));

      if (!(await file.exists())) {
        file =
            File(path.join(dir.path, image["folder"], image["alt_filename"]));
      }

      final int size = (await file.stat()).size;

      // Size s = await getImageSize(file.path, ImageType.file);

      temp.add(
        LogoModel(
          dimension: fromDimension(image["size"]),
          path: file.path,
          size: size,
        ),
      );
    }

    temp.sort((a, b) => (b.dimension.height - a.dimension.height).toInt());
    return temp;
  }

  Future<List<LogoModel>> getMacosIosLogo(LogoVarientModel varient) async {
    List<LogoModel> temp = [];
    final dir = Directory(
      path.join(projectModel.location, varient.path),
    );
    if (!(await dir.exists())) {
      return temp;
    }
    for (var file in dir.listSync()) {
      final String fileName = path.basename(file.path);
      final String mimeType = mime(fileName) ?? path.extension(file.path);
      // print("file : $fileName | mimeType: $mimeType");
      if (mimeType.contains("image")) {
        final Size dimension = await getImageSize(file.path, ImageType.file);
        final int size = (await file.stat()).size;
        temp.add(
          LogoModel(
            dimension: dimension,
            path: file.path,
            size: size,
          ),
        );
      }
    }

    temp.sort((a, b) => (b.dimension.height - a.dimension.height).toInt());
    return temp;
  }

  Future<List<LogoModel>> getLinuxLogo(LogoVarientModel varient) async {
    List<LogoModel> temp = [];
    final debianGuiDir = Directory(
      path.join(projectModel.location, varient.path),
    );
    final snapGuiDir = Directory(
      path.join(projectModel.location, varient.altPath),
    );
    for (var dir in [debianGuiDir, snapGuiDir]) {
      if (!(await dir.exists())) {
        continue;
      }
      if (await dir.exists()) {
        for (var file in dir.listSync()) {
          final String fileName = path.basename(file.path);
          final String mimeType = mime(fileName) ?? path.extension(file.path);
          // print("file : $fileName | mimeType: $mimeType");
          if (mimeType.contains("image")) {
            final Size dimension =
                await getImageSize(file.path, ImageType.file);
            final int size = (await file.stat()).size;
            temp.add(
              LogoModel(
                dimension: dimension,
                path: file.path,
                size: size,
              ),
            );
          }
        }
      }
    }
    temp.sort((a, b) => (b.dimension.height - a.dimension.height).toInt());
    return temp;
  }
}
