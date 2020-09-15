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
      type: fields[2] as String,
      wrdName: fields[3] as String,
      wrdText: fields[4] as String,
      notifId: fields[5] as int,
      link: fields[6] as String,
      hasSound: fields[7] as bool,
      daysNew: (fields[8] as List)?.cast<String>(),
      isPdf: fields[9] as bool,
      pdfLink: fields[10] as String,
      isJuz: fields[11] as bool,
      juzPage: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReminderModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isAwrad)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.wrdName)
      ..writeByte(4)
      ..write(obj.wrdText)
      ..writeByte(5)
      ..write(obj.notifId)
      ..writeByte(6)
      ..write(obj.link)
      ..writeByte(7)
      ..write(obj.hasSound)
      ..writeByte(8)
      ..write(obj.daysNew)
      ..writeByte(9)
      ..write(obj.isPdf)
      ..writeByte(10)
      ..write(obj.pdfLink)
      ..writeByte(11)
      ..write(obj.isJuz)
      ..writeByte(12)
      ..write(obj.juzPage);
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
