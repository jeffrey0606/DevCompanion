// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init_params.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InitParamsAdapter extends TypeAdapter<InitParams> {
  @override
  final int typeId = 4;

  @override
  InitParams read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InitParams(
      isFirstTime: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InitParams obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.isFirstTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InitParamsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
