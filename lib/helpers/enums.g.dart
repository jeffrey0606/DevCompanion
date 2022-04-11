// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enums.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectsTechTypeAdapter extends TypeAdapter<ProjectsTechType> {
  @override
  final int typeId = 2;

  @override
  ProjectsTechType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectsTechType.flutter;
      case 1:
        return ProjectsTechType.android;
      case 2:
        return ProjectsTechType.swift;
      case 4:
        return ProjectsTechType.web;
      default:
        return ProjectsTechType.flutter;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectsTechType obj) {
    switch (obj) {
      case ProjectsTechType.flutter:
        writer.writeByte(0);
        break;
      case ProjectsTechType.android:
        writer.writeByte(1);
        break;
      case ProjectsTechType.swift:
        writer.writeByte(2);
        break;
      case ProjectsTechType.web:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectsTechTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageTypeAdapter extends TypeAdapter<ImageType> {
  @override
  final int typeId = 3;

  @override
  ImageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ImageType.asset;
      case 1:
        return ImageType.file;
      case 2:
        return ImageType.network;
      default:
        return ImageType.asset;
    }
  }

  @override
  void write(BinaryWriter writer, ImageType obj) {
    switch (obj) {
      case ImageType.asset:
        writer.writeByte(0);
        break;
      case ImageType.file:
        writer.writeByte(1);
        break;
      case ImageType.network:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
