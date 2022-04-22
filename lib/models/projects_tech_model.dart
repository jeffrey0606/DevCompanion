import 'package:devcompanion/helpers/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'projects_tech_model.g.dart';

@HiveType(typeId: 0)
class ProjectsTechModel extends HiveObject {
  @HiveField(0)
  final String asset;

  @HiveField(1)
  final ProjectsTechType type;

  @HiveField(2)
  bool isActive;

  @HiveField(3)
  final String dimension;

  @HiveField(4)
  final int size;

  ProjectsTechModel({
    required this.asset,
    required this.type,
    required this.dimension,
    required this.size,
    this.isActive = false,
  });
}

@HiveType(typeId: 1)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ProjectsTechType type;

  @HiveField(3)
  final String location;

  @HiveField(4)
  String? logo;

  @HiveField(5)
  ImageType? logoType;

  @HiveField(6)
  String? dimension;

  @HiveField(7)
  int? size;

  @HiveField(8)
  List<Color>? logoColors;

  @HiveField(9)
  String? assetsPath;

  ProjectModel({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    this.logo,
    this.dimension,
    this.logoType,
    this.size,
    this.logoColors,
    this.assetsPath,
  });
}
