import 'package:devcompanion/helpers/enums.dart';
import 'package:flutter/cupertino.dart';

class LogoModel {
  final Size dimension;
  final int size;
  final String path;
  const LogoModel({
    required this.dimension,
    required this.size,
    required this.path,
  });
}

class LogoVarientModel {
  final ProjectPlatform projectPlatform;
  final Map contentJson;
  String path;
  final String? altPath;
  LogoVarientModel({
    this.altPath,
    required this.contentJson,
    required this.path,
    required this.projectPlatform,
  });

  LogoVarientModel copyWith() {
    return LogoVarientModel(
      contentJson: contentJson,
      path: path,
      projectPlatform: projectPlatform,
      altPath: altPath,
    );
  }
}
