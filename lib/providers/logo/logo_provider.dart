import 'dart:io';

import 'package:devcompanion/helpers/contants.dart';
import 'package:devcompanion/helpers/enums.dart';
import 'package:devcompanion/helpers/functions.dart';
import 'package:devcompanion/models/logo_models.dart';
import 'package:devcompanion/models/projects_tech_model.dart';
import 'package:devcompanion/providers/project_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart';
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
    return LogoProvider(ref);
  },
);

class LogoProvider extends ChangeNotifier {
  final Ref ref;
  LogoProvider(this.ref);
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

  void changeLogo(String logoPath) async {
    String newLogoPath = path.join(
      await saveStuffsDir('logos'),
      path.basename(logoPath),
    );

    final file = await File(logoPath).copy(newLogoPath);
    projectModel.logo = file.path;
    projectModel.logoType = ImageType.file;
    projectModel.size = file.statSync().size;
    projectModel.dimension =
        toDimension(await getImageSize(newLogoPath, ImageType.file));
    projectModel.save();

    ref.read(projectProvider).updateProjectModel();
  }

  void replaceLogoVarients(List<ProjectPlatform> selectedPlatforms) async {
    isLoading = true;
    if (projectModel.type == ProjectsTechType.flutter) {
      for (var platform in selectedPlatforms) {
        LogoVarientModel varient = flutterLogoVarients
            .firstWhere((element) => element.projectPlatform == platform)
            .copyWith();
        List<LogoModel> data = [];

        // supportedProjectPlatforms.remove(varient.projectPlatform);

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

        // Read an image from file (webp in this case).
        // decodeImage will identify the format of the image and use the appropriate
        // decoder.
        final image = decodeImage(File(projectModel.logo!).readAsBytesSync())!;

        for (var logoVarient in data) {
          final Size varientDimension = logoVarient.dimension;
          // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
          final thumbnail = copyResize(
            image,
            width: varientDimension.width.toInt(),
            height: varientDimension.height.toInt(),
          );
          final String mimeType =
              mime(logoVarient.path) ?? path.extension(logoVarient.path);
          late List<int>? encodedImage;
          if (mimeType.contains('png')) {
            encodedImage = encodePng(thumbnail);
          } else if (mimeType.contains('webp')) {
          } else if (mimeType.contains('ico')) {
            encodedImage = encodeIco(thumbnail);
          }
          if (encodedImage != null) {
            // Save the thumbnail as a Varient extension.
            File(logoVarient.path).writeAsBytesSync(
              encodedImage,
              flush: true,
            );
          }
        }

        if (data.isNotEmpty) {
          supportedProjectPlatforms.update(
            varient.projectPlatform,
            (value) => data,
            ifAbsent: () => data,
          );

          notifyListeners();
          ref.read(projectProvider).updateProjectModel();
        }
      }
    } else {
      throw ('replacing logo varients for [${projectModel.type} Type] is not yet supported');
    }
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
    } else {
      throw ('logo varients for [${projectModel.type} Type] is not yet supported');
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
