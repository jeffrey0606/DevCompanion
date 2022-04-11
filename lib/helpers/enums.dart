import 'package:hive/hive.dart';

part 'enums.g.dart';

@HiveType(typeId: 2)
enum ProjectsTechType {
  @HiveField(0)
  flutter,
  @HiveField(1)
  android,
  @HiveField(2)
  swift,
  @HiveField(4)
  web,
}

enum ProjectPlatform {
  linux,
  windows,
  macos,
  android,
  ios,
}

@HiveType(typeId: 3)
enum ImageType {
  @HiveField(0)
  asset,
  @HiveField(1)
  file,
  @HiveField(2)
  network,
}

enum CustomMenuAlignment {
  left,
  right,
  top,
  bottom,
}

enum NavBarPages {
  overview,
  preview,
  assets,
  colorPicker,
}
