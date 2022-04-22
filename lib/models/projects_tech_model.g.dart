// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_tech_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectsTechModelAdapter extends TypeAdapter<ProjectsTechModel> {
  @override
  final int typeId = 0;

  @override
  ProjectsTechModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectsTechModel(
      asset: fields[0] as String,
      type: fields[1] as ProjectsTechType,
      dimension: fields[3] as String,
      size: fields[4] as int,
      isActive: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectsTechModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.asset)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.dimension)
      ..writeByte(4)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectsTechModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 1;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as ProjectsTechType,
      location: fields[3] as String,
      logo: fields[4] as String?,
      dimension: fields[6] as String?,
      logoType: fields[5] as ImageType?,
      size: fields[7] as int?,
      logoColors: (fields[8] as List?)?.cast<Color>(),
      assetsPath: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.logo)
      ..writeByte(5)
      ..write(obj.logoType)
      ..writeByte(6)
      ..write(obj.dimension)
      ..writeByte(7)
      ..write(obj.size)
      ..writeByte(8)
      ..write(obj.logoColors)
      ..writeByte(9)
      ..write(obj.assetsPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
