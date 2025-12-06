// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountsAdapter extends TypeAdapter<Counts> {
  @override
  final typeId = 0;

  @override
  Counts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Counts(
      count: (fields[0] as num).toInt(),
      date: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Counts obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
