// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReminderModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderModelAdapter extends TypeAdapter<ReminderModel> {
  @override
  final int typeId = 0;

  @override
  ReminderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReminderModel(
      id: fields[0] as String,
      isAwrad: fields[1] as bool,
      days: (fields[2] as List)?.cast<int>(),
      times: (fields[3] as List)?.cast<int>(),
      type: fields[4] as String,
      wrdName: fields[5] as String,
      wrdText: fields[6] as String,
      notifId: fields[7] as int,
      link: fields[8] as String,
      hasSound: fields[9] as bool,
      daysNew: (fields[10] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isAwrad)
      ..writeByte(2)
      ..write(obj.days)
      ..writeByte(3)
      ..write(obj.times)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.wrdName)
      ..writeByte(6)
      ..write(obj.wrdText)
      ..writeByte(7)
      ..write(obj.notifId)
      ..writeByte(8)
      ..write(obj.link)
      ..writeByte(9)
      ..write(obj.hasSound)
      ..writeByte(10)
      ..write(obj.daysNew);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
