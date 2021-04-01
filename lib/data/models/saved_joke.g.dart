// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_joke.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedJokeAdapter extends TypeAdapter<SavedJoke> {
  @override
  final int typeId = 0;

  @override
  SavedJoke read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedJoke(
      id: fields[0] as String,
      body: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SavedJoke obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedJokeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
