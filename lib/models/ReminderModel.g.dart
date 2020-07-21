// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReminderModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  ReminderModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      id: fields[0] as String,
      isAwrad: fields[1] as bool,
      days: (fields[2] as List)?.cast<int>(),
      times: (fields[3] as List)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isAwrad)
      ..writeByte(2)
      ..write(obj.days)
      ..writeByte(3)
      ..write(obj.times);
  }

  @override
  int get typeId => 0;
}
